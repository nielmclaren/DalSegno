
class SignalToLight {
  List<LedGroup> randomGroups;

  void setup(Signal signal, Lighting lighting) {
    randomGroups = lighting.getGroup().getRandomGroups(8);
  }

  void getLit(Signal signal, Lighting lighting) {
    if (frameCount % 100 == 0) {
      LedGroup randomGroup = randomGroups.get(floor(random(randomGroups.size())));
      randomGroup.incrementalPulse(color(255, 128, 0), 20, 2000);
    }
  }

  void controllerChange(int channel, int number, int value) {
    println(channel, number, value);
  }
}