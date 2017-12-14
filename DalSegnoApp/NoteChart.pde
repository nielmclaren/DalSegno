
class NoteChart {
  private String _name;
  private float _x;
  private float _y;
  private float _width;
  private float _height;
  private ArrayList<ArrayList<Float>> _values;

  NoteChart(String name) {
    _name = name;
    _x = 0;
    _y = 0;
    _width = 100;
    _height = 20;
    _values = new ArrayList<ArrayList<Float>>();
  }

  void draw(PGraphics g) {
    g.pushStyle();

    g.fill(16);
    g.stroke(64);
    g.rect(_x, _y, _width, _height);

    drawChart(g);

    g.popStyle();
  }
    
  private void drawChart(PGraphics g) {
    float[] noteStates = new float[127];
    for (int i = 0; i < 127; i++) {
      noteStates[i] = 0.;
    }

    float w = _width / _values.size();
    float h = _height / 127;
    for (int time = 0; time < _values.size(); time++) {
      ArrayList<Float> notes = _values.get(time);
      for (int note = 0; note < 127; note++) {
        float attack = notes.get(note);
        if (attack >= 0) {
          noteStates[note] = attack;
        }

        if (noteStates[note] > 0) {
          g.noStroke();
          g.fill(128);
          g.rect(_x + time * w, _y + (127 - note - 1) * h, w, h);
        }
      }
    }
  }

  NoteChart x(float v) {
    _x = v;
    return this;
  }

  NoteChart y(float v) {
    _y = v;
    return this;
  }

  NoteChart width(float v) {
    _width = v;
    return this;
  }

  NoteChart height(float v) {
    _height = v;
    return this;
  }

  NoteChart values(ArrayList<ArrayList<Float>> v) {
    _values = v;
    return this;
  }
}