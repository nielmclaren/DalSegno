
public class Lighting {
  private int _numPixels;
  private OPC _opc;

  Lighting(PApplet app, Config config) {
    _numPixels = config.numPixels();
    _opc = new OPC(app, config.fadeCandyIp(), config.fadeCandyPort());
    _opc.setPixelCount(_numPixels);
    app.registerMethod("draw", this);
  }

  void draw() {
    color c = (frameCount / 50) % 2 == 0 ? color(128, 0, 0) : color(0, 128, 0);

    for (int i = 0; i < _numPixels; i++) {
      _opc.setPixel(i, c);
    }

    _opc.writePixels();
  }
}