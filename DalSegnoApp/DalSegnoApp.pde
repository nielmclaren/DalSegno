
import controlP5.*;

Config config;

ControlP5 cp5;
float initialFftMaxValue = 100;

Signal signal;
Sparkline fftSparkline;

ArrayList<ValueCollector> bandValueCollectors;

ArrayList<Sparkline> bandSparklines;
ArrayList<Sparkline> band5AverageSparklines;
ArrayList<Sparkline> band10AverageSparklines;

Lighting lighting;
ArrayList<LedGroup> randomGroups;

FileNamer fileNamer;

void setup() {
  size(1280, 720, P2D);

  config = new Config();

  cp5 = new ControlP5(this);
  cp5.addSlider("fftMaxValue")
    .setBroadcast(false)
    .setRange(1, 100)
    .setValue(initialFftMaxValue)
    .setPosition(20, 20)
    .setSize(100, 10)
    .setBroadcast(true);

  signal = new Signal(this);

  fftSparkline = new Sparkline("fft")
    .x(100).y(50).width(300).height(25)
    .maxValue(initialFftMaxValue);

  bandValueCollectors = new ArrayList<ValueCollector>();
  bandSparklines = new ArrayList<Sparkline>();
  band5AverageSparklines = new ArrayList<Sparkline>();
  band10AverageSparklines = new ArrayList<Sparkline>();
  for (int i = 0; i < signal.getFft().avgSize(); i++) {
    bandValueCollectors.add(
      new ValueCollector().maxValues(100));

    bandSparklines.add(
      new Sparkline("band" + i)
        .x(100).y(80 + i * 30).width(300).height(25)
        .numValues(100)
        .maxValue(initialFftMaxValue));

    band5AverageSparklines.add(
      new Sparkline("band5Average" + i)
        .x(410).y(80 + i * 30).width(300).height(25)
        .numValues(100 - 5 + 1)
        .maxValue(initialFftMaxValue));

    band10AverageSparklines.add(
      new Sparkline("band10Average" + i)
        .x(720).y(80 + i * 30).width(300).height(25)
        .numValues(100 - 10 + 1)
        .maxValue(initialFftMaxValue));
  }

  lighting = new Lighting(this, config);
  randomGroups = lighting.getGroup().getRandomGroups(4);

  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void reset() {
}

void draw() {
  background(0);
  fftSparkline.values(signal.getFftArray());
  fftSparkline.draw(g);
  for (int i = 0; i < bandSparklines.size(); i++) {
    ValueCollector bandValueCollector = bandValueCollectors.get(i);
    bandValueCollector.add(signal.getFft().getAvg(i));

    Sparkline bandSparkline = bandSparklines.get(i);
    bandSparkline.values(bandValueCollector.values());
    bandSparkline.draw(g);

    Sparkline band5AverageSparkline = band5AverageSparklines.get(i);
    band5AverageSparkline.values(bandValueCollector.getRunningAverage(5));
    band5AverageSparkline.draw(g);

    Sparkline band10AverageSparkline = band10AverageSparklines.get(i);
    band10AverageSparkline.values(bandValueCollector.getRunningAverage(10));
    band10AverageSparkline.draw(g);
  }

  if (frameCount % 50 == 0) {
    for (LedGroup group : randomGroups) {
      color c = color(random(255), random(255), random(255));
      group.setColor(c);
    }
  }
}

void fftMaxValue(float v) {
  fftSparkline.maxValue(v);
  for (int i = 0; i < signal.getFft().avgSize(); i++) {
    bandSparklines.get(i).maxValue(v);
    band5AverageSparklines.get(i).maxValue(v);
    band10AverageSparklines.get(i).maxValue(v);
  }
}

void keyReleased() {
  switch (key) {
    case 'e':
      reset();
      break;
    case 'r':
      saveRender();
      break;
  }
}

void saveRender() {
  saveFrame(fileNamer.next());
}