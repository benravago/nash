package es.runtime;

import java.lang.invoke.SwitchPoint;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.WeakHashMap;
import java.util.concurrent.atomic.LongAdder;

/**
 * Helper class for tracking and invalidation of switchpoints for inherited properties.
 */
public class PropertySwitchPoints {

  private final Map<Object, WeakSwitchPointSet> switchPointMap = new HashMap<>();

  private final static SwitchPoint[] EMPTY_SWITCHPOINT_ARRAY = new SwitchPoint[0];

  /**
   * Copy constructor
   * @param switchPoints Proto switchpoints to copy
   */
  PropertySwitchPoints(PropertySwitchPoints switchPoints) {
    if (switchPoints != null) {
      // We need to copy the nested weak sets in order to avoid concurrent modification issues, see JDK-8146274
      synchronized (switchPoints) {
        for (var entry : switchPoints.switchPointMap.entrySet()) {
          this.switchPointMap.put(entry.getKey(), new WeakSwitchPointSet(entry.getValue()));
        }
      }
    }
  }

  /**
   * Return the number of switchpoints added to this ProtoSwitchPoints instance.
   * @return the switchpoint count;
   */
  int getSwitchPointCount() {
    return switchPointMap.size();
  }

  /**
   * Add {@code switchPoint} to the switchpoints for for property {@code key}, creating and returning a new {@code ProtoSwitchPoints} instance if the switchpoint was not already contained
   * @param oldSwitchPoints the original PropertySwitchPoints instance. May be null
   * @param key the property key
   * @param switchPoint the switchpoint to be added
   * @return the new PropertySwitchPoints instance, or this instance if switchpoint was already contained
   */
  static PropertySwitchPoints addSwitchPoint(PropertySwitchPoints oldSwitchPoints, String key, SwitchPoint switchPoint) {
    if (oldSwitchPoints == null || !oldSwitchPoints.contains(key, switchPoint)) {
      var newSwitchPoints = new PropertySwitchPoints(oldSwitchPoints);
      newSwitchPoints.add(key, switchPoint);
      return newSwitchPoints;
    }
    return oldSwitchPoints;
  }

  /**
   * Checks whether {@code switchPoint} is contained in {@code key}'s set.
   * @param key the property key
   * @param switchPoint the switchPoint
   * @return true if switchpoint is already contained for key
   */
  synchronized boolean contains(String key, SwitchPoint switchPoint) {
    var set = this.switchPointMap.get(key);
    return set != null && set.contains(switchPoint);
  }

  synchronized void add(String key, SwitchPoint switchPoint) {
    var set = this.switchPointMap.get(key);
    if (set == null) {
      set = new WeakSwitchPointSet();
      this.switchPointMap.put(key, set);
    }
    set.add(switchPoint);
  }

  Set<SwitchPoint> getSwitchPoints(Object key) {
    var switchPointSet = switchPointMap.get(key);
    return (switchPointSet != null) ? switchPointSet.elements() : Collections.emptySet();
  }

  /**
   * Invalidate all switchpoints for the given property.
   * This is called when that property is created, deleted, or modified in a script object.
   * @param prop The property to invalidate.
   */
  synchronized void invalidateProperty(Property prop) {
    var set = switchPointMap.get(prop.getKey());
    if (set != null) {
      var switchPoints = set.elements().toArray(EMPTY_SWITCHPOINT_ARRAY);
      SwitchPoint.invalidateAll(switchPoints);
      this.switchPointMap.remove(prop.getKey());
    }
  }

  /**
   * Invalidate all switchpoints except those defined in {@code map}.
   * This is called when the prototype of a script object is changed.
   * @param map map of properties to exclude from invalidation
   */
  synchronized void invalidateInheritedProperties(PropertyMap map) {
    for (var entry : switchPointMap.entrySet()) {
      if (map.findProperty(entry.getKey()) != null) {
        continue;
      }
      var switchPoints = entry.getValue().elements().toArray(EMPTY_SWITCHPOINT_ARRAY);
      SwitchPoint.invalidateAll(switchPoints);
    }
    switchPointMap.clear();
  }

  static class WeakSwitchPointSet { // TODO: use extends WeakHashMap<> instead

    private final WeakHashMap<SwitchPoint, Void> map;

    WeakSwitchPointSet() {
      map = new WeakHashMap<>();
    }

    WeakSwitchPointSet(WeakSwitchPointSet set) {
      map = new WeakHashMap<>(set.map);
    }

    void add(SwitchPoint switchPoint) {
      map.put(switchPoint, null);
    }

    boolean contains(SwitchPoint switchPoint) { // TODO: rename to has()
      return map.containsKey(switchPoint);
    }

    Set<SwitchPoint> elements() {
      return map.keySet();
    }

    int size() {
      return map.size();
    }

  }

}
