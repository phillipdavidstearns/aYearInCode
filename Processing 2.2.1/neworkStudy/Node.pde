class Node {
  
  float s = 1; //spring constant
  float k = 0.125; //friction coeff
  float g = 1; //gravitational constant
  float maxforce = 100;
  float maxspeed = 5;
  int edgeCount = 0; // # of connections
  int maxconnections = 4;
  
/*  these aren't used yet
  float formBond = 30;
  float breakBond = formBond * 2;
*/
  
  float m, r;  
  int ID;
  PVector position, velocity, acceleration;

  Node(float _x, float _y, float _m, float _r, int _ID) {
    position.x = _x;
    position.y = _y;
    m = _m;
    r = _r;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  Node(PVector _position, float _m, float _r, int _ID) {
    position = _position;
    m = _m;
    r = _r;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }
  
  Node(float _x, float _y, int _ID) {
    position = new PVector(0, 0);
    position.x = _x ;
    position.y = _y ;
    m = 50;
    r = 5;
    ID= _ID;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  Node(int _ID) {
    ID = _ID;
    
    position = new PVector(random(width), random(height));
    m = 50;
    r = 1;
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0);
  }

  void run(ArrayList<Node> _nodes) {

//    gravity(_nodes);
    drag();
    update();
    boundaryCollision();
//    boundaryWrap();
    display();
  }

 
  void gravity(ArrayList<Node> _nodes) {
    //A = F/M1
    //F = G*M1*M2/R^2
    //therefore A = G*M2/R^2;

    PVector force = new PVector(0, 0);
    for (int i = 0; i < _nodes.size (); i++) {
      Node n = _nodes.get(i);
      float dist = position.dist(n.position);
      if (dist != 0) {
        force = PVector.sub(n.position, position);
        force.setMag(g*n.m/(pow(position.dist(n.position), 2)));
        applyForce(force);
      }
    }
  }
  
  void drag(){
    // Magnitude is coefficient * speed squared
    PVector drag = velocity.get();
    // Direction is inverse of velocity
    drag.setMag(-k*pow(velocity.mag(),2));
    applyForce(drag);
  }
  
  void applyForce(PVector _force) {
    //A = F / M
    
    //_force.limit(maxforce);
    _force.div(m);
    acceleration.add(_force);
  }

  // Method to update position
  void update() {  
    velocity.add(acceleration);
    //velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
  }

  void display() {  

    stroke(0);
    strokeWeight(1);
    noFill();
    ellipse(position.x, position.y, 2*r, 2*r);

  }

  void boundaryCollision() {
    if (position.x < 0  + r ) {
      velocity.x *= -1;
      position.x = + r;
    }
    if (position.x > width - r) {
      velocity.x *= -1;
      position.x = width-r;
    }
    if (position.y < 0 + r ) {
      velocity.y *= -1;
      position.y = + r;
    }
    if (position.y > height - r) {
      velocity.y *= -1;
      position.y = height-r;
    }
  }
  
  void boundaryWrap() {
    if (position.x < 0) {
      
      position.x = width + position.x;
    }
    if (position.x > width) {
      
      position.x %= width;
    }
    if (position.y < 0) {
      
      position.y = height + position.y;
    }
    if (position.y > height) {
      
      position.y %= height;
    }
  }

}
