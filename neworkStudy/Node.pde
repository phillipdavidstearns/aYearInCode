class Node {
  
  float s = 1; //spring constant
  float k = 0.25; //friction coeff
  float g = 1;
  float maxforce = 100;
  float maxspeed = 5;
  int edgeCount = 0;
  int maxconnections = 4;
  float formBond = 30;
  float breakBond = formBond * 2;
  float m, r;  
  int ID;
  PVector location, velocity, acceleration;

  Node(float _x, float _y, float _m, float _r, int _ID) {
    location.x = _x;
    location.y = _y;
    m = _m;
    r = _r;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  Node(PVector _location, float _m, float _r, int _ID) {
    location = _location;
    m = _m;
    r = _r;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }
  
  Node(float _x, float _y, int _ID) {
    location = new PVector(0, 0);
    location.x = _x ;
    location.y = _y ;
    m = 50;
    r = 5;
    ID= _ID;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  Node(int _ID) {
    ID = _ID;
    
    location = new PVector(random(width), random(height));
    m = 50;
    r = 1;
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0);
  }

  void run(ArrayList<Node> _nodes) {
    //nodeCollision(_nodes);
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
      float dist = location.dist(n.location);
      if (dist != 0) {
        force = PVector.sub(n.location, location);
        force.setMag(g*n.m/(pow(location.dist(n.location), 2)));
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
    
    _force.limit(maxforce);
    _force.div(m);
    acceleration.add(_force);
  }

  // Method to update location
  void update() {  
    velocity.add(acceleration);
    //velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display() {  

    stroke(0);
    strokeWeight(1);
    noFill();
    ellipse(location.x, location.y, 2*r, 2*r);

  }

  void boundaryCollision() {
    if (location.x < 0  + r ) {
      velocity.x *= -1;
      location.x = + r;
    }
    if (location.x > width - r) {
      velocity.x *= -1;
      location.x = width-r;
    }
    if (location.y < 0 + r ) {
      velocity.y *= -1;
      location.y = + r;
    }
    if (location.y > height - r) {
      velocity.y *= -1;
      location.y = height-r;
    }
  }
  
  void boundaryWrap() {
    if (location.x < 0) {
      
      location.x = width + location.x;
    }
    if (location.x > width) {
      
      location.x %= width;
    }
    if (location.y < 0) {
      
      location.y = height + location.y;
    }
    if (location.y > height) {
      
      location.y %= height;
    }
  }

}

