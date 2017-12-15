import controlP5.*;

Config config;

Signal signal;

Lighting lighting;

UI ui;
NanoKontrol2 nk2;

ArrayList<LedGroup> randomGroups;
Palette palette;

SignalToLight signalToLight;

void setup() {
  size(1280, 720, P2D);
  background(0);

  config = new Config();

  signal = new Signal(this);

  lighting = new Lighting(this, config);

  ui = new UI(this, config, lighting)
    .fftAvgSize(signal.getFft().avgSize());

  nk2 = new NanoKontrol2(this, "nanokontrol2.json");

  randomGroups = lighting.getGroup().getRandomGroups(32);
  palette = config.paletteInstagram();

  signalToLight = new SignalToLight();
  signalToLight.setup(signal, lighting);
}

void draw() {
  background(8);
  ui.read(signal).draw(g);

  signalToLight.getLit(signal, lighting);
}

void fftMaxValue(float v) {
  ui.fftMaxValue(v);
}

void controllerChange(int channel, int number, int value) {
  nk2.set(channel, number, value);
  signalToLight.controllerChange(channel, number, value);
}