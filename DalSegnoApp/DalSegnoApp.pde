import controlP5.*;

Config config;

Signal signal;
UI ui;
NanoKontrol2 nk2;
Lighting lighting;
ArrayList<LedGroup> randomGroups;
Palette palette;

SignalToLight signalToLight;

void setup() {
  size(1280, 720, P2D);

  config = new Config();

  signal = new Signal(this);

  ui = new UI(this, config)
    .fftAvgSize(signal.getFft().avgSize());

  nk2 = new NanoKontrol2(this, "nanokontrol2.json");

  lighting = new Lighting(this, config);
  randomGroups = lighting.getGroup().getRandomGroups(32);

  palette = config.paletteInstagram();

  signalToLight = new SignalToLight();
}

void draw() {
  background(0);
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