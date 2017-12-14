

import controlP5.*;

Config config;

Signal signal;
UI ui;
Lighting lighting;
ArrayList<LedGroup> randomGroups;

void setup() {
  size(1280, 720, P2D);

  config = new Config();

  signal = new Signal(this);

  ui = new UI(this, config)
    .fftAvgSize(signal.getFft().avgSize());

  lighting = new Lighting(this, config);
  randomGroups = lighting.getGroup().getRandomGroups(4);
}

void draw() {
  background(0);

  ui.read(signal).draw(g);

  if (frameCount % 50 == 0) {
    for (LedGroup group : randomGroups) {
      color c = color(random(255), random(255), random(255));
      group.setColor(c);
    }
  }
}

void fftMaxValue(float v) {
  ui.fftMaxValue(v);
}