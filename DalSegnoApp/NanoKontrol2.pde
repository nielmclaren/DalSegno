import themidibus.*;

public class NanoKontrol2 {
  private MidiBus _bus;
  private long _lastSave;
  private String _filename;
  private JSONObject _data;
  private int _saveInterval;
  private boolean _isChanged;

  NanoKontrol2(PApplet app, String filename) {
    MidiBus.list();
    _bus = new MidiBus(app, 0, 1);
    _lastSave = millis();
    _filename = filename;
    _data = getDefaultData();
    _saveInterval = 5000;
    _isChanged = false;

    load();

    app.registerMethod("draw", this);
  }

  int getKnob(int index) {
    if (index >= 8) {
      println("Get knob index too high. index=" + index);
    }
    return get(16 + index);
  }

  float getKnobf(int index) {
    return (float)getKnob(index) / 127;
  }

  int getSlider(int index) {
    if (index >= 8) {
      println("Get slider index too high. index=" + index);
    }
    return get(0 + index);
  }

  float getSliderf(int index) {
    return (float)getSlider(index) / 127;
  }

  int get(int index) {
    JSONArray values = _data.getJSONArray("values");
    return values.getInt(index);
  }

  void set(int channel, int number, int value) {
    JSONArray values = _data.getJSONArray("values");
    values.setInt(number, value);
    _data.setJSONArray("values", values);
    _isChanged = true;
  }

  void draw() {
    if (_isChanged && millis() - _lastSave > _saveInterval) {
      save();
      _lastSave = millis();
      _isChanged = false;
    }
  }

  private void load() {
    _data = loadJSONObject(_filename);
  }

  private void save() {
    saveJSONObject(_data, _filename);
  }

  private JSONObject getDefaultData() {
    JSONArray values = new JSONArray();
    for (int i = 0; i < 127; i++) {
      values.setInt(i, 0);
    }

    JSONObject result = new JSONObject();
    result.setJSONArray("values", values);

    return result;
  }
}