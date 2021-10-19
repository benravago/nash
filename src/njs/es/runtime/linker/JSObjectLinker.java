package es.runtime.linker;

import java.util.Map;
import java.util.Objects;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.StandardOperation;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;
import jdk.dynalink.linker.LinkerServices;
import jdk.dynalink.linker.TypeBasedGuardingDynamicLinker;

import nash.scripting.JSObject;
import nash.scripting.ScriptObjectMirror;

import es.lookup.MethodHandleFactory;
import es.lookup.MethodHandleFunctionality;
import es.runtime.Context;
import es.runtime.JSType;
import es.runtime.ScriptRuntime;
import es.objects.Global;
import static es.runtime.JSType.isString;

/**
 * A Dynalink linker to handle web browser built-in JS (DOM etc.) objects as well as ScriptObjects from other Nashorn contexts.
 */
final class JSObjectLinker implements TypeBasedGuardingDynamicLinker {

  private final NashornBeansLinker nashornBeansLinker;

  JSObjectLinker(NashornBeansLinker nashornBeansLinker) {
    this.nashornBeansLinker = nashornBeansLinker;
  }

  @Override
  public boolean canLinkType(Class<?> type) {
    return canLinkTypeStatic(type);
  }

  static boolean canLinkTypeStatic(Class<?> type) {
    // can link JSObject also handles Map (this includes Bindings) to make sure those are not JSObjects.
    return Map.class.isAssignableFrom(type) || JSObject.class.isAssignableFrom(type);
  }

  @Override
  public GuardedInvocation getGuardedInvocation(LinkRequest request, LinkerServices linkerServices) throws Exception {
    var self = request.getReceiver();
    var desc = request.getCallSiteDescriptor();
    if (self == null || !canLinkTypeStatic(self.getClass())) {
      return null;
    }
    GuardedInvocation inv;
    if (self instanceof JSObject) {
      inv = lookup(desc, request, linkerServices);
      inv = inv.replaceMethods(linkerServices.filterInternalObjects(inv.getInvocation()), inv.getGuard());
    } else if (self instanceof Map) {
      // guard to make sure the Map or Bindings does not turn into JSObject later!
      var beanInv = nashornBeansLinker.getGuardedInvocation(request, linkerServices);
      inv = new GuardedInvocation(beanInv.getInvocation(), NashornGuards.combineGuards(beanInv.getGuard(), NashornGuards.getNotJSObjectGuard()));
    } else {
      throw new AssertionError("got instanceof: " + self.getClass()); // Should never reach here.
    }
    return Bootstrap.asTypeSafeReturn(inv, linkerServices, desc);
  }

  GuardedInvocation lookup(CallSiteDescriptor desc, LinkRequest request, LinkerServices linkerServices) throws Exception {
    var op = NashornCallSiteDescriptor.getBaseOperation(desc);
    if (op instanceof StandardOperation so) {
      var name = NashornCallSiteDescriptor.getOperand(desc);
      switch (so) {
        case GET -> {
          if (NashornCallSiteDescriptor.hasStandardNamespace(desc)) {
            return (name != null) ? findGetMethod(name) : findGetIndexMethod(nashornBeansLinker.getGuardedInvocation(request, linkerServices));
            // For indexed get, we want get GuardedInvocation beans linker and pass it.
            // JSObjectLinker.get uses this fallback getter for explicit signature method access.
          }
        }
        case SET -> {
          if (NashornCallSiteDescriptor.hasStandardNamespace(desc)) {
            return name != null ? findSetMethod(name) : findSetIndexMethod();
          }
        }
        case REMOVE -> {
          if (NashornCallSiteDescriptor.hasStandardNamespace(desc)) {
            return new GuardedInvocation(
              name == null ? JSOBJECTLINKER_DEL : MH.insertArguments(JSOBJECTLINKER_DEL, 1, name), IS_JSOBJECT_GUARD);
          }
        }
        case CALL -> {
          return findCallMethod(desc);
        }
        case NEW -> {
          return findNewMethod(desc);
        }
        // default: pass
      }
    }
    return null;
  }

  static GuardedInvocation findGetMethod(String name) {
    var getter = MH.insertArguments(JSOBJECT_GETMEMBER, 1, name);
    return new GuardedInvocation(getter, IS_JSOBJECT_GUARD);
  }

  static GuardedInvocation findGetIndexMethod(GuardedInvocation inv) {
    var getter = MH.insertArguments(JSOBJECTLINKER_GET, 0, inv.getInvocation());
    return inv.replaceMethods(getter, inv.getGuard());
  }

  static GuardedInvocation findSetMethod(String name) {
    var getter = MH.insertArguments(JSOBJECT_SETMEMBER, 1, name);
    return new GuardedInvocation(getter, IS_JSOBJECT_GUARD);
  }

  static GuardedInvocation findSetIndexMethod() {
    return new GuardedInvocation(JSOBJECTLINKER_PUT, IS_JSOBJECT_GUARD);
  }

  static GuardedInvocation findCallMethod(CallSiteDescriptor desc) {
    var mh = NashornCallSiteDescriptor.isScope(desc) ? JSOBJECT_SCOPE_CALL : JSOBJECT_CALL;
    if (NashornCallSiteDescriptor.isApplyToCall(desc)) {
      mh = MH.insertArguments(JSOBJECT_CALL_TO_APPLY, 0, mh);
    }
    var type = desc.getMethodType();
    if (type.parameterType(type.parameterCount() - 1) != Object[].class) {
      mh = MH.asCollector(mh, Object[].class, type.parameterCount() - 2);
    }
    return new GuardedInvocation(mh, IS_JSOBJECT_GUARD);
  }

  static GuardedInvocation findNewMethod(CallSiteDescriptor desc) {
    var func = MH.asCollector(JSOBJECT_NEW, Object[].class, desc.getMethodType().parameterCount() - 1);
    return new GuardedInvocation(func, IS_JSOBJECT_GUARD);
  }

  @SuppressWarnings("unused")
  static boolean isJSObject(Object self) {
    return self instanceof JSObject;
  }

  @SuppressWarnings("unused")
  static Object get(MethodHandle fallback, Object jsobj, Object key) throws Throwable {
    if (key instanceof Integer i) {
      return ((JSObject) jsobj).getSlot(i);
    } else if (key instanceof Number n) {
      var index = getIndex(n);
      if (index > -1) {
        return ((JSObject) jsobj).getSlot(index);
      } else {
        return ((JSObject) jsobj).getMember(JSType.toString(key));
      }
    } else if (isString(key)) {
      var name = key.toString();
      // get with method name and signature. delegate it to beans linker!
      if (name.indexOf('(') != -1) {
        return fallback.invokeExact(jsobj, (Object) name);
      }
      return ((JSObject) jsobj).getMember(name);
    }
    return null;
  }

  @SuppressWarnings("unused")
  static void put(Object jsobj, Object key, Object value) {
    if (key instanceof Integer i) {
      ((JSObject) jsobj).setSlot(i, value);
    } else if (key instanceof Number n) {
      var index = getIndex(n);
      if (index > -1) {
        ((JSObject) jsobj).setSlot(index, value);
      } else {
        ((JSObject) jsobj).setMember(JSType.toString(key), value);
      }
    } else if (isString(key)) {
      ((JSObject) jsobj).setMember(key.toString(), value);
    }
  }

  @SuppressWarnings("unused")
  static boolean del(Object jsobj, Object key) {
    if (jsobj instanceof ScriptObjectMirror som) {
      return som.delete(key);
    }
    ((JSObject) jsobj).removeMember(Objects.toString(key));
    return true;
  }

  static int getIndex(Number n) {
    var value = n.doubleValue();
    return JSType.isRepresentableAsInt(value) ? (int) value : -1;
  }

  @SuppressWarnings("unused")
  static Object callToApply(MethodHandle mh, JSObject obj, Object self, Object... args) {
    assert args.length >= 1;
    var receiver = args[0];
    var arguments = new Object[args.length - 1];
    System.arraycopy(args, 1, arguments, 0, arguments.length);
    try {
      return mh.invokeExact(obj, self, new Object[]{receiver, arguments});
    } catch (RuntimeException | Error e) {
      throw e;
    } catch (Throwable e) {
      throw new RuntimeException(e);
    }
  }

  // This is used when a JSObject is called as scope call to do undefined -> Global this translation.
  @SuppressWarnings("unused")
  static Object jsObjectScopeCall(JSObject jsObj, Object self, Object[] args) {
    Object modifiedThis;
    if (self == ScriptRuntime.UNDEFINED && !jsObj.isFunction()) {
      final Global global = Context.getGlobal();
      modifiedThis = ScriptObjectMirror.wrap(global, global);
    } else {
      modifiedThis = self;
    }
    return jsObj.call(modifiedThis, args);
  }

  private static final MethodHandleFunctionality MH = MethodHandleFactory.getFunctionality();

  // method handles of the current class
  private static final MethodHandle IS_JSOBJECT_GUARD = findOwnMH_S("isJSObject", boolean.class, Object.class);
  private static final MethodHandle JSOBJECTLINKER_GET = findOwnMH_S("get", Object.class, MethodHandle.class, Object.class, Object.class);
  private static final MethodHandle JSOBJECTLINKER_PUT = findOwnMH_S("put", Void.TYPE, Object.class, Object.class, Object.class);
  private static final MethodHandle JSOBJECTLINKER_DEL = findOwnMH_S("del", boolean.class, Object.class, Object.class);

  // method handles of JSObject class
  private static final MethodHandle JSOBJECT_GETMEMBER = findJSObjectMH_V("getMember", Object.class, String.class);
  private static final MethodHandle JSOBJECT_SETMEMBER = findJSObjectMH_V("setMember", Void.TYPE, String.class, Object.class);
  private static final MethodHandle JSOBJECT_CALL = findJSObjectMH_V("call", Object.class, Object.class, Object[].class);
  private static final MethodHandle JSOBJECT_SCOPE_CALL = findOwnMH_S("jsObjectScopeCall", Object.class, JSObject.class, Object.class, Object[].class);
  private static final MethodHandle JSOBJECT_CALL_TO_APPLY = findOwnMH_S("callToApply", Object.class, MethodHandle.class, JSObject.class, Object.class, Object[].class);
  private static final MethodHandle JSOBJECT_NEW = findJSObjectMH_V("newObject", Object.class, Object[].class);

  static MethodHandle findJSObjectMH_V(String name, Class<?> rtype, Class<?>... types) {
    return MH.findVirtual(MethodHandles.lookup(), JSObject.class, name, MH.type(rtype, types));
  }

  static MethodHandle findOwnMH_S(String name, Class<?> rtype, Class<?>... types) {
    return MH.findStatic(MethodHandles.lookup(), JSObjectLinker.class, name, MH.type(rtype, types));
  }

}
