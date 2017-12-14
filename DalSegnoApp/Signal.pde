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
    return result;
  }

  ArrayList<Note> readRhythmNotes() {
    ArrayList<Note> result = _rhythmNotes;
    _rhythmNotes = new ArrayList<Note>();
    return result;
  }

  void oscEvent(OscMessage m) {
    if (m.checkAddrPattern("/beat")) {
      //println("/beat", m.get(0).intValue());
      _beat = m.get(0).intValue();
    }
    if (m.checkAddrPattern("/measureDivision")) {
      //println("/measureDivision", m.get(0).floatValue());
      _measureDivision = m.get(0).floatValue();
    }
    if (m.checkAddrPattern("/note")) {
      //println("/note", m.get(0).intValue(), m.get(1).intValue(), m.get(2).intValue());
      _notes.add(new Note(m));
    }
    if (m.checkAddrPattern("/playing")) {
      //println("/playing", m.get(0).intValue());
      _isPlaying = m.get(0).intValue() != 0;
    }
    if (m.checkAddrPattern("/rthm")) {
      //println("/rthm", m.get(0).intValue(), m.get(1).intValue(), m.get(2).intValue());
      _rhythmNotes.add(new Note(m));
    }
    if (m.checkAddrPattern("/tempo")) {
      //println("/tempo", m.get(0).floatValue());
      _tempo = m.get(0).floatValue();
    }
  }
}