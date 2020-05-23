PVector gravity = new PVector(0, 1);

int[][] edgeCatalog;

ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Edge> edges = new ArrayList<Edge>();

ArrayList<PVector> NodesToAdd = new ArrayList<PVector>();
ArrayList<PVector> NodesToRemove = new ArrayList<PVector>();

int qtyNodes = 00;

float make_bond = 150;
float break_bond = 200;
float spring_length = 125;
float spring_constant = 1;
float dampening = -.125;

void setup() {
  size(500, 500);
  
  edgeCatalog = new int[qtyNodes][qtyNodes];

  for (int a = 0; a < qtyNodes; a++) {
    nodes.add(new Node(a));
    for (int b = 0; b < qtyNodes; b++) {
      edgeCatalog[a][b]=0;
    }
  }

  frameRate(30);
}

void draw() {
  background(255);

  for (int i = 0; i < NodesToAdd.size(); i++) {
    addNode(NodesToAdd.get(i));
  }
  NodesToAdd.clear();

  for (int i = 0; i < NodesToRemove.size(); i++) {
    removeNode(NodesToRemove.get(i));
  }
  NodesToRemove.clear();

  updateEdges();
  calculateForces();

  for (int i = 0; i < nodes.size(); i++) {
    nodes.get(i).run(nodes);
  }

  for (int i = 0; i < edges.size(); i++) {
    edges.get(i).display();
  }

  if (frameCount >= 1000 && frameCount <= 1149) {  
    //   saveFrame("output/2015_03_16/002/2015_03_16_002_networkFun-####.PNG");
  }
  if (frameCount >= 100) {
    //    exit();
  }
}

void keyPressed() {
}

void mousePressed() {

  PVector clickLocation = new PVector(mouseX, mouseY);

  if (mouseButton == LEFT) {
    NodesToAdd.add(clickLocation);
  }
  if (mouseButton == RIGHT) {
    NodesToRemove.add(clickLocation);
  }
}

void addNode(PVector _position) {
  Node n = new Node( _position.x, _position.y, nodes.size());
  nodes.add(n);
}

void removeNode(PVector _position) {
  for (int i = nodes.size()-1; i >=0; i--) {
    Node n = nodes.get(i);
    if (PVector.dist(_position, n.position) <= n.r) {  
      for (int k = 0; k < edges.size(); k++) {
        Edge e = edges.get(k);
        if (e.tail.ID == n.ID || e.head.ID == n.ID) {
          edges.remove(k); 
          nodes.get(e.head.ID).edgeCount--;
          nodes.get(e.tail.ID).edgeCount--;
        }
      }
      nodes.remove(i);
      break;
    }
  }
}


void updateEdges() {

  edgeCatalog = new int[nodes.size()+1][nodes.size()+1];
  //creates initial bonds if none exist
  if (edges.size() == 0) {
    for (int i = 0; i < nodes.size(); i++) {
      Node n1 = nodes.get(i);
      for (int j = i+1; j < nodes.size(); j++) {
        Node n2 = nodes.get(j);
        if (PVector.dist(n1.position, n2.position) <= make_bond && n1.edgeCount < n1.maxconnections && n2.edgeCount < n2.maxconnections) {
          Edge e = new Edge(n1, n2);
          edges.add(e);
          edgeCatalog[n1.ID][n2.ID]++;
          edgeCatalog[n2.ID][n1.ID]++;
          n1.edgeCount++;
          n2.edgeCount++;
        }
      }
    }
  } else {
    //update existing bonds
    for (int k = edges.size()-1; k >= 0; k--) {
      Edge e = edges.get(k);
      //count existing valid edges and remove invalid ones
      if (e.distance() < break_bond) {
        edgeCatalog[e.head.ID][e.tail.ID]++;
      } else if (e.distance() >= break_bond) {
        edges.remove(k); 
        edgeCatalog[e.head.ID][e.tail.ID]--;
        edgeCatalog[e.tail.ID][e.head.ID]--;
        nodes.get(e.head.ID).edgeCount--;
        nodes.get(e.tail.ID).edgeCount--;
      }
    }
    //if there's not already an edge for a pair of nodes within the make_bond distance, make one
    for (int i = 0; i < nodes.size(); i++) {
      for (int j = i+1; j < nodes.size(); j++) {
        if (edgeCatalog[i][j] == 0) {
          Node n1 = nodes.get(i);
          Node n2 = nodes.get(j);
          if (PVector.dist(n1.position, n2.position) <= make_bond && n1.edgeCount < n1.maxconnections && n2.edgeCount < n2.maxconnections) {
            Edge e = new Edge(n1, n2);
            edges.add(e);
            n1.edgeCount++;
            n2.edgeCount++;
          }
        }
      }
    }
  }
}

void calculateForces() {

  for (Edge e: edges) {
    
    //calculate the magnitude of force exterted by the edge's springy properties
    float _mag = spring_constant * (spring_length - e.distance());
    
    //create force vectors for each node defining the edge 
    PVector _forceA = PVector.sub(e.head.position, e.tail.position).setMag(_mag);
    PVector _forceB = _forceA.copy().mult(-1);

    e.head.applyForce(_forceA);
    e.tail.applyForce(_forceB);

    //calculates the projection of velocity onto the vector describing the edge
    //used to calculate and apply dampening force for the edge
    e.head.applyForce(_forceA.copy().setMag(e.head.velocity.mag()*cos(_forceA.heading() - e.head.velocity.heading())).mult(dampening));
    e.tail.applyForce(_forceB.copy().setMag(e.tail.velocity.mag()*cos(_forceB.heading() - e.tail.velocity.heading())).mult(dampening));
  }
}
