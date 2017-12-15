
public class UI {
  private final int SPARKLINE_WIDTH = 200;
  private final int SPARKLINE_HEIGHT = 30;
  private final int NOTE_CHART_WIDTH = 300;
  private final int NOTE_CHART_HEIGHT = 270;
  private final int SPACING = 6;

  private ControlP5 _cp5;
  private Config _config;
  private boolean _isFirstSetup;

  private Sparkline _fftSparkline;
  private int _fftAvgSize;
  private ArrayList<ValueCollector> _bandValueCollectors;
  private ArrayList<Sparkline> _bandSparklines;
  private ArrayList<Sparkline> _bandAverageSparklines;

  private Sparkline _noteSparkline;
  private Sparkline _rhythmNoteSparkline;
  private ArrayList<ArrayList<Float>> _noteHistory;
  private ArrayList<ArrayList<Float>> _rhythmNoteHistory;
  private NoteChart _noteChart;
  private NoteChart _rhythmNoteChart;

  private ValueCollector _notesThisBarValueCollector;
  private ValueCollector _rhythmNotesThisBarValueCollector;
  private ValueCollector _anyNotesThisBarValueCollector;

  private Sparkline _notesThisBarSparkline;
  private Sparkline _rhythmNotesThisBarSparkline;
  private Sparkline _anyNotesThisBarSparkline;

  private Lighting _lighting;

  private int _controllerChangeChannel;
  private int _controllerChangeNumber;
  private int _controllerChangeValue;

  UI(PApplet app, Config config, Lighting lighting) {
    _cp5 = new ControlP5(app);
    _config = config;
    _fftAvgSize = 0;
    _isFirstSetup = true;

    setupBandValueCollectors();
    setupFftSparklines();
    setupNoteValueCollectors();
    setupNoteHistory();
    setupNoteSparklines();

    _lighting = lighting;

    _isFirstSetup = false;

    _controllerChangeChannel = -1;
    _controllerChangeNumber = -1;
    _controllerChangeValue = -1;
  }

  private void setupBandValueCollectors() {
    _bandValueCollectors = new ArrayList<ValueCollector>();
    for (int i = 0; i < _fftAvgSize; i++) {
      _bandValueCollectors.add(new ValueCollector().maxValues(_config.maxFftHistorySize()));
    }
  }

  private void setupFftSparklines() {
    _fftSparkline = new Sparkline("fft")
      .x(10).y(50).width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
      .numValues(_config.maxFftHistorySize())
      .maxValue(_config.fftMaxValue());

    _bandSparklines = new ArrayList<Sparkline>();
    _bandAverageSparklines = new ArrayList<Sparkline>();
    for (int i = 0; i < _fftAvgSize; i++) {
      _bandSparklines.add(
        new Sparkline("band" + i)
          .x(10).y(50 + (i + 1) * (SPARKLINE_HEIGHT + SPACING))
          .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
          .numValues(_config.maxFftHistorySize())
          .maxValue(_config.fftMaxValue()));

      _bandAverageSparklines.add(
        new Sparkline("bandAverage" + i)
          .x(10 + SPARKLINE_WIDTH + SPACING).y(50 + (i + 1) * (SPARKLINE_HEIGHT + SPACING))
          .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
          .numValues(_config.maxFftHistorySize() - 5 + 1)
          .maxValue(_config.fftMaxValue()));
    }

    if (_isFirstSetup) {
      _cp5.addSlider("fftMaxValue");
    }
    ((Slider)_cp5.getController("fftMaxValue"))
      .setBroadcast(false)
      .setRange(1, 255)
      .setValue(_config.fftMaxValue())
      .setPosition(10, 50 + (_fftAvgSize + 1) * (SPARKLINE_HEIGHT + SPACING))
      .setSize(100, 15)
      .setBroadcast(true);
  }

  private void setupNoteValueCollectors() {
    _notesThisBarValueCollector = new ValueCollector().maxValues(_config.maxNoteHistorySize());
    _rhythmNotesThisBarValueCollector = new ValueCollector().maxValues(_config.maxNoteHistorySize());
    _anyNotesThisBarValueCollector = new ValueCollector().maxValues(_config.maxNoteHistorySize());
  }

  private void setupNoteHistory() {
    int maxNoteHistorySize = _config.maxNoteHistorySize();

    ArrayList<Float> noNotes = new ArrayList<Float>();
    for (int i = 0; i < 127; i++) {
      noNotes.add(0.);
    }

    _noteHistory = new ArrayList<ArrayList<Float>>();
    for (int i = 0; i < maxNoteHistorySize; i++) {
      _noteHistory.add(new ArrayList<Float>(noNotes));
    }

    _rhythmNoteHistory = new ArrayList<ArrayList<Float>>();
    for (int i = 0; i < maxNoteHistorySize; i++) {
      _rhythmNoteHistory.add(new ArrayList<Float>(noNotes));
    }
  }

  private void setupNoteSparklines() {
    _noteSparkline = new Sparkline("note")
      .x(10 + 2 * (SPARKLINE_WIDTH + SPACING)).y(50)
      .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
      .maxValue(127);

    _noteChart = new NoteChart("note")
      .x(10 + 2 * (SPARKLINE_WIDTH + SPACING))
      .y(50 + SPARKLINE_HEIGHT + SPACING)
      .width(NOTE_CHART_WIDTH).height(NOTE_CHART_HEIGHT);

    _rhythmNoteSparkline = new Sparkline("rhythmNote")
      .x(10 + 2 * (SPARKLINE_WIDTH + SPACING))
      .y(50 + SPARKLINE_HEIGHT + SPACING + NOTE_CHART_HEIGHT + 2 * SPACING)
      .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
      .maxValue(127);

    _rhythmNoteChart = new NoteChart("rhythmNote")
      .x(10 + 2 * (SPARKLINE_WIDTH + SPACING))
      .y(50 + SPARKLINE_HEIGHT + SPACING + NOTE_CHART_HEIGHT + 2 * SPACING + SPARKLINE_HEIGHT + SPACING)
      .width(NOTE_CHART_WIDTH).height(NOTE_CHART_HEIGHT);

    _notesThisBarSparkline = new Sparkline("notesThisBar")
      .x(10 + 2 * (SPARKLINE_WIDTH + SPACING) + NOTE_CHART_WIDTH + SPACING)
      .y(50 + 1 * (SPARKLINE_HEIGHT + SPACING))
      .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
      .numValues(_config.maxNoteHistorySize())
      .maxValue(32);
    _rhythmNotesThisBarSparkline = new Sparkline("rhythmNotesThisBar")
      .x(10 + 2 * (SPARKLINE_WIDTH + SPACING) + NOTE_CHART_WIDTH + SPACING)
      .y(50 + 2 * (SPARKLINE_HEIGHT + SPACING))
      .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
      .numValues(_config.maxNoteHistorySize())
      .maxValue(32);
    _anyNotesThisBarSparkline = new Sparkline("anyNotesThisBar")
      .x(10 + 2 * (SPARKLINE_WIDTH + SPACING) + NOTE_CHART_WIDTH + SPACING)
      .y(50 + 3 * (SPARKLINE_HEIGHT + SPACING))
      .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
      .numValues(_config.maxNoteHistorySize())
      .maxValue(32);
  }

  UI read(Signal signal) {
    readFft(signal.getFftArray());
    readNotes(signal.readNotes());
    readRhythmNotes(signal.readRhythmNotes());
    readXThisX(signal);
    return this;
  }

  private void readFft(ArrayList<Float> fftValues) {
    _fftSparkline.values(fftValues);

    for (int i = 0; i < fftValues.size(); i++) {
      ValueCollector bandValueCollector = _bandValueCollectors.get(i);
      bandValueCollector.add(fftValues.get(i));

      Sparkline bandSparkline = _bandSparklines.get(i);
      bandSparkline.values(bandValueCollector.values());

      Sparkline bandAverageSparkline = _bandAverageSparklines.get(i);
      bandAverageSparkline.values(bandValueCollector.getRunningAverage(5));
    }
  }

  private void readNotes(ArrayList<Note> notes) {
    ArrayList<Float> noteData = getNoteData(notes);

    _noteHistory.add(noteData);
    while (_noteHistory.size() > _config.maxNoteHistorySize()) {
      _noteHistory.remove(0);
    }

    _noteSparkline.values(noteData);
    _noteChart.values(_noteHistory);
  }

  private void readRhythmNotes(ArrayList<Note> notes) {
    ArrayList<Float> noteData = getNoteData(notes);

    _rhythmNoteHistory.add(noteData);
    while (_rhythmNoteHistory.size() > _config.maxNoteHistorySize()) {
      _rhythmNoteHistory.remove(0);
    }

    _rhythmNoteSparkline.values(noteData);
    _rhythmNoteChart.values(_rhythmNoteHistory);
  }

  private ArrayList<Float> getNoteData(ArrayList<Note> notes) {
    ArrayList<Float> result = new ArrayList<Float>();
    for (int i = 0; i < notes.size(); i++) {
      Note note = notes.get(i);
      while (result.size() < note.note()) {
        result.add(-1.);
      }
      result.add((float)note.velocity());
    }
    while (result.size() < 127) {
      result.add(-1.);
    }
    return result;
  }

  private void readXThisX(Signal signal) {
    _notesThisBarValueCollector.add(signal.numNotesThisBar());
    _rhythmNotesThisBarValueCollector.add(signal.numRhythmNotesThisBar());
    _anyNotesThisBarValueCollector.add(signal.numNotesThisBar() + signal.numRhythmNotesThisBar());

    _notesThisBarSparkline.values(_notesThisBarValueCollector.values());
    _rhythmNotesThisBarSparkline.values(_rhythmNotesThisBarValueCollector.values());
    _anyNotesThisBarSparkline.values(_anyNotesThisBarValueCollector.values());
  }

  UI draw(PGraphics g) {
    _fftSparkline.draw(g);
    for (int i = 0; i < _bandSparklines.size(); i++) {
      Sparkline bandSparkline = _bandSparklines.get(i);
      bandSparkline.draw(g);

      Sparkline bandAverageSparkline = _bandAverageSparklines.get(i);
      bandAverageSparkline.draw(g);
    }

    _noteSparkline.draw(g);
    _rhythmNoteSparkline.draw(g);
    _noteChart.draw(g);
    _rhythmNoteChart.draw(g);

    _notesThisBarSparkline.draw(g);
    _rhythmNotesThisBarSparkline.draw(g);
    _anyNotesThisBarSparkline.draw(g);

    drawLedMap(g);

    drawControllerChange(g);

    return this;
  }

  void drawLedMap(PGraphics g) {
    color black = color(0);

    float targetX =  10 + 2 * (SPARKLINE_WIDTH + SPACING) + NOTE_CHART_WIDTH + SPACING;
    float targetY = 50 + 4 * (SPARKLINE_HEIGHT + SPACING);
    float targetWidth = 550;
    float targetHeight = 270;
    float margin = 10;

    LedMap ledMap = new LedMap(_lighting.ledMap())
      .moveTo(targetX + margin, targetY + margin)
      .scale(targetWidth - 2 * margin, targetHeight - 2 * margin);

    g.pushStyle();
    g.fill(16);
    g.stroke(64);
    g.rect(targetX, targetY, targetWidth, targetHeight);

    g.ellipseMode(CENTER);
    float radius = 4;

    List<PositionedLed> leds = ledMap.getLeds();
    Iterator it;

    g.noStroke();
    g.fill(0);
    it = leds.iterator();
    while (it.hasNext()) {
      PositionedLed led = (PositionedLed)it.next();
      PVector p = led.position();
      g.ellipse(p.x, p.y, radius, radius);
    }

    g.blendMode(ADD);
    g.noStroke();
    it = leds.iterator();
    while (it.hasNext()) {
      PositionedLed led = (PositionedLed)it.next();
      color c = _lighting.getColor(led.index());
      if (c != black) {
        PVector p = led.position();
        g.fill(c);
        g.ellipse(p.x, p.y, radius, radius);
      }
    }

    g.popStyle();
  }

  void drawControllerChange(PGraphics g) {
    if (_controllerChangeChannel != -1) {
      g.fill(128);
      g.noStroke();
      g.textSize(20);
      g.text("input=" + _controllerChangeNumber + ", value=" + _controllerChangeValue, 20, height - 30);
    }
  }

  UI fftAvgSize(int v) {
    _fftAvgSize = v;
    setupBandValueCollectors();
    setupFftSparklines();
    setupNoteSparklines();
    return this;
  }

  UI fftMaxValue(float v) {
    _fftSparkline.maxValue(v);
    for (int i = 0; i < _bandSparklines.size(); i++) {
      _bandSparklines.get(i).maxValue(v);
      _bandAverageSparklines.get(i).maxValue(v);
    }
    return this;
  }

  UI controllerChange(int channel, int number, int value) {
    _controllerChangeChannel = channel;
    _controllerChangeNumber = number;
    _controllerChangeValue = value;
    return this;
  }
}