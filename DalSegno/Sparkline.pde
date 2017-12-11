
class Sparkline {
  private String _name;
  private float _x;
  private float _y;
  private float _width;
  private float _height;
  private ArrayList<Float> _values;
  private float _maxValue;
  private int _numValues;

  Sparkline(String name) {
    _name = name;
    _x = 0;
    _y = 0;
    _width = 100;
    _height = 20;
    _values = new ArrayList<Float>();
    _maxValue = 1;
    _numValues = 0;
  }

  void draw(PGraphics g) {
    g.pushStyle();

    g.fill(0);
    g.stroke(128);
    g.rect(_x, _y, _width, _height);

    drawSparkline(g);

    g.popStyle();
  }
    
  private void drawSparkline(PGraphics g) {
    g.noStroke();

    float w;
    if (_numValues > 0) {
      w = _width / _numValues;
    } else {
      w = _width / _values.size();
    }

    for (int i = 0; i < _values.size(); i++) {
      float value = _values.get(i);
      float h = value * _height / _maxValue;

      if (value < _maxValue) {
        g.fill(255);
      } else {
        println("Sparkline(" + _name + ") clipped. value=" + value + ", maxValue=" + _maxValue);
        g.fill(255, 0, 0);
      }

      g.rect(_x + _width - _values.size() * w + w * i, _y + _height - h, w, h);
    }
  }

  Sparkline x(float v) {
    _x = v;
    return this;
  }

  Sparkline y(float v) {
    _y = v;
    return this;
  }

  Sparkline width(float v) {
    _width = v;
    return this;
  }

  Sparkline height(float v) {
    _height = v;
    return this;
  }

  Sparkline values(ArrayList<Float> values) {
    _values = values;
    return this;
  }

  Sparkline maxValue(float v) {
    _maxValue = v;
    return this;
  }

  Sparkline numValues(int v) {
    _numValues = v;
    return this;
  }
}