
public class AnimationPulse extends Animation {
  private long _createdMs;
  private color _color;
  private int _durationMs;
  
  AnimationPulse(LedGroup ledGroup, color c, int durationMs) {
    super(ledGroup);
    _createdMs = millis();
    _color = c;
    _durationMs = durationMs;
  }
  
  public void update() {
    long now = millis();
    float t = map(now - _createdMs, 0, _durationMs, 0, 1);
    float tt = t < 0.5 ? t / 0.5 : (1 - t) / 0.5;
    color c = lerpColor(color(0), _color, tt);
    ledGroup().addColor(c);
  }

  public boolean isComplete() {
    return millis() > _createdMs + _durationMs;
  }
}