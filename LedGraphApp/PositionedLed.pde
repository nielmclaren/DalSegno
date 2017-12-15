
public class PositionedLed {
  private int _index;
  private PVector _position;

  PositionedLed(int ledIndex, PVector position) {
    _index = ledIndex;
    _position = position;
  }

  PositionedLed(int ledIndex, float x, float y, float z) {
    _index = ledIndex;
    _position = new PVector(x, y, z);
  }

  int index() {
    return _index;
  }

  PVector position() {
    return _position;
  }
}