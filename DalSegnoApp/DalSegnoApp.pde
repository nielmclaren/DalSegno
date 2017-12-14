

import controlP5.*;

Config config;

Signal signal;
UI ui;
Lighting lighting;
ArrayList<LedGroup> randomGroups;

Palette palette;

void setup() {
  size(1280, 720, P2D);

  config = new Config();

  signal = new Signal(this);

  ui = new UI(this, config)
    .fftAvgSize(signal.getFft().avgSize());

  lighting = new Lighting(this, config);
  randomGroups = lighting.getGroup().getRandomGroups(8);

  palette = config.paletteInstagram();
}

void draw() {
  background(0);

  ui.read(signal).draw(g);

  if (frameCount % 50 == 0) {
    color c = palette.weightedColor();
    LedGroup group = randomGroups.get(floor(random(randomGroups.size())));
    if (random(1) < 0) {
      group.pulse(c, 2000);
    } else {
      group.fade(c, 500);
    }
  }
}

void fftMaxValue(float v) {
  ui.fftMaxValue(v);
}