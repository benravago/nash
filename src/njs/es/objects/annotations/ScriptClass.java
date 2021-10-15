package es.objects.annotations;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Annotation to specify that the annotated Java class is a JavaScript "class".
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface ScriptClass {

  /** @return the name of the script class. By default, the name is derived from the Java class name. */
  public String value() default "";

}
