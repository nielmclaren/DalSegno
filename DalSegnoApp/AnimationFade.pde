
public class AnimationFade extends Animation {
  private long _createdMs;
  private color _color;
  private int _durationMs;
  
  AnimationFade(LedGroup ledGroup, color c, int durationMs) {
    super(ledGroup);
    _createdMs = millis();
    _color = c;
    _durationMs = durationMs;
  }
  
  public void update() {
    long now = millis();
    float t = (float)(now - _createdMs) / _durationMs;
    color c = lerpColor(_color, color(0), t);
    ledGroup().addColor(c);
  }

  public boolean isComplete() {
    return millis() > _createdMs + _durationMs;
  }
}