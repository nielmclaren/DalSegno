import java.util.Iterator;
import java.util.List;
import java.util.Map;

class LedMap {
  private HashMap<Integer, PositionedLed> _indexToPosition;
  
  LedMap(String filename) {
    loadLedMap(filename);
  }

  private void loadLedMap(String filename) {
    _indexToPosition = new HashMap<Integer, PositionedLed>();
    Table table = loadTable(filename, "header");
    for (TableRow row : table.rows()) {
      int index = row.getInt("address");
      float x = row.getFloat("x");
      float y = row.getFloat("y");
      float z = row.getFloat("z");
      if (x != 0 || y != 0 || z != 0) {
        _indexToPosition.put(index, new PositionedLed(index, x, y, z));
      }
    }
  }

  PVector getPosition(int index) {
    return _indexToPosition.get(index).position();
  }

  int getNumLeds() {
    return _indexToPosition.keySet().size();
  }

  List<PositionedLed> getLeds() {
    return new ArrayList<PositionedLed>(_indexToPosition.values());
  }

  List<PositionedLed> getLedsNear(float x, float y, float z, float radius) {
    return getLedsNear(new PVector(x, y, z), radius);
  }

  List<PositionedLed> getLedsNear(PVector target, float radius) {
    List<PositionedLed> result = new ArrayList<PositionedLed>();
    Iterator it = _indexToPosition.entrySet().iterator();
    while (it.hasNext()) {
      Map.Entry pair = (Map.Entry)it.next();
      PositionedLed led = (PositionedLed)pair.getValue();
      if (PVector.sub(led.position(), target).mag() < radius) {
        result.add(led);
      }
    }
    return result;
  }

  PositionedLed getLedNearest(PVector target, int exceptIndex) {
    PositionedLed nearestLed = null;
    float nearestDist = 0;

    Iterator it = _indexToPosition.entrySet().iterator();
    while (it.hasNext()) {
      Map.Entry pair = (Map.Entry)it.next();
      PositionedLed led = (PositionedLed)pair.getValue();
      if (nearestLed == null && led.index() != exceptIndex) {
        float dist = PVector.sub(led.position(), nearestLed.position()).mag();
        if (dist < nearestDist) {
          nearestLed = led;
          nearestDist = dist;
        }
      }
    }
    return nearestLed;
  }

/*
  List<PositionedLed> getLedsNearest(PVector target, int numResults, int exceptIndex) {
    List<DistanceLed> distanceLeds = getDistanceLeds(target, exceptIndex);
    distanceLeds.sort(new DistanceLedComparator());
    return distanceLeds.subList(0, numResults);
  }

  private List<DistanceLed> getDistanceLeds(PVector target, int exceptIndex) {
    List<DistanceLed> result = new ArrayList<DistanceLed>();
    Iterator it = _indexToPosition.entrySet().iterator();
    while (it.hasNext()) {
      Map.Entry pair = (Map.Entry)it.next();
      PositionedLed led = (PositionedLed)pair.getValue();
      if (led.index() != exceptIndex) {
        result.add(new DistanceLed(led, PVector.sub(led.position(), target)));
      }
    }
    return result;
  }
*/

  PositionedLed getRightmostLed() {
    PositionedLed rightmostLed = null;
    float rightmostX = 0;
    Iterator it = _indexToPosition.values().iterator();
    while (it.hasNext()) {
      PositionedLed led = (PositionedLed)it.next();
      if (rightmostLed == null || rightmostX < led.position().x) {
        rightmostLed = led;
        rightmostX = led.position().x;
      }
    }
    return rightmostLed;
  }

  PositionedLed getLeftmostLed() {
    PositionedLed leftmostLed = null;
    float leftmostX = 0;
    Iterator it = _indexToPosition.values().iterator();
    while (it.hasNext()) {
      PositionedLed led = (PositionedLed)it.next();
      if (leftmostLed == null || leftmostX > led.position().x) {
        leftmostLed = led;
        leftmostX = led.position().x;
      }
    }
    return leftmostLed;
  }

  PositionedLed getTopmostLed() {
    PositionedLed topmostLed = null;
    float topmostY = 0;
    Iterator it = _indexToPosition.values().iterator();
    while (it.hasNext()) {
      PositionedLed led = (PositionedLed)it.next();
      if (topmostLed == null || topmostY > led.position().y) {
        topmostLed = led;
        topmostY = led.position().y;
      }
    }
    return topmostLed;
  }

  PositionedLed getBottommostLed() {
    PositionedLed bottommostLed = null;
    float bottommostY = 0;
    Iterator it = _indexToPosition.values().iterator();
    while (it.hasNext()) {
      PositionedLed led = (PositionedLed)it.next();
      if (bottommostLed == null || bottommostY < led.position().y) {
        bottommostLed = led;
        bottommostY = led.position().y;
      }
    }
    return bottommostLed;
  }
}