
public class AnimationFade extends AnimationTimed {
  private color _color;
  
  AnimationFade(LedGroup ledGroup, color c, int delayMs, int durationMs) {
    super(ledGroup, delayMs, durationMs);
    _color = c;
  }
  
  public void update() {
    if (isStarted()) {
      long now = millis();
      float t = (float)(now - _createdMs) / _durationMs;
      color c = lerpColor(_color, color(0), t);
      ledGroup().addColor(c);
    }
  }
}