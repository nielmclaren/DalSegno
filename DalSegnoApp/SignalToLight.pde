
class SignalToLight {
  List<LedGroup> randomGroups;

  void setup(Signal signal, Lighting lighting) {
    randomGroups = lighting.getGroup().getRandomGroups(8);
  }

  void getLit(Signal signal, Lighting lighting) {
    if (frameCount % 100 == 0) {
      LedGroup randomGroup = lighting.getWalkGroup(30);
      randomGroup.incrementalFade(color(255, 128, 0), 100, 2000);
    }
  }

  void controllerChange(int channel, int number, int value) {
    println(channel, number, value);
  }
}