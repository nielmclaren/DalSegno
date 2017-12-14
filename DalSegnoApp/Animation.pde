
public class Animation {
  private LedGroup _ledGroup;
  
  Animation(LedGroup ledGroup) {
    _ledGroup = ledGroup;
  }

  public void update() {
  }

  public boolean isComplete() {
    return true;
  }

  public LedGroup ledGroup() {
    return _ledGroup;
  }
}