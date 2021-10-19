package es.runtime.linker;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.LinkedList;

import static es.runtime.ECMAErrors.typeError;

/**
 * A tuple of a class loader and a single class representative of the classes that can be loaded through it.
 *
 * Its equals/hashCode is defined in terms of the identity of the class loader.
 * The rationale for this class is that it couples a class loader with a random representative class coming from that loader - this representative class is then used to determine if one loader can see the other loader's classes.
 */
final class ClassAndLoader {

  private final Class<?> representativeClass;

  // Don't access this directly; most of the time, use getRetrievedLoader(), or if you know what you're doing, getLoader().
  private ClassLoader loader;

  // We have mild affinity against eagerly retrieving the loader, as we need to do it in a privileged block.
  // For the most basic case of looking up an already-generated adapter info for a single type, we avoid it.
  private boolean loaderRetrieved;

  ClassAndLoader(Class<?> representativeClass, boolean retrieveLoader) {
    this.representativeClass = representativeClass;
    if (retrieveLoader) {
      retrieveLoader();
    }
  }

  Class<?> getRepresentativeClass() {
    return representativeClass;
  }

  boolean canSee(ClassAndLoader other) {
    try {
      var otherClass = other.getRepresentativeClass();
      return Class.forName(otherClass.getName(), false, getLoader()) == otherClass;
    } catch (ClassNotFoundException e) {
      return false;
    }
  }

  ClassLoader getLoader() {
    if (!loaderRetrieved) {
      retrieveLoader();
    }
    return getRetrievedLoader();
  }

  ClassLoader getRetrievedLoader() {
    assert loaderRetrieved;
    return loader;
  }

  void retrieveLoader() {
    loader = representativeClass.getClassLoader();
    loaderRetrieved = true;
  }

  @Override
  public boolean equals(Object obj) {
    return obj instanceof ClassAndLoader cal && cal.getRetrievedLoader() == getRetrievedLoader();
  }

  @Override
  public int hashCode() {
    return System.identityHashCode(getRetrievedLoader());
  }

  /**
   * Given a list of types that define the superclass/interfaces for an adapter class, returns a single type from the list that will be used to attach the adapter to its ClassValue.
   * The first type in the array that is defined in a class loader that can also see all other types is returned. If there is no such loader, an exception is thrown.
   * @param types the input types
   * @return the first type from the array that is defined in a class loader that can also see all other types.
   */
  static ClassAndLoader getDefiningClassAndLoader(Class<?>[] types) {
    // Short circuit the cheap case
    if (types.length == 1) {
      return new ClassAndLoader(types[0], false);
    }
    return getDefiningClassAndLoaderPrivileged(types);
  }

  static ClassAndLoader getDefiningClassAndLoaderPrivileged(Class<?>[] types) {
    var maximumVisibilityLoaders = getMaximumVisibilityLoaders(types);
    var it = maximumVisibilityLoaders.iterator();
    if (maximumVisibilityLoaders.size() == 1) {
      // Fortunate case - single maximally specific class loader; return its representative class.
      return it.next();
    }
    // Ambiguity; throw an error.
    assert maximumVisibilityLoaders.size() > 1; // basically, can't be zero
    var b = new StringBuilder();
    b.append(it.next().getRepresentativeClass().getCanonicalName());
    while (it.hasNext()) {
      b.append(", ").append(it.next().getRepresentativeClass().getCanonicalName());
    }
    throw typeError("extend.ambiguous.defining.class", b.toString());
  }

  /**
   * Given an array of types, return a subset of their class loaders that are maximal according to the "can see other loaders' classes" relation, which is presumed to be a partial ordering.
   * @param types types
   * @return a collection of maximum visibility class loaders. It is guaranteed to have at least one element.
   */
  static Collection<ClassAndLoader> getMaximumVisibilityLoaders(Class<?>[] types) {
    var  maximumVisibilityLoaders = new LinkedList<ClassAndLoader>();
    outer: for (var maxCandidate : getClassLoadersForTypes(types)) {
      var it = maximumVisibilityLoaders.iterator();
      while (it.hasNext()) {
        var existingMax = it.next();
        var candidateSeesExisting = maxCandidate.canSee(existingMax);
        var exitingSeesCandidate = existingMax.canSee(maxCandidate);
        if (candidateSeesExisting) {
          if (!exitingSeesCandidate) {
            // The candidate sees the the existing maximum, so drop the existing one as it's no longer maximal.
            it.remove();
          }
          // NOTE: there's also the anomalous case where both loaders see each other.
          // Not sure what to do about that one, as two distinct class loaders both seeing each other's classes is weird and violates the assumption that the relation "sees others' classes" is a partial ordering.
          // We'll just not do anything, and treat them as incomparable; hopefully some later class loader that comes along can eliminate both of them, if it can not, we'll end up with ambiguity anyway and throw an error at the end.
        } else if (exitingSeesCandidate) {
          // Existing sees the candidate, so drop the candidate.
          continue outer;
        }
      }
      // If we get here, no existing maximum visibility loader could see the candidate, so the candidate is a new maximum.
      maximumVisibilityLoaders.add(maxCandidate);
    }
    return maximumVisibilityLoaders;
  }

  static Collection<ClassAndLoader> getClassLoadersForTypes(Class<?>[] types) {
    var classesAndLoaders = new LinkedHashMap<ClassAndLoader, ClassAndLoader>();
    for (var c : types) {
      var cl = new ClassAndLoader(c, true);
      if (!classesAndLoaders.containsKey(cl)) {
        classesAndLoaders.put(cl, cl);
      }
    }
    return classesAndLoaders.keySet();
  }

}
