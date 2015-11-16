Point[] points;
void setup(){
  points = new Point[int(1250)];
  for(int i = 0 ; i < points.length ; i++){
    points[i] = new Point(i/points.length);
  }
}

void draw(){
  background(255);

  
    calculateForces();
 
  for(int i = 0 ; i < points.length ; i++){
    points[i].update();
    points[i].display();
  }  
}

void calculateForces(){
  for(int i = 0 ; i < points.length ; i++){
    for(int j = i + 1 ; j < points.length ; j++){
        //the force experienced by point i = density / distance between points i and j squared
        PVector forcei = PVector.sub(points[i].position, points[j].position);
        forcei.setMag(points[i].density/pow(PVector.dist(points[i].position, points[j].position),2));
        forcei.limit(.1);
        PVector forcej = PVector.sub(points[j].position, points[i].position);
        forcei.setMag(points[j].density/pow(PVector.dist(points[j].position, points[i].position),2));
        forcej.limit(.1);
        points[i].applyForce(forcei);
        points[j].applyForce(forcej);
    }
  }
}

class Point {

  //fields

  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;
  float density;
  float k = .0125;


  // constructors

  Point() {
    position = new PVector(random(width), random(height));
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0);
    mass = 1;
    density = .01;
  }
  
  Point(float _d) {
    position = new PVector(random(width), random(height));
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0);
    mass = 1;
    density = _d;
  }
  
  Point(float _m, float _d) {
    position = new PVector(random(width), random(height));
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0);
    mass = _m;
    density = _d;
  }
  

//  Point(float _px, float _py) {
//    position = new PVector(_px, _py);
//    velocity = new PVector(random(-1, 1), random(-1, 1));
//    acceleration = new PVector(0, 0);
//    mass = 1;
//    density = 1;
//  }

  //methods

  void applyForce(PVector force) {
    acceleration.add(PVector.div(force, mass));
  }
  
  void update(){
    
//    PVector gravity = new PVector(0,.1);
//    this.applyForce(PVector.mult(gravity,mass));

    PVector drag = velocity.get();
    drag.setMag(pow(drag.mag(),2));
    drag.mult(-k);
    this.applyForce(drag);
    velocity.add(acceleration);
    position.add(velocity);
//    position.x = int(position.x);
//    position.y = int(position.y);
    acceleration.mult(0);
    
    inBounds();
    
  }
  
  void display(){
    stroke(0);
    fill(0);
    point(position.x, position.y);
  }
  
  boolean inBounds(){
    if(position.x > 0 && position.x < width-1 && position.y > 0 && position.y < height-1){
      return true;
    } else {
      if(position.x < 0 && velocity.x < 0){
        position.x = 0;
        velocity.x *= -1;
      }
      if(position.x  > width - 1 && velocity.x > 0){
        position.x = width - 1;
        velocity.x *= -1;
      } 
      if(position.y < 0 && velocity.y < 0){
        position.y = 0;
        velocity.y *= -1;
      }
      if (position.y  > height - 1 && velocity.y > 0){
        position.y = height - 1;
        velocity.y *= -1;
      }
      return false;
    }
  }
  
}

