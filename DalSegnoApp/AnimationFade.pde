
public class AnimationFade extends Animation {
  private long _createdMs;
  private int _durationMs;
  
  AnimationFade(LedGroup ledGroup, int durationMs) {
    super(ledGroup);
    _createdMs = millis();
    _durationMs = durationMs;
  }
  
  public void update() {
    long now = millis();
    color c = color(map(now - _createdMs, 0, _durationMs, 255, 0));
    ledGroup().setColor(c);
  }

  public boolean isComplete() {
    return millis() > _createdMs + _durationMs;
  }
}