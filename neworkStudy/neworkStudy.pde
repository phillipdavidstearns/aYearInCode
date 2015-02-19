PVector gravity = new PVector(0, 1);

ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Edge> edges = new ArrayList<Edge>();

int qtyNodes = 50;

void setup() {
  size(500, 500);
  for (int i = 0; i < qtyNodes; i++) {
    nodes.add(new Node(i));
  }
  frameRate(30);
}

void draw() {
  background(255);
  
  for (int i = nodes.size()-1; i >= 0; i--) {
    Node n = nodes.get(i);
    n.run(nodes, edges);
  }
  updateEdges(nodes);

  for (int i = edges.size()-1; i >= 0; i--) {
    Edge e = edges.get(i);
    e.display();
  }

  
  if (frameCount > 300 && frameCount < 400) {
   saveFrame("output/2015-02-18/002/dynamic_edges_springs_####.PNG");
  }
}

void updateEdges(ArrayList<Node> _nodes) {
  // check every node in the system against every other node
  for (int i = _nodes.size () - 1; i >= 0; i--) {
    Node n1 = _nodes.get(i);
    for (int j = _nodes.size () - 1; j >= 0; j--) {
      Node n2 = _nodes.get(j);
      float dist = n1.location.dist(n2.location);
      boolean edgeExists = false;
      //ignore itself
      if (i!=j) {
        // if there are no edges (initial condition, for instance)
        if (edges.isEmpty()) {
          if (dist < n1.formBond | dist < n2.formBond ) {
            Edge e = new Edge(n1, n2);
            edges.add(e);
          }
        } else {
          // check each edge to see if it already exists
          for ( int k = edges.size () - 1; k >= 0; k--) {
            // the case wehre the edge exists
            if (( edges.get(k).head_ID == n1.ID && edges.get(k).tail_ID == n2.ID )||(edges.get(k).head_ID == n2.ID && edges.get(k).tail_ID == n1.ID )) {
              //remove the edge if there is too much distance between
              if (dist >= n1.breakBond || dist >= n2.breakBond) {
                edges.remove(k);
              }
              edgeExists = true;
            }
          }
          // if there isn't an edge connecting the two nodes, make one
          if (!edgeExists && dist < n1.formBond | dist < n2.formBond ) {
            Edge e = new Edge(n1, n2);
            edges.add(e);
          }
        }
      }
    }
  }
}

