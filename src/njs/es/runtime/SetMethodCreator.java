package es.runtime;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.SwitchPoint;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;

import es.runtime.linker.NashornCallSiteDescriptor;
import es.runtime.linker.NashornGuards;
import static es.lookup.Lookup.MH;
import static es.runtime.ECMAErrors.referenceError;
import static es.runtime.JSType.getAccessorTypeIndex;

/**
 * Instances of this class are quite ephemeral; they only exist for the duration of an invocation of {@link ScriptObject#findSetMethod(CallSiteDescriptor, jdk.dynalink.linker.LinkRequest)} and serve as the actual encapsulation of the algorithm for creating an appropriate property setter method.
 */
final class SetMethodCreator {

  // See constructor parameters for description of fields
  private final ScriptObject sobj;
  private final PropertyMap map;
  private final FindProperty find;
  private final CallSiteDescriptor desc;
  private final Class<?> type;
  private final LinkRequest request;

  /**
   * Creates a new property setter method creator.
   * @param sobj the object for which we're creating the property setter
   * @param find a result of a {@link ScriptObject#findProperty(Object, boolean)} on the object for the property we want to create a setter for. Can be null if the property does not yet exist on the object.
   * @param desc the descriptor of the call site that triggered the property setter lookup
   * @param request the link request
   */
  SetMethodCreator(ScriptObject sobj, FindProperty find, CallSiteDescriptor desc, LinkRequest request) {
    this.sobj = sobj;
    this.map = sobj.getMap();
    this.find = find;
    this.desc = desc;
    this.type = desc.getMethodType().parameterType(1);
    this.request = request;
  }

  String getName() {
    return NashornCallSiteDescriptor.getOperand(desc);
  }

  PropertyMap getMap() {
    return map;
  }

  /**
   * Creates the actual guarded invocation that represents the dynamic setter method for the property.
   * @return the actual guarded invocation that represents the dynamic setter method for the property.
   */
  GuardedInvocation createGuardedInvocation(SwitchPoint builtinSwitchPoint) {
    return createSetMethod(builtinSwitchPoint).createGuardedInvocation();
  }

  /**
   * This class encapsulates the results of looking up a setter method; it's basically a triple of a method handle, a Property object, and flags for invocation.
   */
  private class SetMethod {

    private final MethodHandle methodHandle;
    private final Property property;

    /**
     * Creates a new lookup result.
     * @param methodHandle the actual method handle
     * @param property the property object. Can be null in case we're creating a new property in the global object.
     */
    SetMethod(MethodHandle methodHandle, Property property) {
      assert methodHandle != null;
      this.methodHandle = methodHandle;
      this.property = property;
    }

    /**
     * Composes from its components an actual guarded invocation that represents the dynamic setter method for the property.
     * @return the composed guarded invocation that represents the dynamic setter method for the property.
     */
    GuardedInvocation createGuardedInvocation() {
      // getGuard() and getException() either both return null, or neither does.
      // The reason for that is that now getGuard returns a map guard that casts its argument to ScriptObject, and if that fails, we need to relink on ClassCastException.
      var explicitInstanceOfCheck = NashornGuards.explicitInstanceOfCheck(desc, request);
      return new GuardedInvocation(methodHandle, NashornGuards.getGuard(sobj, property, desc, explicitInstanceOfCheck), (SwitchPoint) null, explicitInstanceOfCheck ? null : ClassCastException.class);
    }
  }

  SetMethod createSetMethod(SwitchPoint builtinSwitchPoint) {
    if (find != null) {
      return createExistingPropertySetter();
    }
    checkCreateNewVariable();
    return sobj.isScope() ? createGlobalPropertySetter() : createNewPropertySetter(builtinSwitchPoint);
  }

  void checkCreateNewVariable() {
    // assignment can not create a new variable.
    // See also ECMA Annex C item 4. ReferenceError is thrown.
    if (NashornCallSiteDescriptor.isScope(desc)) {
      throw referenceError("not.defined", getName());
    }
  }

  SetMethod createExistingPropertySetter() {
    var property = find.getProperty();
    MethodHandle methodHandle;
    if (NashornCallSiteDescriptor.isDeclaration(desc) && property.needsDeclaration()) {
      // This is a LET or CONST being declared.
      // The property is already there but flagged as needing declaration.
      // We create a new PropertyMap with the flag removed.
      // The map is installed with a fast compare-and-set method if the pre-callsite map is stable (which should be the case for function scopes except for non-strict functions containing eval() with var).
      // Otherwise we have to use a slow setter that creates a new PropertyMap on the fly.
      var oldMap = getMap();
      var newProperty = property.removeFlags(Property.NEEDS_DECLARATION);
      var newMap = oldMap.replaceProperty(property, newProperty);
      var fastSetter = find.replaceProperty(newProperty).getSetter(type, request);
      var slowSetter = MH.insertArguments(ScriptObject.DECLARE_AND_SET, 1, getName()).asType(fastSetter.type());
      // cas map used as guard, if true that means we can do the set fast
      var casMap = MH.insertArguments(ScriptObject.CAS_MAP, 1, oldMap, newMap);
      casMap = MH.dropArguments(casMap, 1, type);
      casMap = MH.asType(casMap, casMap.type().changeParameterType(0, Object.class));
      methodHandle = MH.guardWithTest(casMap, fastSetter, slowSetter);
    } else {
      methodHandle = find.getSetter(type, request);
    }
    assert methodHandle != null;
    assert property != null;
    var boundHandle = find.isInheritedOrdinaryProperty() ? ScriptObject.addProtoFilter(methodHandle, find.getProtoChainLength()) : methodHandle;
    return new SetMethod(boundHandle, property);
  }

  SetMethod createGlobalPropertySetter() {
    ScriptObject global = Context.getGlobal();
    return new SetMethod(MH.filterArguments(global.addSpill(type, getName()), 0, ScriptObject.GLOBALFILTER), null);
  }

  SetMethod createNewPropertySetter(SwitchPoint builtinSwitchPoint) {
    var sm = map.getFreeFieldSlot() > -1 ? createNewFieldSetter(builtinSwitchPoint) : createNewSpillPropertySetter(builtinSwitchPoint);
    map.propertyChanged(sm.property);
    return sm;
  }

  SetMethod createNewSetter(Property property, SwitchPoint builtinSwitchPoint) {
    property.setBuiltinSwitchPoint(builtinSwitchPoint);
    var oldMap = getMap();
    var newMap = getNewMap(property);
    var name = NashornCallSiteDescriptor.getOperand(desc);
    // fast type specific setter
    var fastSetter = property.getSetter(type, newMap); //0 sobj, 1 value, slot folded for spill property already
    //slow setter, that calls ScriptObject.set with appropriate type and key name
    var slowSetter = ScriptObject.SET_SLOW[getAccessorTypeIndex(type)];
    slowSetter = MH.insertArguments(slowSetter, 3, NashornCallSiteDescriptor.getFlags(desc));
    slowSetter = MH.insertArguments(slowSetter, 1, name);
    slowSetter = MH.asType(slowSetter, slowSetter.type().changeParameterType(0, Object.class));
    assert slowSetter.type().equals(fastSetter.type()) : "slow=" + slowSetter + " != fast=" + fastSetter;
    // cas map used as guard, if true that means we can do the set fast
    var casMap = MH.insertArguments(ScriptObject.CAS_MAP, 1, oldMap, newMap);
    casMap = MH.dropArguments(casMap, 1, type);
    casMap = MH.asType(casMap, casMap.type().changeParameterType(0, Object.class));
    var casGuard = MH.guardWithTest(casMap, fastSetter, slowSetter);
    // outermost level needs an extendable check.
    // if object can be extended, guard is true and we can run the cas setter.
    // The setter goes to "nop" VOID_RETURN if false or throws an exception if object is not extensible
    var extCheck = MH.insertArguments(ScriptObject.EXTENSION_CHECK, 1, true, name);
    extCheck = MH.asType(extCheck, extCheck.type().changeParameterType(0, Object.class));
    extCheck = MH.dropArguments(extCheck, 1, type);
    var nop = JSType.VOID_RETURN.methodHandle();
    nop = MH.dropArguments(nop, 0, Object.class, type);
    return new SetMethod(MH.asType(MH.guardWithTest(extCheck, casGuard, nop), fastSetter.type()), property);
  }

  SetMethod createNewFieldSetter(SwitchPoint builtinSwitchPoint) {
    return createNewSetter(new AccessorProperty(getName(), getFlags(sobj), sobj.getClass(), getMap().getFreeFieldSlot(), type), builtinSwitchPoint);
  }

  SetMethod createNewSpillPropertySetter(SwitchPoint builtinSwitchPoint) {
    return createNewSetter(new SpillProperty(getName(), getFlags(sobj), getMap().getFreeSpillSlot(), type), builtinSwitchPoint);
  }

  PropertyMap getNewMap(Property property) {
    return getMap().addProperty(property);
  }

  static int getFlags(ScriptObject scriptObject) {
    return scriptObject.useDualFields() ? Property.DUAL_FIELDS : 0;
  }

}
