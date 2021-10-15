package es.objects.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Specifies a specific method to be the JavaScript "constructor" function.
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface Constructor {

  /** @return the name of the constructor function. If empty, the name is inferred. */
  public String name() default "";

  /**
   * @return the arity of the function.
   * By default computed from the method signature.
   * Note that -1 means varargs. So, -2 is used as invalid arity.
   */
  public int arity() default -2;

}
