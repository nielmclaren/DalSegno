
import java.util.Comparator;

class DistanceLedComparator implements Comparator<DistanceLed> {
  public int compare(DistanceLed a, DistanceLed b) {
    return floor(a.distance() - b.distance());
  }
}