class Point {
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector force;

  Point() {
    position = new PVector(random(-bounds, bounds), random(-bounds, bounds), random(-bounds, bounds));
    velocity = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0, 0);
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
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
  }
}

