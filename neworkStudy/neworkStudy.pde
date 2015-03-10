PVector gravity = new PVector(0, 1);
boolean[][] edgeCatalog;
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Edge> edges = new ArrayList<Edge>();

PVector[] forces;

int qtyNodes = 1500;

float make_bond = 30;
float break_bond = 30;
float spring_length = 25;
float spring_constant = 1.25;

void setup() {
  size(500,500);
  
  for (int i = 0; i < qtyNodes; i++) {
    nodes.add(new Node(i));
  }
  
  forces = new PVector[qtyNodes];
  edgeCatalog = new boolean[qtyNodes][qtyNodes];
  
  for(int a = 0; a < qtyNodes ; a++){
    forces[a]= new PVector(0,0);
    for(int b = 0; b < qtyNodes ; b++){
      edgeCatalog[a][b]=false;
    }
  }
  
  frameRate(30);
}

void draw() {
  background(255);
  
  
  
  updateEdges();
  calculateForces();
  
  for(int i = 0; i < forces.length ; i++){
    nodes.get(i).applyForce(forces[i]);
  }
  
  for(int i = 0; i < nodes.size() ; i++){
    nodes.get(i).run(nodes);
  }
  for(int i = 0; i < edges.size() ; i++){
    edges.get(i).display();
  }
  
  
    saveFrame("output/2015_03_10/001/2015_03_10_001_networkFun-####.PNG");
  if(frameCount >= 60){
    exit();
  }
}

void step(){

}

void keyPressed(){
  char k = key;
  switch(k){
    case '1':
      step();
    break;
  }
}

void updateEdges(){
  
  ArrayList<Edge> newEdges = new ArrayList<Edge>();
  
  for(int a = 0; a < qtyNodes ; a++){
    for(int b = 0; b < qtyNodes ; b++){
      edgeCatalog[a][b]=false;
    }
  }
  
  //the creates initial bonds if none exist
  if(edges.size() == 0){
    for (int i = 0; i < nodes.size() ; i++){
      Node n1 = nodes.get(i);
      for (int j = i; j < nodes.size() ; j++){
        Node n2 = nodes.get(j);
        if ( j != i ){
          if (PVector.dist(n1.location, n2.location) <= make_bond) {
            Edge e = new Edge(n1, n2);
            newEdges.add(e);
            edgeCatalog[n1.ID][n2.ID] = true;
            edgeCatalog[n2.ID][n1.ID] = true; 
          }
        }
      }
    }
    edges=newEdges;
  } else {
    //update existing bonds and add to new_edges, bonds greater than the breaking length are left behind
    for(int k = 0 ; k < edges.size() ; k++){
      Edge e = edges.get(k);
      Node head = nodes.get(e.head_ID);
      Node tail = nodes.get(e.tail_ID);
      if(PVector.dist(head.location, tail.location) < break_bond){
        Edge newEdge = new Edge(head, tail);
        newEdges.add(newEdge);
        edgeCatalog[e.head_ID][e.tail_ID] = true;
        edgeCatalog[e.tail_ID][e.head_ID] = true;      
      }
    }
    //if there's not already an edge for a pair of nodes within the make_bond distance, make one in new_edges
    for (int i = 0; i < nodes.size() ; i++){
      for (int j = i; j < nodes.size() ; j++){
        if ( j != i ){
          if(edgeCatalog[i][j] != true){
            Node n1 = nodes.get(i);
            Node n2 = nodes.get(j);
            if (PVector.dist(n1.location, n2.location) <= make_bond) {
              Edge e = new Edge(n1, n2);
              newEdges.add(e);
            }
          }
        }
      }
    }
    edges=newEdges;
  }
}

void calculateForces() {
  

  for (int i = 0 ; i < nodes.size() ; i++) {
    forces[i].set(0, 0);
    Node n = nodes.get(i);
    forces[i] = n.velocity.get();
    forces[i].mult(0);
    forces[i].y -= n.location.x*100/pow(height-n.location.y,2);
    forces[i].y += (width-n.location.x)*100/pow(n.location.y,2);
    forces[i].x -= (height-n.location.y)*100/pow(width-n.location.x,2);
    forces[i].x += n.location.y*100/pow(n.location.x,2);
  }
  
  for (int i = 0 ; i < edges.size() ; i++) {
    Edge e = edges.get(i);
    //create force vectors for each node defining the edge 
    PVector _forceA = PVector.sub(e.head, e.tail);
    PVector _forceB = PVector.sub(e.tail, e.head);
    
    //calculate the magnitude of force exterted by the edge's springy properties
    float _mag = spring_constant * (spring_length - PVector.dist(e.head, e.tail));
    
    //set the magnitude of the force vectors
    _forceA.setMag(_mag);
    _forceB.setMag(_mag);
    
    //add the new forces to those in the array
    forces[e.head_ID] = PVector.add(_forceA, forces[e.head_ID]);
    forces[e.tail_ID] = PVector.add(_forceB, forces[e.tail_ID]);
  }
}


