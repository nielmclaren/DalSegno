
import ddf.minim.*;
import ddf.minim.analysis.*;

public class Signal {
  ddf.minim.Minim _minim;
  ddf.minim.AudioInput _in;
  ddf.minim.analysis.FFT _fft;

  Signal(PApplet app) {
    _minim = new Minim(app);
    _in = _minim.getLineIn();
    _fft = new FFT(_in.bufferSize(), _in.sampleRate());
    _fft.logAverages(88, 1);
    println(_fft.avgSize());

    app.registerMethod("draw", this);
  }

  public void draw() {
    _fft.forward(_in.mix);
  }

  public FFT getFft() {
    return _fft;
  }

  public ArrayList<Float> getFftArray() {
    ArrayList<Float> result = new ArrayList<Float>();
    for (int i = 0; i < _fft.avgSize(); i++) {
      result.add(_fft.getAvg(i));
    }
    return result;
  }
}