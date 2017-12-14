
public class Palette {
  private color[] _colors;
  private float[] _weights;
  private int _index;
  
  Palette(color[] colors, float[] weights) {
    _colors = colors;
    _weights = weights;
    _index = 0;

    // `weights` should be same length as `colors` and add up to 1.
    assert(_colors.length == _weights.length);
    assert(sum(weights) == 1);
  }

  color weightedColor() {
    float r = random(1);
    int index = 0;
    float accumulator = 0;
    while (r > accumulator && index <= _weights.length) {
      accumulator += _weights[index];
      index++;
    }
    return _colors[index - 1];
  }

  color sequentialColor() {
    color c = _colors[_index];
    _index++;
    if (_index >= _colors.length) {
      _index = 0;
    }
    return c;
  }

  private float sum(float[] values) {
    float result = 0;
    for (int i = 0; i < values.length; i++) {
      result += values[i];
    }
    return result;
  }
}