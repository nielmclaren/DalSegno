
public class Note {
  private int _channel;
  private int _note;
  private int _velocity;

  Note(OscMessage m) {
    _channel = m.get(0).intValue();
    _note = m.get(1).intValue();
    _velocity = m.get(2).intValue();
  }

  int channel() {
    return _channel;
  }

  int note() {
    return _note;
  }

  int velocity() {
    return _velocity;
}
}