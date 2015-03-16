PVector gravity = new PVector(0, 1);
int[][] edgeCatalog;
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Edge> edges = new ArrayList<Edge>();

ArrayList<PVector> NodesToAdd = new ArrayList<PVector>();
ArrayList<PVector> NodesToRemove = new ArrayList<PVector>();

PVector[] forces;


int qtyNodes = 0;

float make_bond = 25;
float break_bond = 30;
float spring_length = 25;
float spring_constant = 1.5;
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
//    saveFrame("output/2015_03_16/002/2015_03_16_002_networkFun-####.PNG");
  }
  if(frameCount >= 1149){
//    exit();
  }
//  println("edges: " + edges.size());
//  println("nodes: "+ nodes.size());
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

void mousePressed(){
//  PVector click = new PVector(mouseX, mouseY);
//  
//  for(int i = 0 ; i < nodes.size() ; i++){
//    PVector force = PVector.sub(nodes.get(i).location, click);
//    force.setMag(100000/pow(PVector.dist(nodes.get(i).location, click),2));
//    nodes.get(i).applyForce(force);
//  }
  
  
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
    println("Adding node " + n.ID);
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
//    println("No Edges Found. Generating Initial Edges...");
    for (int i = 0; i < nodes.size() ; i++){
      Node n1 = nodes.get(i);
      for (int j = i; j < nodes.size() ; j++){
        Node n2 = nodes.get(j);
        if ( j != i ){
          if (PVector.dist(n1.location, n2.location) <= make_bond) {
//            println("...Creating between node " + n1.ID + " and node " + n2.ID );
            Edge e = new Edge(n1, n2);
            edges.add(e);
            edgeCatalog[n1.ID][n2.ID]++;
            n1.edgeCount++;
            n2.edgeCount++;
          }
        }
      }
    }
  } else {
    //update existing bonds and add to new_edges, bonds greater than the breaking length are left behind
    for(int k = 0 ; k < edges.size() ; k++){
//      println("Edges Found. Updating existing edges...");
      Edge e = edges.get(k);
//      Node head = nodes.get(e.head_ID);
//      Node tail = nodes.get(e.tail_ID);
      if(PVector.dist(e.head, e.tail) < break_bond){
//        println("edge between node " + e.head_ID + " and node " + e.tail_ID + " updated.");
        edgeCatalog[e.head_ID][e.tail_ID]++;     
      } else if(PVector.dist(e.head, e.tail) >= break_bond){
//        println("edge between node " + e.head_ID + " and node " + e.tail_ID + " updated.");
        edges.remove(k); 
        edgeCatalog[e.head_ID][e.tail_ID]--;
        nodes.get(e.head_ID).edgeCount--;
        nodes.get(e.tail_ID).edgeCount--;
      }
    }
    //if there's not already an edge for a pair of nodes within the make_bond distance, make one
    for (int i = 0; i < nodes.size() ; i++){
      
      for (int j = i; j < nodes.size() ; j++){
        if ( j != i ){
          
//          println("catalog index: " + i + " x " + j + " = " + edgeCatalog[i][j]);
          if(edgeCatalog[i][j] == 0){
            Node n1 = nodes.get(i);
            Node n2 = nodes.get(j);
            if (PVector.dist(n1.location, n2.location) <= make_bond && nodes.get(j).edgeCount < nodes.get(j).maxconnections && nodes.get(i).edgeCount < nodes.get(i).maxconnections) {
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
    temp_force = n1.velocity.get();
    
    
    //create force vectors for each node defining the edge 
    PVector _forceA = PVector.sub(e.head, e.tail);
    PVector _forceB = PVector.sub(e.tail, e.head);
    
    float theta = 0; 
    
    theta = _forceA.heading() - n1.velocity.heading();
    
    temp_force = _forceA.get();
    temp_force.setMag(n1.velocity.mag()*cos(theta));
    temp_force.mult(dampening);
    forces[n1.ID].add(temp_force);
    
    theta = _forceB.heading() - n2.velocity.heading();
    
    temp_force = _forceB.get();
    temp_force.setMag(n2.velocity.mag()*sin(theta));
    temp_force.mult(dampening);
    forces[n2.ID].add(temp_force);
    
    //calculate the magnitude of force exterted by the edge's springy properties
    float _mag = spring_constant * (spring_length - PVector.dist(e.head, e.tail));
    
    //set the magnitude of the force vectors
    _forceA.setMag(_mag);
    _forceB.setMag(_mag);
    
    //add the new forces to those in the array
    forces[e.head_ID].add(_forceA);
    forces[e.tail_ID].add(_forceB);
  }
}


