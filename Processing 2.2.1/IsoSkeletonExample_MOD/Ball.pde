class Ball {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float radius;
  float hue;

  Ball() {
    position = new PVector(random(-bounds, bounds), random(-bounds, bounds), -bounds);
    velocity = new PVector(0, 0, random(5));
    acceleration = new PVector(0, 0, 0);
    radius = random(5)+1;
    hue = random(256);
  }

  Ball(PVector _position) {
    position = new PVector(_position.x, _position.y, _position.z);
    velocity = new PVector(0, 0, 1);
    acceleration = new PVector(0, 0, 0);
  }


  void update() {
    if (position.z > bounds) {
      position.z = -bounds;
      velocity = new PVector(0, 0, random(5));
    }
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
  }

  void render() {
    colorMode(HSB, 256, 256, 256);
    noStroke();
    fill(hue, 0, 255, 128);
    pushMatrix();
    translate(position.x, position.y, position.z);
    sphereDetail(8);
    sphere(radius);
    popMatrix();
  }
}

