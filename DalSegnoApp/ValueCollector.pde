
class ValueCollector {
  private ArrayList<Float> _values;
  private int _maxValues;

  ValueCollector() {
    _values = new ArrayList<Float>();
    _maxValues = 100;
  }

  ValueCollector add(float v) {
    _values.add(v);
    if (_values.size() > _maxValues) {
      _values.remove(0);
    }
    return this;
  }

  ArrayList<Float> values() {
    return _values;
  }

  ArrayList<Float> getRunningAverage(int historySize) {
    ArrayList<Float> result = new ArrayList<Float>();
    ArrayList<Float> history = new ArrayList<Float>();
    int currHistorySize = 0;

    for (int i = 0; i < _values.size(); i++) {
      history.add(_values.get(i));
      currHistorySize++;

      if (currHistorySize > historySize) {
        history.remove(0);
      }

      if (history.size() >= historySize) {
        result.add(getAverage(history));
      }
    }
    return result;
  }

  private float getAverage(ArrayList<Float> values) {
    if (values.size() <= 0) {
      return 0;
    }

    float sum = 0;
    for (float value : values) {
      sum += value;
    }
    return sum / values.size();
  }

  ValueCollector maxValues(int v) {
    _maxValues = v;
    return this;
  }
}