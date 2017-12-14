import controlP5.*;

Config config;

Signal signal;
UI ui;
NanoKontrol2 nk2;
Lighting lighting;
ArrayList<LedGroup> randomGroups;
Palette palette;

void setup() {
  size(1280, 720, P2D);

  config = new Config();

  signal = new Signal(this);

  ui = new UI(this, config)
    .fftAvgSize(signal.getFft().avgSize());

  nk2 = new NanoKontrol2(this, "nanokontrol2.json");

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
    if (random(1) < nk2.getSliderf(7)) {
      group.pulse(c, floor(nk2.getKnobf(0) * 2000));
    } else {
      group.fade(c, 500);
    }
  }
}

void fftMaxValue(float v) {
  ui.fftMaxValue(v);
}

void controllerChange(int channel, int number, int value) {
  nk2.set(channel, number, value);
}