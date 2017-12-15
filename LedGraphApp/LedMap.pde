import java.util.Iterator;
import java.util.List;
import java.util.Map;

class LedMap {
  private HashMap<Integer, PositionedLed> _indexToPosition;
  
  LedMap() {
  }

  LedMap load(String filename) {
    List<PositionedLed> leds = new ArrayList<PositionedLed>();
    Table table = loadTable(filename, "header");
    for (TableRow row : table.rows()) {
      int index = row.getInt("address");
      float x = row.getFloat("x");
      float y = row.getFloat("y");
      float z = row.getFloat("z");
      if (x != 0 || y != 0 || z != 0) {
        leds.add(new PositionedLed(index, x, y, z));
      }
    }
    loadLeds(leds);
    return this;
  }

  LedMap loadLeds(List<PositionedLed> leds) {
    _indexToPosition = new HashMap<Integer, PositionedLed>();
    Iterator it = leds.iterator();
    while (it.hasNext()) {
      PositionedLed led = (PositionedLed)it.next();
      _indexToPosition.put(led.index(), led);
    }
    return this;
  }

  LedMap save(String filename) {
    Table table = new Table();
    table.addColumn("address");
    table.addColumn("x");
    table.addColumn("y");
    table.addColumn("z");

    List<PositionedLed> leds = getLeds();
    for (PositionedLed led : leds) {
      PVector pos = led.position();
      TableRow row = table.addRow();
      row.setInt("address", led.index());
      row.setFloat("x", pos.x);
      row.setFloat("y", pos.y);
      row.setFloat("z", pos.z);
    }

    saveTable(table, filename);
    return this;
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

  PositionedLed getLedNearest(PVector target) {
    return getLedNearest(target, -1);
  }

  PositionedLed getLedNearest(PVector target, int exceptIndex) {
    PositionedLed nearestLed = null;
    float nearestDist = 0;

    Iterator it = _indexToPosition.values().iterator();
    while (it.hasNext()) {
      PositionedLed led = (PositionedLed)it.next();
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

  List<PositionedLed> getLedsNearest(PVector target, int numResults) {
    return getLedsNearest(target, numResults, -1);
  }

  List<PositionedLed> getLedsNearest(PVector target, int numResults, int exceptIndex) {
    List<DistanceLed> distanceLeds = getDistanceLeds(new ArrayList(_indexToPosition.values()), target, exceptIndex);
    distanceLeds.sort(new DistanceLedComparator());
    return getPositionedLeds(distanceLeds.subList(0, numResults));
  }

  private List<DistanceLed> getDistanceLeds(List<PositionedLed> leds, PVector target, int exceptIndex) {
    List<DistanceLed> result = new ArrayList<DistanceLed>();

    Iterator it = leds.iterator();
    while (it.hasNext()) {
      PositionedLed led = (PositionedLed)it.next();
      if (led.index() != exceptIndex) {
        float dist = led.position().dist(target);
        result.add(new DistanceLed(led, dist));
      }
    }
    return result;
  }

  private List<PositionedLed> getPositionedLeds(List<DistanceLed> distanceLeds) {
    List<PositionedLed> result = new ArrayList<PositionedLed>();
    Iterator it = distanceLeds.iterator();
    while (it.hasNext()) {
      DistanceLed distanceLed = (DistanceLed)it.next();
      result.add(distanceLed.led());
    }
    return result;
  }

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

  LedMap moveTo(float x, float y) {
    float left = getLeftmostLed().position().x;
    float top = getTopmostLed().position().y;

    float dx = x - left;
    float dy = y - top;

    List<PositionedLed> movedLeds = new ArrayList<PositionedLed>();
    Iterator it = _indexToPosition.values().iterator();
    while (it.hasNext()) {
      PositionedLed led = (PositionedLed)it.next();
      PVector pos = led.position();
      movedLeds.add(new PositionedLed(led.index(), pos.x + dx, pos.y + dy, pos.z));
    }

    loadLeds(movedLeds);

    return this;
  }

  LedMap scale(float targetWidth, float targetHeight) {
    float left = getLeftmostLed().position().x;
    float top = getTopmostLed().position().y;
    float right = getRightmostLed().position().x;
    float bottom = getBottommostLed().position().y;

    float currentWidth = right - left;
    float currentHeight = bottom - top;

    float currentAspect = currentWidth / currentHeight;
    float targetAspect = targetWidth / targetHeight;

    float scale;
    if (currentAspect < targetAspect) {
      scale = targetHeight / currentHeight;
    } else {
      scale = targetWidth / currentWidth;
    }

    List<PositionedLed> movedLeds = new ArrayList<PositionedLed>();
    Iterator it = _indexToPosition.values().iterator();
    while (it.hasNext()) {
      PositionedLed led = (PositionedLed)it.next();
      PVector pos = led.position();
      float dx = pos.x - left;
      float dy = pos.y - top;
      movedLeds.add(new PositionedLed(led.index(), left + dx * scale, top + dy * scale, pos.z));
    }

    loadLeds(movedLeds);

    return this;
  }
}