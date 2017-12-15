
LedMap leftShoes;
LedMap leftLadder;
LedMap rightLadder;
LedMap rightClump;

List<LedMap> ledMaps;
int selectedIndex;

PVector mousePress;

void setup() {
  size(1024, 768);

  LedMap leftShoes = new LedMap().load("layout_left_shoes.csv");
  LedMap leftLadder = new LedMap().load("layout_left_ladder.csv");
  LedMap rightLadder = new LedMap().load("layout_right_ladder.csv");
  LedMap rightClump = new LedMap().load("layout_right_clump.csv");

  ledMaps = new ArrayList<LedMap>();
  ledMaps.add(leftShoes);
  ledMaps.add(leftLadder);
  ledMaps.add(rightLadder);
  ledMaps.add(rightClump);
  selectedIndex = 0;

  mousePress = null;
}

void draw() {
  background(0);

  for (int i = 0; i < ledMaps.size(); i++) {
    LedMap ledMap = ledMaps.get(i);
    if (i == selectedIndex) {
      fill(64);
      stroke(128);
    } else {
      noFill();
      stroke(64);
    }
    drawLeds(ledMap.getLeds());
  }

  if (mousePress != null) {
    stroke(255);
    noFill();
    rectMode(CORNERS);
    rect(mousePress.x, mousePress.y, mouseX, mouseY);
  }
}

void drawLeds(List<PositionedLed> leds) {
  for (PositionedLed led : leds) {
    drawLed(led);
  }
}

void drawLed(PositionedLed led) {
  PVector p = led.position();
  float radius = 6;
  pushStyle();
  ellipseMode(CENTER);
  ellipse(p.x, p.y, radius, radius);
  popStyle();
}

void saveMap() {
  Map<Integer, PositionedLed> indexToLed = new HashMap<Integer, PositionedLed>();
  for (LedMap ledMap : ledMaps) {
    List<PositionedLed> leds = ledMap.getLeds();
    for (PositionedLed led : leds) {
      if (indexToLed.get(led.index()) != null) {
        println("Collision: " + led.index());
      }
      indexToLed.put(led.index(), led);
    }
  }

  LedMap ledMap = new LedMap();
  ledMap.loadLeds(new ArrayList(indexToLed.values()));
  ledMap.save("output.csv");
}

void mousePressed() {
  mousePress = new PVector(mouseX, mouseY);
}

void mouseReleased() {
  PVector mouseRelease = new PVector(mouseX, mouseY);
  if (mousePress.dist(mouseRelease) > 10) {
    LedMap ledMap = ledMaps.get(selectedIndex);
    PVector delta = PVector.sub(mouseRelease, mousePress);
    ledMap.moveTo(mousePress.x, mousePress.y);
    ledMap.scale(delta.x, delta.y);
  }

  mousePress = null;
}

void keyReleased() {
  switch (key) {
    case 'j':
      selectedIndex--;
      if (selectedIndex < 0) {
        selectedIndex = ledMaps.size() - 1;
      }
      break;
    case 'k':
      selectedIndex++;
      if (selectedIndex >= ledMaps.size()) {
        selectedIndex = 0;
      }
      break;

    case 's':
      saveMap();
      break;
  }
}