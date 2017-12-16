import netP5.*;
import oscP5.*;

import ddf.minim.*;
import ddf.minim.analysis.*;

public class Signal {
  private ddf.minim.Minim _minim;
  private ddf.minim.AudioInput _in;
  private ddf.minim.analysis.FFT _fft;

  private OscP5 _oscP5;
  private int _beat;
  private boolean _isPlaying;
  private float _measureDivision;
  private ArrayList<Note> _notes;
  private ArrayList<Note> _rhythmNotes;
  private float _tempo;

  private int _numNotesThisBar;
  private int _numRhythmNotesThisBar;

  private boolean[] _notesJustPlayed;
  private boolean[] _notesPlayedThisBar;

  Signal(PApplet app) {
    _minim = new Minim(app);
    _in = _minim.getLineIn();
    _fft = new FFT(_in.bufferSize(), _in.sampleRate());
    _fft.logAverages(88, 1);
    println(_fft.avgSize());

    _oscP5 = new OscP5(this, 6666);
    _beat = 0;
    _isPlaying = false;
    _measureDivision = 0;
    _notes = new ArrayList<Note>();
    _rhythmNotes = new ArrayList<Note>();
    _tempo = 0;

    _numNotesThisBar = 0;
    _numRhythmNotesThisBar = 0;

    _notesJustPlayed = new boolean[127];
    _notesPlayedThisBar = new boolean[127];

    app.registerMethod("draw", this);
  }

  public void draw() {
    _fft.forward(_in.mix);
  }

  FFT getFft() {
    return _fft;
  }

  ArrayList<Float> getFftArray() {
    ArrayList<Float> result = new ArrayList<Float>();
    for (int i = 0; i < _fft.avgSize(); i++) {
      result.add(_fft.getAvg(i));
    }
    return result;
  }

  ArrayList<Note> readNotes() {
    ArrayList<Note> result = _notes;
    _notes = new ArrayList<Note>();
    resetNotes(_notesJustPlayed);
    return result;
  }

  ArrayList<Note> readRhythmNotes() {
    ArrayList<Note> result = _rhythmNotes;
    _rhythmNotes = new ArrayList<Note>();
    return result;
  }

  int numNotesThisBar() {
    return _numNotesThisBar;
  }

  int numRhythmNotesThisBar() {
    return _numRhythmNotesThisBar;
  }

  boolean isNoteJustPlayed(int note) {
    return _notesJustPlayed[note];
  }

  boolean isNotePlayedThisBar(int note) {
    return _notesPlayedThisBar[note];
  }

  private void resetNotes(boolean[] notes) {
    for (int i = 0; i < notes.length; i++) {
      notes[i] = false;
    }
  }

  void oscEvent(OscMessage m) {
    boolean debug = true;

    if (m.checkAddrPattern("/beat")) {
      if (debug) println("/beat", m.get(0).intValue());
      _beat = m.get(0).intValue();

      resetNotes(_notesPlayedThisBar);

      _numNotesThisBar = 0;
      _numRhythmNotesThisBar = 0;
    }
    if (m.checkAddrPattern("/measureDivision")) {
      if (debug) println("/measureDivision", m.get(0).floatValue());
      _measureDivision = m.get(0).floatValue();
    }
    if (m.checkAddrPattern("/note")) {
      if (debug) println("/note", m.get(0).intValue(), m.get(1).intValue(), m.get(2).intValue());
      Note note = new Note(m);
      _notes.add(note);

      _notesJustPlayed[note.note()] = true;
      _notesPlayedThisBar[note.note()] = true;

      if (note.velocity() > 0) {
        _numNotesThisBar++;
      }
    }
    if (m.checkAddrPattern("/playing")) {
      if (debug) println("/playing", m.get(0).intValue());
      _isPlaying = m.get(0).intValue() != 0;
    }
    if (m.checkAddrPattern("/rthm")) {
      if (debug) println("/rthm", m.get(0).intValue(), m.get(1).intValue(), m.get(2).intValue());
      Note note = new Note(m);
      _rhythmNotes.add(note);

      if (note.velocity() > 0) {
        _numRhythmNotesThisBar++;
      }
    }
    if (m.checkAddrPattern("/tempo")) {
      if (debug) println("/tempo", m.get(0).floatValue());
      _tempo = m.get(0).floatValue();
    }
  }
}