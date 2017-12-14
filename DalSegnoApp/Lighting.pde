
public class Lighting {
  private int _numLeds;
  private color[] _ledColors;
  private OPC _opc;
  private ArrayList<Animation> _animations;

  Lighting(PApplet app, Config config) {
    _numLeds = config.numLeds();
    _ledColors = new int[_numLeds];

    _opc = new OPC(app, config.fadeCandyIp(), config.fadeCandyPort());
    _opc.setPixelCount(_numLeds);

    _animations = new ArrayList<Animation>();

    app.registerMethod("draw", this);
  }

  LedGroup getGroup() {
    return new LedGroup(this, _numLeds);
  }

  Lighting setColor(int index, color c) {
    _ledColors[index] = c;
    return this;
  }

  Lighting resetColors() {
    color black = color(0);
    for (int i = 0; i < _numLeds; i++) {
      _ledColors[i] = black;
    }
    return this;
  }

  Lighting addAnimation(Animation animation) {
    _animations.add(animation);
    return this;
  }

  void draw() {
    updateAnimations();
    writePixels();
  }

  private void updateAnimations() {
    for (int i = 0; i < _animations.size(); i++) {
      Animation animation = _animations.get(i);
      if (animation.isComplete()) {
        _animations.remove(i);
        i--;
      } else {
        animation.update();
      }
    }
  }

  private void writePixels() {
    for (int i = 0; i < _numLeds; i++) {
      _opc.setPixel(i, _ledColors[i]);
    }
    _opc.writePixels();
  }
}