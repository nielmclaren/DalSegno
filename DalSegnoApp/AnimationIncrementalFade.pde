
public class AnimationIncrementalFade extends Animation {
  private color _color;
  private int _createdMs;
  private int _incrementalDelayMs;
  private int _durationMs;
  
  AnimationIncrementalFade(LedGroup ledGroup, color c, int incrementalDelayMs, int durationMs) {
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
        float t = (float)(now - _createdMs - i * _incrementalDelayMs) / _durationMs;
        color c = lerpColor(_color, color(0), t);
        ledGroup().addColor(i, c);
      }
    }
  }

  public boolean isComplete() {
    return millis() > _createdMs + _incrementalDelayMs * ledGroup().numLeds() + _durationMs;
  }
}