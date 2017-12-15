
public class AnimationTimed extends Animation {
  protected long _createdMs;
  protected int _delayMs;
  protected int _durationMs;
  
  AnimationTimed(LedGroup ledGroup, int delayMs, int durationMs) {
    super(ledGroup);
    _createdMs = millis();
    _delayMs = delayMs;
    _durationMs = durationMs;
  }

  public boolean isStarted() {
    return millis() >= _createdMs + _delayMs;
  }

  public boolean isComplete() {
    return millis() > _createdMs + _durationMs;
  }
}