package es.runtime.linker;

import java.util.Arrays;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;

import jdk.dynalink.NamedOperation;
import jdk.dynalink.StandardOperation;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;
import jdk.dynalink.linker.LinkerServices;
import jdk.dynalink.linker.TypeBasedGuardingDynamicLinker;
import jdk.dynalink.linker.support.Guards;

/**
 * Links {@link BoundCallable} objects.
 * Passes through to linker services for linking a callable (for either StandardOperation.CALL or .NEW, and modifies the returned invocation to deal with the receiver and argument binding.
 */
final class BoundCallableLinker implements TypeBasedGuardingDynamicLinker {

  @Override
  public boolean canLinkType(Class<?> type) {
    return type == BoundCallable.class;
  }

  @Override
  public GuardedInvocation getGuardedInvocation(LinkRequest linkRequest, LinkerServices linkerServices) throws Exception {
    var objBoundCallable = linkRequest.getReceiver();
    if (!(objBoundCallable instanceof BoundCallable)) {
      return null;
    }
    var descriptor = linkRequest.getCallSiteDescriptor();
    var operation = NamedOperation.getBaseOperation(descriptor.getOperation());
    // We need to distinguish NEW from CALL because CALL sites have parameter list of the form "callee, this, args", while NEW sites have "callee, args" -- they lack the "this" parameter.
    boolean isCall;
    if (operation == StandardOperation.NEW) {
      isCall = false;
    } else if (operation == StandardOperation.CALL) {
      isCall = true;
    } else {
      // Only CALL and NEW are supported.
      return null;
    }
    var boundCallable = (BoundCallable) objBoundCallable;
    var callable = boundCallable.getCallable();
    var boundThis = boundCallable.getBoundThis();

    // We need to ask the linker services for a delegate invocation on the target callable.
    // Replace arguments (boundCallable[, this], args) => (callable[, boundThis], boundArgs, args) when delegating
    var args = linkRequest.getArguments();
    var boundArgs = boundCallable.getBoundArgs();
    var argsLen = args.length;
    var boundArgsLen = boundArgs.length;
    var newArgs = new Object[argsLen + boundArgsLen];
    newArgs[0] = callable;
    int firstArgIndex;
    if (isCall) {
      newArgs[1] = boundThis;
      firstArgIndex = 2;
    } else {
      firstArgIndex = 1;
    }
    System.arraycopy(boundArgs, 0, newArgs, firstArgIndex, boundArgsLen);
    System.arraycopy(args, firstArgIndex, newArgs, firstArgIndex + boundArgsLen, argsLen - firstArgIndex);

    // Use R(T0, T1, T2, ...) => R(callable.class, boundThis.class, boundArg0.class, ..., boundArgn.class, T2, ...)
    // call site type when delegating to underlying linker (for NEW, there's no this).
    var type = descriptor.getMethodType();
    // Use R(T0, ...) => R(callable.class, ...)
    var newMethodType = descriptor.getMethodType().changeParameterType(0, callable.getClass());
    if (isCall) {
      // R(callable.class, T1, ...) => R(callable.class, boundThis.class, ...)
      newMethodType = newMethodType.changeParameterType(1, boundThis == null ? Object.class : boundThis.getClass());
    }
    // R(callable.class[, boundThis.class], T2, ...) => R(callable.class[, boundThis.class], boundArg0.class, ..., boundArgn.class, T2, ...)
    for (var i = boundArgs.length; i-- > 0;) {
      newMethodType = newMethodType.insertParameterTypes(firstArgIndex, boundArgs[i] == null ? Object.class : boundArgs[i].getClass());
    }
    var newDescriptor = descriptor.changeMethodType(newMethodType);

    // Delegate to target's linker
    var inv = linkerServices.getGuardedInvocation(linkRequest.replaceArguments(newDescriptor, newArgs));
    if (inv == null) {
      return null;
    }

    // Bind (callable[, boundThis], boundArgs) to the delegate handle
    var boundHandle = MethodHandles.insertArguments(inv.getInvocation(), 0, Arrays.copyOf(newArgs, firstArgIndex + boundArgs.length));
    var p0Type = type.parameterType(0);
    MethodHandle droppingHandle;
    if (isCall) {
      // Ignore incoming boundCallable and this
      droppingHandle = MethodHandles.dropArguments(boundHandle, 0, p0Type, type.parameterType(1));
    } else {
      // Ignore incoming boundCallable
      droppingHandle = MethodHandles.dropArguments(boundHandle, 0, p0Type);
    }
    // Identity guard on boundCallable object
    var newGuard = Guards.getIdentityGuard(boundCallable);
    return inv.replaceMethods(droppingHandle, newGuard.asType(newGuard.type().changeParameterType(0, p0Type)));
  }

}
