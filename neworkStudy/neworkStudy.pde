PVector gravity = new PVector(0, 1);

int[][] edgeCatalog;

ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Edge> edges = new ArrayList<Edge>();

ArrayList<PVector> NodesToAdd = new ArrayList<PVector>();
ArrayList<PVector> NodesToRemove = new ArrayList<PVector>();

PVector[] forces;

int qtyNodes = 00;

float make_bond = 150;
float break_bond = 200;
float spring_length = 125;
float spring_constant = 1;
float dampening = -.125;

void setup() {
  size(500,500);
  
  for (int i = 0; i < qtyNodes; i++) {
    nodes.add(new Node(i));
  }
  
  forces = new PVector[qtyNodes];
  edgeCatalog = new int[qtyNodes][qtyNodes];
  
  for(int a = 0; a < qtyNodes ; a++){
    forces[a]= new PVector(0,0);
    for(int b = 0; b < qtyNodes ; b++){
      edgeCatalog[a][b]=0;
    }
  }
  
  frameRate(30);
}

void draw() {
  background(255);
  
  for(int i = 0; i < NodesToAdd.size(); i++){
    addNode(NodesToAdd.get(i));
  }
  NodesToAdd.clear();
  
  for(int i = 0; i < NodesToRemove.size(); i++){
    removeNode(NodesToRemove.get(i));
  }
  NodesToRemove.clear();
  
  updateEdges();
  calculateForces();
  
  for(int i = 0; i < forces.length-1 ; i++){
    nodes.get(i).applyForce(forces[i]);
  }
  
  for(int i = 0; i < nodes.size() ; i++){
    nodes.get(i).run(nodes);
  }
  
  for(int i = 0; i < edges.size() ; i++){
    edges.get(i).display();
  }
  
  if(frameCount >= 1000 && frameCount <= 1149){  
//   saveFrame("output/2015_03_16/002/2015_03_16_002_networkFun-####.PNG");
  }
  if(frameCount >= 100){
//    exit();
  }
}

void keyPressed(){
}

void mousePressed(){
  
//    PVector click = new PVector(mouseX, mouseY);
//    
//    for(int i = 0 ; i < nodes.size() ; i++){
//      PVector force = PVector.sub(nodes.get(i).location, click);
//      force.setMag(100000/pow(PVector.dist(nodes.get(i).location, click),2));
//      nodes.get(i).applyForce(force);
//    }
  
  
  PVector clickLocation = new PVector(mouseX,mouseY);
  
  if(mouseButton == LEFT){
    NodesToAdd.add(clickLocation);
  }
  if(mouseButton == RIGHT){
    NodesToRemove.add(clickLocation);
  }
  
}

void addNode(PVector _location){
    Node n = new Node( _location.x, _location.y, nodes.size());
    nodes.add(n);
}

void removeNode(PVector _location){
  for(int i = nodes.size()-1 ; i >=0 ; i--){
      Node n = nodes.get(i);
      if(PVector.dist(_location, n.location) <= n.r){  
        for(int k = 0 ; k < edges.size() ; k++){
          Edge e = edges.get(k);
          if(e.tail_ID == n.ID || e.head_ID == n.ID){
            edges.remove(k); 
            nodes.get(e.head_ID).edgeCount--;
            nodes.get(e.tail_ID).edgeCount--;
          }
        }
        nodes.remove(i);
        break;
      }
    }
}


void updateEdges(){
  
  edgeCatalog = new int[nodes.size()+1][nodes.size()+1];
  
  for(int a = 0; a < nodes.size()+1 ; a++){
    for(int b = 0; b <nodes.size()+1 ; b++){
      edgeCatalog[a][b]=0;
    }
  }
  //the creates initial bonds if none exist
  if(edges.size() == 0){
    for (int i = 0; i < nodes.size() ; i++){
      Node n1 = nodes.get(i);
      for (int j = i; j < nodes.size() ; j++){
        Node n2 = nodes.get(j);
        if ( j != i ){
          if (PVector.dist(n1.location, n2.location) <= make_bond && n1.edgeCount < n1.maxconnections && n2.edgeCount < n2.maxconnections) {
            Edge e = new Edge(n1, n2);
            edges.add(e);
            edgeCatalog[n1.ID][n2.ID]++;
            edgeCatalog[n2.ID][n1.ID]++;
            n1.edgeCount++;
            n2.edgeCount++;
          }
        }
      }
    }
  } else {
    //update existing bonds
    for(int k = 0 ; k < edges.size() ; k++){
      Edge e = edges.get(k);
      //count existing valid edges and remove invalid ones
      if(PVector.dist(e.head, e.tail) < break_bond){
        edgeCatalog[e.head_ID][e.tail_ID]++;     
      } else if(PVector.dist(e.head, e.tail) >= break_bond){
        edges.remove(k); 
        edgeCatalog[e.head_ID][e.tail_ID]--;
        edgeCatalog[e.tail_ID][e.head_ID]--;
        nodes.get(e.head_ID).edgeCount--;
        nodes.get(e.tail_ID).edgeCount--;
      }
    }
    //if there's not already an edge for a pair of nodes within the make_bond distance, make one
    for (int i = 0; i < nodes.size() ; i++){
      for (int j = i; j < nodes.size() ; j++){
        if ( j != i ){
          if(edgeCatalog[i][j] == 0){
            Node n1 = nodes.get(i);
            Node n2 = nodes.get(j);
            if (PVector.dist(n1.location, n2.location) <= make_bond && n1.edgeCount < n1.maxconnections && n2.edgeCount < n2.maxconnections) {
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
}

void calculateForces() {
  forces = new PVector[nodes.size()+1];
  
  for(int a = 0; a < forces.length ; a++){
    forces[a]= new PVector(0,0);
  }
  
  Node n;
  
  for (int i = 0 ; i < edges.size() ; i++) {
    PVector temp_force = new PVector(0,0);
    
    Edge e = edges.get(i);
    Node n1 = nodes.get(e.head_ID);
    Node n2 = nodes.get(e.tail_ID);
    
    
    //create force vectors for each node defining the edge 
    PVector _forceA = PVector.sub(e.head, e.tail);
    PVector _forceB = PVector.sub(e.tail, e.head);
    
    //calculate the magnitude of force exterted by the edge's springy properties
    float _mag = spring_constant * (spring_length - PVector.dist(e.head, e.tail));
    
    _forceA.setMag(_mag);
    _forceB.setMag(_mag);
    
    forces[e.head_ID].add(_forceA);
    forces[e.tail_ID].add(_forceB);
    
    //calculates the projection of velocity onto the vector describing the edge
    //used to calculate and apply dampening force for the edge
    float theta = 0; 
    
    theta = _forceA.heading() - n1.velocity.heading();
    temp_force = _forceA.get();
    temp_force.setMag(n1.velocity.mag()*cos(theta));
    temp_force.mult(dampening);
    forces[n1.ID].add(temp_force);
    
    theta = _forceB.heading() - n2.velocity.heading();
    temp_force = _forceB.get();
    temp_force.setMag(n2.velocity.mag()*cos(theta));
    temp_force.mult(dampening);
    forces[n2.ID].add(temp_force);
    
    
  }
}


