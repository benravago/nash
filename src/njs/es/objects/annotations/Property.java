package es.objects.annotations;

import static es.objects.annotations.Attribute.DEFAULT_ATTRIBUTES;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Annotation to specify a JavaScript "data" property.
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
public @interface Property {

  /** @return Name of the script property. If empty, the name is inferred. */
  public String name() default "";

  /** @return Attribute flags for this function. */
  public int attributes() default DEFAULT_ATTRIBUTES;

  /** @return class; initialize this property with the object of given class. */
  public String clazz() default "";

  /** @return location of property */
  public Where where() default Where.INSTANCE;

}
