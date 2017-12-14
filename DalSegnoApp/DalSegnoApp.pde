

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
  randomGroups = lighting.getGroup().getRandomGroups(8);
}

void draw() {
  background(0);

  ui.read(signal).draw(g);

  if (frameCount % 50 == 0) {
    LedGroup group = randomGroups.get(floor(random(randomGroups.size())));
    if (random(1) < 0.5) {
      group.pulse(2000);
    } else {
      group.fade(500);
    }
  }
}

void fftMaxValue(float v) {
  ui.fftMaxValue(v);
}