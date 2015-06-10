//cleaning up Block class

float cohesion_coef = block_size*2;
float separate_coef = block_size*2;
float align_coef = block_size*2;

class Block {

  PVector location;
  PVector velocity;
  PVector acceleration;

  float maxspeed=1.5;
  float maxforce=.25;

  float hue;
  float saturation;
  float brightness;

  //constuctor requires args = size, and x, y coordinates
  Block(int _x, int _y) {
    location = new PVector(_x, _y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  void run( ArrayList<Block> _blocks) {
    flock(_blocks);
    update();
    //    display();
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Block> blocks) {
    PVector sep = separate(blocks);   // Separation
    PVector ali = align(blocks);      // Alignment
    PVector coh = cohesion(blocks);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.25);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // Method to update location
  void update() {  
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
    borders();
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    // Scale to maximum speed
    desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  // Wraparound
  void borders() {
    if (location.x < 0) location.x = width - 1;
    if (location.y < 0) location.y = height - 1;
    if (location.x > width) location.x = 0;
    if (location.y > height) location.y = 0;
  }

  // Separation
  // Method checks for nearby blocks and steers away
  PVector separate (ArrayList<Block> blocks) {
    float desiredseparation = separate_coef;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Block other : blocks) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {

      // Implement Reynolds: Steering = Desired - Velocity
      steer.setMag(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Block> blocks) {
    float neighbordist = align_coef;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Block other : blocks) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.setMag(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby blocks, calculate steering vector towards that location
  PVector cohesion (ArrayList<Block> blocks) {
    float neighbordist = cohesion_coef;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Block other : blocks) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } else {
      return new PVector(0, 0);
    }
  }
  void display() {
    //    stroke(0);
    //    noFill();
    //    rect(location.x, location.y, size, size);
    //    
    stroke(0);
    strokeWeight(1);
    fill(255);
    rect(location.x, location.y, block_size, block_size);
  }
}

