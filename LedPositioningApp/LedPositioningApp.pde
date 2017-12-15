
LedMap leftShoes;
LedMap leftLadder;
LedMap rightLadder;
LedMap rightClump;

void setup() {
  size(1024, 768);

  leftShoes = new LedMap("layout_left_shoes.csv");
  leftLadder = new LedMap("layout_left_ladder.csv");
  rightLadder = new LedMap("layout_right_ladder.csv");
  rightClump = new LedMap("layout_right_clump.csv");
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

void mouseReleased() {
  leftShoes.moveTo(mouseX, mouseY);
}