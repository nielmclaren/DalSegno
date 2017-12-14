
public class Config {
  Config() {
  }

  int numLeds() {
    return 160;
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
}