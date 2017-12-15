
public class AnimationPulse extends AnimationTimed {
  private color _color;
  
  AnimationPulse(LedGroup ledGroup, color c, int delayMs, int durationMs) {
    super(ledGroup, delayMs, durationMs);
    _color = c;
  }
  
  public void update() {
    if (isStarted()) {
      long now = millis();
      float t = map(now - _createdMs, 0, _durationMs, 0, 1);
      float tt = t < 0.5 ? t / 0.5 : (1 - t) / 0.5;
      color c = lerpColor(color(0), _color, tt);
      ledGroup().addColor(c);
    }
  }
}