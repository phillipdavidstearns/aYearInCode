class Point {
  PVector origin;
  PVector position;
  PVector direction;
  PVector velocity;
  PVector acceleration;
  float mass;
  color c;

  Point() {
    position = new PVector(random(-bounds, bounds), random(-bounds, bounds), random(-bounds, bounds));
    origin = position;
    velocity = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0, 0);
    direction = new PVector(0, 0, 0);
    mass = 1;
    c = color(random(256), random(256), random(256));
  }

  Point(PVector _position) {
    position = _position;
    origin = _position;
    velocity = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0, 0);
    direction = new PVector(0, 0, 0);
    mass = 1;
    c = color(random(256), random(256), random(256));
  }

  Point(PVector _position, PVector _velocity) {
    position = _position;
    origin = position.get();
    velocity = _velocity;
    acceleration = new PVector(0, 0, 0);
    direction = new PVector(0, 0, 0);
    mass = 1;
    c = color(random(256), random(256), random(256));
  }

  Point(PVector _position, float _mass) {
    position = _position;
    origin = position.get();
    velocity = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0, 0);
    direction = new PVector(0, 0, 0);
    mass = _mass;
    c = color(random(256), random(256), random(256));
  }

  Point(float _x, float _y, float _z, float _mass) {
    position = new PVector(_x, _y, _z);
    origin = position.get();
    velocity = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0, 0);
    direction = new PVector(0, 0, 0);
    mass = _mass;
    c = color(random(256), random(256), random(256));
  }

  Point(float _x, float _y, float _z) {
    position = new PVector(_x, _y, _z);
    origin = position.get();
    velocity = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0, 0);
    direction = new PVector(0, 0, 0);
    mass = 1;
    c = color(random(256), random(256), random(256));
  }

  Point(float _x, float _y, float _z, PVector _velocity) {
    position = new PVector(_x, _y, _z);
    origin = position.get();
    velocity = _velocity;
    acceleration = new PVector(0, 0, 0);
    direction = new PVector(0, 0, 0);
    mass = 1;
    c = color(random(256), random(256), random(256));
  }
  
  Point(float _x, float _y, float _z, PVector _velocity, color _color) {
    position = new PVector(_x, _y, _z);
    origin = position.get();
    velocity = _velocity;
    acceleration = new PVector(0, 0, 0);
    direction = new PVector(0, 0, 0);
    mass = 1;
    c = _color;
  }

  void update() {
    if (position.x > bounds || position.x < -bounds) {
      velocity.x*=-1;
    }
    if (position.y > bounds || position.y < -bounds) {
      velocity.y*=-1;
    }
    if (position.z > bounds || position.z < -bounds) {
      velocity.z*=-1;
    }


    applyForce(PVector.sub(origin,position).setMag(PVector.dist(origin,position)*.00025));
    applyForce(velocity.get().normalize().setMag(-1*velocity.mag()*.00025));

    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
  }

  void applyForce(PVector _force) {
    acceleration.add(PVector.div(_force, mass));
  }

  void render() {
    stroke(0);
    strokeWeight(1);
    point(position.x, position.y, position.z);
  }

  void render(float _strokeWeight) {
    stroke(0);
    strokeWeight(_strokeWeight);
    point(position.x, position.y, position.z);
  }
  void render(color _color, float _strokeWeight) {
    colorMode(HSB,255, 255, 255);
    stroke(_color);
    strokeWeight(_strokeWeight);
    point(position.x, position.y, position.z);
  }
  void render(color _color) {
    stroke(_color);
    strokeWeight(1);
    point(position.x, position.y, position.z);
  }
  
  void rotateColor(float _hue,float _saturation,float _brightness){
  colorMode(HSB,255, 255, 255);
  c =   color((hue(c)+_hue)%256, (saturation(c)+_saturation), (brightness(c)+_brightness));
  }

}