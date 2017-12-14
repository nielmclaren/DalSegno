
public class UI {
  private final int SPARKLINE_WIDTH = 200;
  private final int SPARKLINE_HEIGHT = 30;
  private final int NOTE_CHART_WIDTH = 300;
  private final int SPACING = 6;

  private float _initialFftMaxValue = 100;
  private ControlP5 _cp5;

  private Sparkline _fftSparkline;
  private int _fftAvgSize;
  private ArrayList<ValueCollector> _bandValueCollectors;
  private ArrayList<Sparkline> _bandSparklines;
  private ArrayList<Sparkline> _band5AverageSparklines;
  private ArrayList<Sparkline> _band10AverageSparklines;

  private Sparkline _noteSparkline;
  private Sparkline _rhythmNoteSparkline;
  private ArrayList<ArrayList<Float>> _noteHistory;
  private ArrayList<ArrayList<Float>> _rhythmNoteHistory;
  private int _maxNoteHistorySize;
  private NoteChart _noteChart;
  private NoteChart _rhythmNoteChart;

  private ValueCollector _notesThisBarValueCollector;
  private ValueCollector _rhythmNotesThisBarValueCollector;
  private ValueCollector _anyNotesThisBarValueCollector;

  private Sparkline _notesThisBarSparkline;
  private Sparkline _rhythmNotesThisBarSparkline;
  private Sparkline _anyNotesThisBarSparkline;

  UI(PApplet app) {
    _cp5 = new ControlP5(app);
    _fftAvgSize = 0;

    setup();
    setupBandValueCollectors();
    setupFftSparklines();
    setupNoteValueCollectors();
    setupNoteHistory();
    setupNoteSparklines();
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

  private void setupFftSparklines() {
    _fftSparkline = new Sparkline("fft")
      .x(100).y(50).width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
      .maxValue(_initialFftMaxValue);

    _bandSparklines = new ArrayList<Sparkline>();
    _band5AverageSparklines = new ArrayList<Sparkline>();
    _band10AverageSparklines = new ArrayList<Sparkline>();
    for (int i = 0; i < _fftAvgSize; i++) {
      _bandSparklines.add(
        new Sparkline("band" + i)
          .x(100).y(50 + (i + 1) * (SPARKLINE_HEIGHT + SPACING))
          .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
          .numValues(100)
          .maxValue(_initialFftMaxValue));

      _band5AverageSparklines.add(
        new Sparkline("band5Average" + i)
          .x(100 + SPARKLINE_WIDTH + SPACING).y(50 + (i + 1) * (SPARKLINE_HEIGHT + SPACING))
          .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
          .numValues(100 - 5 + 1)
          .maxValue(_initialFftMaxValue));

      _band10AverageSparklines.add(
        new Sparkline("band10Average" + i)
          .x(100 + 2 * (SPARKLINE_WIDTH + SPACING)).y(50 + (i + 1) * (SPARKLINE_HEIGHT + SPACING))
          .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
          .numValues(100 - 10 + 1)
          .maxValue(_initialFftMaxValue));
    }
  }

  private void setupNoteValueCollectors() {
    _notesThisBarValueCollector = new ValueCollector().maxValues(100);
    _rhythmNotesThisBarValueCollector = new ValueCollector().maxValues(100);
    _anyNotesThisBarValueCollector = new ValueCollector().maxValues(100);
  }

  private void setupNoteHistory() {
    _maxNoteHistorySize = 50;

    ArrayList<Float> noNotes = new ArrayList<Float>();
    for (int i = 0; i < 127; i++) {
      noNotes.add(0.);
    }

    _noteHistory = new ArrayList<ArrayList<Float>>();
    for (int i = 0; i < _maxNoteHistorySize; i++) {
      _noteHistory.add(new ArrayList<Float>(noNotes));
    }

    _rhythmNoteHistory = new ArrayList<ArrayList<Float>>();
    for (int i = 0; i < _maxNoteHistorySize; i++) {
      _rhythmNoteHistory.add(new ArrayList<Float>(noNotes));
    }
  }

  private void setupNoteSparklines() {
    _noteSparkline = new Sparkline("note")
      .x(100 + 3 * (SPARKLINE_WIDTH + SPACING)).y(50)
      .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
      .maxValue(127);

    _rhythmNoteSparkline = new Sparkline("rhythmNote")
      .x(100 + 3 * (SPARKLINE_WIDTH + SPACING) + NOTE_CHART_WIDTH + SPACING).y(50)
      .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
      .maxValue(127);

    _noteChart = new NoteChart("note")
      .x(100 + 3 * (SPARKLINE_WIDTH + SPACING)).y(50 + SPARKLINE_HEIGHT + SPACING)
      .width(NOTE_CHART_WIDTH).height(500);

    _rhythmNoteChart = new NoteChart("rhythmNote")
      .x(100 + 3 * (SPARKLINE_WIDTH + SPACING) + NOTE_CHART_WIDTH + SPACING).y(50 + SPARKLINE_HEIGHT + SPACING)
      .width(NOTE_CHART_WIDTH).height(500);

    _notesThisBarSparkline = new Sparkline("notesThisBar")
      .x(100).y(height - 3 * (SPARKLINE_HEIGHT + SPACING))
      .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
      .maxValue(32);
    _rhythmNotesThisBarSparkline = new Sparkline("rhythmNotesThisBar")
      .x(100).y(height - 2 * (SPARKLINE_HEIGHT + SPACING))
      .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
      .maxValue(32);
    _anyNotesThisBarSparkline = new Sparkline("anyNotesThisBar")
      .x(100).y(height - 1 * (SPARKLINE_HEIGHT + SPACING))
      .width(SPARKLINE_WIDTH).height(SPARKLINE_HEIGHT)
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

      Sparkline band5AverageSparkline = _band5AverageSparklines.get(i);
      band5AverageSparkline.values(bandValueCollector.getRunningAverage(5));

      Sparkline band10AverageSparkline = _band10AverageSparklines.get(i);
      band10AverageSparkline.values(bandValueCollector.getRunningAverage(10));
    }
  }

  private void readNotes(ArrayList<Note> notes) {
    ArrayList<Float> noteData = getNoteData(notes);

    _noteHistory.add(noteData);
    while (_noteHistory.size() > 50) {
      _noteHistory.remove(0);
    }

    _noteSparkline.values(noteData);
    _noteChart.values(_noteHistory);
  }

  private void readRhythmNotes(ArrayList<Note> notes) {
    ArrayList<Float> noteData = getNoteData(notes);

    _rhythmNoteHistory.add(noteData);
    while (_rhythmNoteHistory.size() > 50) {
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

      Sparkline band5AverageSparkline = _band5AverageSparklines.get(i);
      band5AverageSparkline.draw(g);

      Sparkline band10AverageSparkline = _band10AverageSparklines.get(i);
      band10AverageSparkline.draw(g);
    }

    _noteSparkline.draw(g);
    _rhythmNoteSparkline.draw(g);
    _noteChart.draw(g);
    _rhythmNoteChart.draw(g);

    _notesThisBarSparkline.draw(g);
    _rhythmNotesThisBarSparkline.draw(g);
    _anyNotesThisBarSparkline.draw(g);

    return this;
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
      _band5AverageSparklines.get(i).maxValue(v);
      _band10AverageSparklines.get(i).maxValue(v);
    }
    return this;
  }
}