Node n1;
Node n2;

ArrayList<Edge> edges;

void setup(){
  size(500,500);
  n1 = new Node(random(width),random(height), 10, 1);
  n2 = new Node(n1.position.x+10,n1.position.y+10, 10, 2);
  edges = new ArrayList<Edge>();
  generateEdges();
  
}

void draw(){
  background(255);
  n1.run(edges);
  n2.run(edges);
  generateEdges();
  drawEdges();
}

void generateEdges(){
  float distance = n1.position.dist(n2.position);
  
  if(edges.isEmpty()){
    if(distance <=100){
      Edge e = new Edge(n1,n2);
      edges.add(e);
      println("adding edge");
    }
  }
}

void drawEdges(){
  if(!edges.isEmpty()){
    
    for(int i = 0 ; i < edges.size(); i++){
      Edge e = edges.get(i);
      e.display();
    }
  }
}


class Node{
  float m, r;
  PVector position, velocity, acceleration;
  int ID;
  
  Node(float _x, float _y, float _mass, int _ID){
    position = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    ID = _ID;
    m = _mass;
    r = 5;
  }
  
  void run(){
    update();
    display();
  }
  
  void run(ArrayList<Edge> _edges){
    edges(_edges);
    update();
    display();
  }
  
  void edges(ArrayList<Edge> _edges){
    PVector force = new PVector(0,0);
    for(int i = 0 ; i < _edges.size(); i++){
      Edge e = _edges.get(i);
      if(e.headID == ID){
        force = e.force();
      } else if(e.tailID == ID){
        force = e.force();
        force.mult(-1); 
      }
      println(force);
      applyForce(force);
    }
    
  }
  
  void applyForce(PVector _force) {
    acceleration.add(_force);
  }

  void update() {  
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
  }

  void display() {  
    stroke(0);
    strokeWeight(0);
    noFill();
    ellipse(position.x, position.y, 2*r, 2*r);
//    textSize(10);
//    text(ID, location.x+r, location.y-r);
//
//    textSize(10);
//    text(velocity.mag(), location.x+r, location.y-r);
  }
  
}

class Edge{
  PVector head, tail;
  int headID, tailID;
  float l, k;
  
  Edge(Node _n1, Node _n2){
    head = _n1.position;
    tail = _n2.position;
    headID = _n1.ID;
    headID = _n2.ID;
  }
  
  void set(Node _n1, Node _n2){
    head = _n1.position;
    tail = _n2.position;
  }
  
  void display(){
    strokeWeight(1);
    stroke(0);
    line(head.x, head.y, tail.x, tail.y);
  }
  
  PVector force(){
    
    PVector _force = new PVector(0,0);
    _force = PVector.sub(head,tail);
    println(_force);
    _force.setMag((PVector.dist(head,tail)-1) * -k);
    return _force;
  }
  
  
}
