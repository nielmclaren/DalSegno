
LedMap leftShoes;
LedMap leftLadder;
LedMap rightLadder;
LedMap rightClump;

PVector mousePress;

void setup() {
  size(1024, 768);

  leftShoes = new LedMap("layout_left_shoes.csv");
  leftLadder = new LedMap("layout_left_ladder.csv");
  rightLadder = new LedMap("layout_right_ladder.csv");
  rightClump = new LedMap("layout_right_clump.csv");

  mousePress = null;
}

void draw() {
  background(0);

  stroke(128);
  noFill();

  drawLeds(leftShoes.getLeds());

  stroke(255);
  fill(128);
  PositionedLed led = leftShoes.getBottommostLed();
  drawLed(led);

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

void mousePressed() {
  mousePress = new PVector(mouseX, mouseY);
}

void mouseReleased() {
  PVector mouseRelease = new PVector(mouseX, mouseY);
  if (mousePress.dist(mouseRelease) > 10) {
    PVector delta = PVector.sub(mouseRelease, mousePress);
    leftShoes.moveTo(mousePress.x, mousePress.y);
    leftShoes.scale(delta.x, delta.y);
  }

  mousePress = null;
}