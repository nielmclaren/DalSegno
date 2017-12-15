
class DistanceLed {
  private PositionedLed _led;
  private float _distance;
  
  DistanceLed(PositionedLed led, float distance) {
    _led = led;
    _distance = distance;
  }

  PositionedLed led() {
    return _led;
  }

  float distance() {
    return _distance;
  }
}