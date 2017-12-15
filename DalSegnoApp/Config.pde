
public class Config {
  Config() {
  }

  int numLeds() {
    return 480;
  }

  int numLedsPerStrand() {
    return 60;
  }

  String fadeCandyIp() {
    return "127.0.0.1";
  }

  int fadeCandyPort() {
    return 7890;
  }

  float fftMaxValue() {
    return 127;
  }

  int maxFftHistorySize() {
    return 200;
  }

  int maxNoteHistorySize() {
    return 200;
  }

  Palette paletteObelia() {
    // blue, pink, turquoise
    color[] colors = {#7435c9, #d26bff, #3fb4ea};
    float[] weights = {0.6, 0.3, 0.1};
    return new Palette(colors, weights);
  }

  Palette paletteInstagram() {
    // pink, purple, blue, orange, yellow
    color[] colors = {#d62095, #a922b0, #4f56d8, #ec3e57, #ffd563};
    float[] weights = {0.35, 0.25, 0.15, 0.15, 0.1};
    return new Palette(colors, weights);
  }
}