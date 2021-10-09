package nasgen;

/**
 * Enum to tell where a Function or Property belongs.
 * Note: keep this in sync. with jdk.nashorn.internal.objects.annotations.Where.
 */
public enum Where {
  /** this means that the item belongs in the Constructor of an object */
  CONSTRUCTOR,
  /** this means that the item belongs in the Prototype of an object */
  PROTOTYPE,
  /** this means that the item belongs in the Instance of an object */
  INSTANCE
}
