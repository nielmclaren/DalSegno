
public class LedGroup {
  private Lighting _lighting;
  private int[] _ledIndices;

  LedGroup(Lighting lighting) {
    _lighting = lighting;
  }

  LedGroup(Lighting lighting, int[] ledIndices) {
    _lighting = lighting;
    _ledIndices = ledIndices;
  }

  LedGroup(Lighting lighting, int numLeds) {
    _lighting = lighting;
    _ledIndices = new int[numLeds];
    for (int i = 0; i < numLeds; i++) {
      _ledIndices[i] = i;
    }
  }

  LedGroup ledIndices(int[] v) {
    _ledIndices = v;
    return this;
  }

  int numLeds() {
    return _ledIndices.length;
  }

  LedGroup addColor(color c) {
    for (int i = 0; i < _ledIndices.length; i++) {
      _lighting.addColor(_ledIndices[i], c);
    }
    return this;
  }

  LedGroup setColor(color c) {
    for (int i = 0; i < _ledIndices.length; i++) {
      _lighting.setColor(_ledIndices[i], c);
    }
    return this;
  }

  LedGroup addColor(int index, color c) {
    _lighting.addColor(_ledIndices[index], c);
    return this;
  }

  LedGroup setColor(int index, color c) {
    _lighting.setColor(_ledIndices[index], c);
    return this;
  }

  ArrayList<LedGroup> getRandomGroups(int numGroups) {
    ArrayList<ArrayList<Integer>> ledIndicesByGroup = new ArrayList<ArrayList<Integer>>();
    for (int group = 0; group < numGroups; group++) {
      ledIndicesByGroup.add(new ArrayList<Integer>());
    }
    for (int ledIndex = 0; ledIndex < _ledIndices.length; ledIndex++) {
      int group = floor(random(numGroups));
      ledIndicesByGroup.get(group).add(ledIndex);
    }

    ArrayList<LedGroup> result = new ArrayList<LedGroup>();
    for (int group = 0; group < numGroups; group++) {
      ArrayList<Integer> ledIndices = ledIndicesByGroup.get(group);
      result.add(new LedGroup(_lighting).ledIndices(toArray(ledIndices)));
    }
    return result;
  }

  LedGroup fade(color c, int durationMs) {
    _lighting.addAnimation(new AnimationFade(this, c, durationMs));
    return this;
  }

  LedGroup pulse(color c, int durationMs) {
    _lighting.addAnimation(new AnimationPulse(this, c, durationMs));
    return this;
  }

  private int[] toArray(ArrayList<Integer> input) {
    int[] output = new int[input.size()];
    for (int i = 0; i < input.size(); i++) {
      output[i] = input.get(i);
    }
    return output;
  }
}
  