package es.runtime.linker;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.util.Arrays;
import jdk.dynalink.CallSiteDescriptor;
import jdk.dynalink.NamedOperation;
import jdk.dynalink.Operation;
import jdk.dynalink.StandardOperation;
import jdk.dynalink.linker.GuardedInvocation;
import jdk.dynalink.linker.LinkRequest;
import jdk.dynalink.linker.LinkerServices;
import jdk.dynalink.linker.TypeBasedGuardingDynamicLinker;
import jdk.dynalink.linker.support.Guards;

/**
 * Links {@link BoundCallable} objects. Passes through to linker services for linking a callable (for either
 * StandardOperation.CALL or .NEW, and modifies the returned invocation to deal with the receiver and argument binding.
 */
final class BoundCallableLinker implements TypeBasedGuardingDynamicLinker {

  @Override
  public boolean canLinkType(final Class<?> type) {
    return type == BoundCallable.class;
  }

  @Override
  public GuardedInvocation getGuardedInvocation(final LinkRequest linkRequest, final LinkerServices linkerServices) throws Exception {
    final Object objBoundCallable = linkRequest.getReceiver();
    if (!(objBoundCallable instanceof BoundCallable)) {
      return null;
    }

    final CallSiteDescriptor descriptor = linkRequest.getCallSiteDescriptor();
    final Operation operation = NamedOperation.getBaseOperation(descriptor.getOperation());
    // We need to distinguish NEW from CALL because CALL sites have parameter list of the form
    // "callee, this, args", while NEW sites have "callee, args" -- they lack the "this" parameter.
    final boolean isCall;
    if (operation == StandardOperation.NEW) {
      isCall = false;
    } else if (operation == StandardOperation.CALL) {
      isCall = true;
    } else {
      // Only CALL and NEW are supported.
      return null;
    }
    final BoundCallable boundCallable = (BoundCallable) objBoundCallable;
    final Object callable = boundCallable.getCallable();
    final Object boundThis = boundCallable.getBoundThis();

    // We need to ask the linker services for a delegate invocation on the target callable.
    // Replace arguments (boundCallable[, this], args) => (callable[, boundThis], boundArgs, args) when delegating
    final Object[] args = linkRequest.getArguments();
    final Object[] boundArgs = boundCallable.getBoundArgs();
    final int argsLen = args.length;
    final int boundArgsLen = boundArgs.length;
    final Object[] newArgs = new Object[argsLen + boundArgsLen];
    newArgs[0] = callable;
    final int firstArgIndex;
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
    final MethodType type = descriptor.getMethodType();
    // Use R(T0, ...) => R(callable.class, ...)
    MethodType newMethodType = descriptor.getMethodType().changeParameterType(0, callable.getClass());
    if (isCall) {
      // R(callable.class, T1, ...) => R(callable.class, boundThis.class, ...)
      newMethodType = newMethodType.changeParameterType(1, boundThis == null ? Object.class : boundThis.getClass());
    }
    // R(callable.class[, boundThis.class], T2, ...) => R(callable.class[, boundThis.class], boundArg0.class, ..., boundArgn.class, T2, ...)
    for (int i = boundArgs.length; i-- > 0;) {
      newMethodType = newMethodType.insertParameterTypes(firstArgIndex, boundArgs[i] == null ? Object.class : boundArgs[i].getClass());
    }
    final CallSiteDescriptor newDescriptor = descriptor.changeMethodType(newMethodType);

    // Delegate to target's linker
    final GuardedInvocation inv = linkerServices.getGuardedInvocation(linkRequest.replaceArguments(newDescriptor, newArgs));
    if (inv == null) {
      return null;
    }

    // Bind (callable[, boundThis], boundArgs) to the delegate handle
    final MethodHandle boundHandle = MethodHandles.insertArguments(inv.getInvocation(), 0,
            Arrays.copyOf(newArgs, firstArgIndex + boundArgs.length));
    final Class<?> p0Type = type.parameterType(0);
    final MethodHandle droppingHandle;
    if (isCall) {
      // Ignore incoming boundCallable and this
      droppingHandle = MethodHandles.dropArguments(boundHandle, 0, p0Type, type.parameterType(1));
    } else {
      // Ignore incoming boundCallable
      droppingHandle = MethodHandles.dropArguments(boundHandle, 0, p0Type);
    }
    // Identity guard on boundCallable object
    final MethodHandle newGuard = Guards.getIdentityGuard(boundCallable);
    return inv.replaceMethods(droppingHandle, newGuard.asType(newGuard.type().changeParameterType(0, p0Type)));
  }
}
