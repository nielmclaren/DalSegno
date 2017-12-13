
public class UI {
  private float _initialFftMaxValue = 100;
  private ControlP5 _cp5;

  private Sparkline _fftSparkline;
  private int _fftAvgSize;
  private ArrayList<ValueCollector> _bandValueCollectors;
  private ArrayList<Sparkline> _bandSparklines;
  private ArrayList<Sparkline> _band5AverageSparklines;
  private ArrayList<Sparkline> _band10AverageSparklines;

  UI(PApplet app) {
    _cp5 = new ControlP5(app);
    _fftAvgSize = 0;

    setup();
    setupBandValueCollectors();
    setupSparklines();
  }

  private void setup() {
    _cp5.addSlider("fftMaxValue")
      .setBroadcast(false)
      .setRange(1, 100)
      .setValue(_initialFftMaxValue)
      .setPosition(20, 20)
      .setSize(100, 10)
      .setBroadcast(true);
  }

  private void setupBandValueCollectors() {
    _bandValueCollectors = new ArrayList<ValueCollector>();
    for (int i = 0; i < _fftAvgSize; i++) {
      _bandValueCollectors.add(new ValueCollector().maxValues(100));
    }
  }

  private void setupSparklines() {
    _fftSparkline = new Sparkline("fft")
      .x(100).y(50).width(300).height(25)
      .maxValue(_initialFftMaxValue);

    _bandSparklines = new ArrayList<Sparkline>();
    _band5AverageSparklines = new ArrayList<Sparkline>();
    _band10AverageSparklines = new ArrayList<Sparkline>();
    for (int i = 0; i < _fftAvgSize; i++) {
      _bandSparklines.add(
        new Sparkline("band" + i)
          .x(100).y(80 + i * 30).width(300).height(25)
          .numValues(100)
          .maxValue(_initialFftMaxValue));

      _band5AverageSparklines.add(
        new Sparkline("band5Average" + i)
          .x(410).y(80 + i * 30).width(300).height(25)
          .numValues(100 - 5 + 1)
          .maxValue(_initialFftMaxValue));

      _band10AverageSparklines.add(
        new Sparkline("band10Average" + i)
          .x(720).y(80 + i * 30).width(300).height(25)
          .numValues(100 - 10 + 1)
          .maxValue(_initialFftMaxValue));
    }
  }

  UI readSparklineValues(ArrayList<Float> fftValues) {
    _fftSparkline.values(fftValues);

    for (int i = 0; i < fftValues.size(); i++) {
      ValueCollector bandValueCollector = _bandValueCollectors.get(i);
      bandValueCollector.add(fftValues.get(i));

      Sparkline bandSparkline = _bandSparklines.get(i);
      bandSparkline.values(bandValueCollector.values());

      Sparkline band5AverageSparkline = _band5AverageSparklines.get(i);
      band5AverageSparkline.values(bandValueCollector.getRunningAverage(5));

      Sparkline band10AverageSparkline = _band10AverageSparklines.get(i);
      band10AverageSparkline.values(bandValueCollector.getRunningAverage(10));
    }
    return this;
  }

  UI draw(PGraphics g) {
    _fftSparkline.draw(g);
    for (int i = 0; i < _bandSparklines.size(); i++) {
      Sparkline bandSparkline = _bandSparklines.get(i);
      bandSparkline.draw(g);

      Sparkline band5AverageSparkline = _band5AverageSparklines.get(i);
      band5AverageSparkline.draw(g);

      Sparkline band10AverageSparkline = _band10AverageSparklines.get(i);
      band10AverageSparkline.draw(g);
    }
    return this;
  }

  UI fftAvgSize(int v) {
    _fftAvgSize = v;
    setupBandValueCollectors();
    setupSparklines();
    return this;
  }

  UI fftMaxValue(float v) {
    _fftSparkline.maxValue(v);
    for (int i = 0; i < _bandSparklines.size(); i++) {
      _bandSparklines.get(i).maxValue(v);
      _band5AverageSparklines.get(i).maxValue(v);
      _band10AverageSparklines.get(i).maxValue(v);
    }
    return this;
  }
}