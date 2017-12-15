
public static class Util {
  Util() {}

  static List<Integer> positionedLedsToIndices(List<PositionedLed> positionedLeds) {
    List<Integer> result = new ArrayList<Integer>();
    for (PositionedLed led : positionedLeds) {
      result.add(led.index());
    }
    return result;
  }
}