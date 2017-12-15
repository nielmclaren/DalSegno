import controlP5.*;

LedMap ledMap;
LedGraph ledGraph;

int numNeighbors;
float edgeProbability;

ControlP5 cp5;

void setup() {
  size(1024, 768);

  numNeighbors = 12;
  edgeProbability = 0.4;

  cp5 = new ControlP5(this);
  cp5.addSlider("numNeighborsSlider")
    .setBroadcast(false)
    .setRange(1, 50)
    .setValue(numNeighbors)
    .setPosition(10, 10)
    .setSize(100, 15)
    .setBroadcast(true);

  cp5.addSlider("edgeProbabilitySlider")
    .setBroadcast(false)
    .setRange(0, 1)
    .setValue(edgeProbability)
    .setPosition(10, 30)
    .setSize(100, 15)
    .setBroadcast(true);

  cp5.addButton("refresh")
    .setBroadcast(false)
    .setPosition(10, 50)
    .setBroadcast(true);
  
  ledMap = new LedMap().load("layout.csv");
  refresh();
}

void refresh() {
  ledGraph = new LedGraph(ledMap)
    .generateRandomNeighborEdges(numNeighbors, edgeProbability);
}

void draw() {
  background(0);

  stroke(128);
  noFill();

  drawLeds(ledGraph);
  drawEdges(ledGraph);
}

void drawLedMap(LedMap ledMap) {
  List<PositionedLed> leds = ledMap.getLeds();
  Iterator it = leds.iterator();
  while (it.hasNext()) {
    PositionedLed led = (PositionedLed)it.next();
    drawLed(led);
  }
}

void drawLeds(LedGraph ledGraph) {
  Set<PositionedLed> vertices = ledGraph.getVertices();
  Iterator it = vertices.iterator();
  while (it.hasNext()) {
    PositionedLed vertex = (PositionedLed)it.next();
    drawLed(vertex);
  }
}

void drawEdges(LedGraph ledGraph) {
  Set<DefaultEdge> edges = ledGraph.getEdges();
  Iterator it = edges.iterator();
  while (it.hasNext()) {
    DefaultEdge edge = (DefaultEdge)it.next();
    drawEdge(ledGraph.getEdgeSource(edge), ledGraph.getEdgeTarget(edge));
  }
}

void drawLed(PositionedLed led) {
  PVector pos = led.position();
  float radius = 6;
  ellipse(pos.x, pos.y, radius, radius);
}

void drawEdge(PositionedLed source, PositionedLed target) {
  PVector sourcePos = source.position();
  PVector targetPos = target.position();

  line(sourcePos.x, sourcePos.y, targetPos.x, targetPos.y);
}

void numNeighborsSlider(float v) {
  numNeighbors = floor(v);
  refresh();
}

void edgeProbabilitySlider(float v) {
  edgeProbability = v;
  refresh();
}
