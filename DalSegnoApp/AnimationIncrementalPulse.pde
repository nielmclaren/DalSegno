
public class AnimationIncrementalPulse extends Animation {
  private color _color;
  private int _createdMs;
  private int _incrementalDelayMs;
  private int _durationMs;
  
  AnimationIncrementalPulse(LedGroup ledGroup, color c, int incrementalDelayMs, int durationMs) {
    super(ledGroup);
    _color = c;
    _createdMs = millis();
    _incrementalDelayMs = incrementalDelayMs;
    _durationMs = durationMs;
  }
  
  public void update() {
    long now = millis();
    int numLeds = ledGroup().numLeds();
    for (int i = 0; i < numLeds; i++) {
      if (now - _createdMs > i * _incrementalDelayMs) {
        float t = map(now - _createdMs, 0, _durationMs, 0, 1);
        float tt = t < 0.5 ? t / 0.5 : (1 - t) / 0.5;
        color c = lerpColor(color(0), _color, tt);
        ledGroup().addColor(i, c);
      }
    }
  }

  public boolean isComplete() {
    return millis() > _createdMs + _incrementalDelayMs * ledGroup().numLeds() + _durationMs;
  }
}