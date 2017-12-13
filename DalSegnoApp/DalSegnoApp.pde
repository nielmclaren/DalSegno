
import controlP5.*;

Config config;

Signal signal;
UI ui;
Lighting lighting;
ArrayList<LedGroup> randomGroups;

FileNamer fileNamer;

void setup() {
  size(1280, 720, P2D);

  config = new Config();

  signal = new Signal(this);

  ui = new UI(this)
    .fftAvgSize(signal.getFft().avgSize());

  lighting = new Lighting(this, config);
  randomGroups = lighting.getGroup().getRandomGroups(4);

  fileNamer = new FileNamer("output/export", "png");
}

void draw() {
  background(0);

  ui.readSparklineValues(signal.getFftArray())
    .draw(g);

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

void keyReleased() {
  switch (key) {
    case 'r':
      saveRender();
      break;
  }
}

void saveRender() {
  saveFrame(fileNamer.next());
}