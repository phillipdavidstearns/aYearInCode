class Node {
  
  //float make_bond
  //float break_bond
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector force; 

  int id;
  
  float radius;
  float mass;
  float x;
  float y;

  Node(float _x, float _y, float _mass) {
    location = new PVector(_x, _y);
    x = _x;
    y = _y;
    velocity = new PVector(0,0);
    acceleration = new PVector(0, 0);
    mass = _mass;
    radius = mass / (TWO_PI);
  }

  void update(PVector _force) {
    
    acceleration.set(PVector.div(_force,mass));
    velocity.add(acceleration);
    velocity.mult(dampening);
    location.add(velocity);
    x=location.x;
    y=location.y;
  }

  void display() {
    stroke(0);
    strokeWeight(0);  
    fill(pow(velocity.mag(),2) * mass * 10, 30); 
    ellipse(location.x, location.y, radius/2, radius/2);
  }
}
