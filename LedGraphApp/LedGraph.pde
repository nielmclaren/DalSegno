import org.jgrapht.Graph;
import org.jgrapht.graph.DefaultEdge;
import org.jgrapht.graph.SimpleGraph;

import java.util.Set;

public class LedGraph {
  private LedMap _ledMap;
  private Graph _graph;

  LedGraph(LedMap ledMap) {
    _ledMap = ledMap;
    _graph = new SimpleGraph(DefaultEdge.class);

    loadLedMap();
  }

  private void loadLedMap() {
    _graph = new SimpleGraph(DefaultEdge.class);

    List<PositionedLed> leds = _ledMap.getLeds();
    for (PositionedLed led : leds) {
      _graph.addVertex(led);
    }
  }

  LedGraph generateRandomNearestEdges(int minEdges, int maxEdges) {
    List<PositionedLed> leds = ledMap.getLeds();
    for (PositionedLed led : leds) {
      int numNeighborConnections = floor(random(minEdges, maxEdges));
      List<PositionedLed> neighbours = _ledMap.getLedsNearest(led.position(), numNeighborConnections, led.index());
      for (PositionedLed neighbor : neighbours) {
        _graph.addEdge(led, neighbor);
      }
    }
    return this;
  }

  LedGraph generateRandomNeighborEdges(int numNeighbors, float edgeProbability) {
    List<PositionedLed> leds = ledMap.getLeds();
    for (PositionedLed led : leds) {
      List<PositionedLed> neighbours = _ledMap.getLedsNearest(led.position(), numNeighbors, led.index());
      for (PositionedLed neighbor : neighbours) {
        if (random(1) < edgeProbability) {
          _graph.addEdge(led, neighbor);
        }
      }
    }
    return this;
  }

  Set<PositionedLed> getVertices() {
    return _graph.vertexSet();
  }

  Set<DefaultEdge> getEdges() {
    return _graph.edgeSet();
  }


  PositionedLed getEdgeSource(DefaultEdge edge) {
    return (PositionedLed)_graph.getEdgeSource(edge);
  }
  PositionedLed getEdgeTarget(DefaultEdge edge) {
    return (PositionedLed)_graph.getEdgeTarget(edge);
  }
}