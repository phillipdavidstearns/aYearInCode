class Block {

  int size;
  PImage img;
  
  //physics variables
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  PVector shift_location;
  PVector shift_velocity;
  PVector shift_acceleration;
  
  PVector displacement;
  
  float dampening;
  
  float velocity_scalar = 1;
  float acceleration_scalar = 0;
  
  float shift_velocity_scalar = 1.5;
  float shift_acceleration_scalar = 0;
  
  float maxspeed=1;
  float maxforce=.0125;
  
  //for  manipulation of pixels inside the block
  float hue;
  float saturation;
  float brightness;
  
  //constuctor requires args = size, and x, y coordinates
  Block(int _size, int _x, int _y){
    
    size=_size;
    
    location = new PVector(_x, _y);
    displacement = new PVector(_x, _y);
    //velocity = new PVector(0, 0);
    velocity = new PVector(random(-1,1), random(-1,1));
    velocity.mult(velocity_scalar);
    acceleration = new PVector(0, 0);
    //acceleration.mult(acceleration_scalar);
    
    shift_location = new PVector(_x, _y);
    shift_velocity = new PVector(random(-1,1), random(-1,1));
    shift_velocity.mult(shift_velocity_scalar);
    shift_acceleration = new PVector(random(-1,1), random(-1,1));
    shift_acceleration.mult(shift_acceleration_scalar);
    
    img = createImage(size, size, RGB);
    
    capture(pixels);
  }
  
  
  void run(int[] _pixels, ArrayList<Block> blocks){
    loadPixels();
    capture(_pixels);
    //rotateHue();
    flock(blocks); //need to create arrayList blocks
    update();
    borders();
    display();
  }
  
  void capture(int[] _pixels){
    
    for(int y = 0 ; y < size ; y++){
      for(int x = 0 ; x < size ; x++){
        int capture_x = (int(location.x) + x)%(width);
        if(x < 0 ) capture_x = capture_x + width - 1;
        int capture_y = (int(location.y) + y)%(height);
        if(y < 0 ) capture_y = capture_y + height - 1;
          img.pixels[(size*y)+x]=_pixels[capture_x + (capture_y * width)];
      }
    }
    img.updatePixels();
  }
  

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Block> blocks) {
    PVector sep = separate(blocks);   // Separation
    PVector ali = align(blocks);      // Alignment
    PVector coh = cohesion(blocks);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1);
    ali.mult(1);
    coh.mult(1);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  
  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    shift_acceleration.add(force);
  }
  
  // Method to update location
  void update() {  
    shift_velocity.add(shift_acceleration);
    shift_velocity.limit(maxspeed);
    shift_location.add(shift_velocity);
    shift_acceleration.mult(0);
    
    displacement = PVector.add(location, shift_velocity);
    
    velocity.add(acceleration);
    location.add(velocity);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, shift_location);  // A vector pointing from the location to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, shift_velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }
  // Wraparound
  void borders() {
    if (location.x < 0) location.x = width;
    if (location.y < 0) location.y = height;
    if (location.x > width) location.x = 0;
    if (location.y > height) location.y = 0;
    
    if (shift_location.x < 0) shift_location.x = width;
    if (shift_location.y < 0) shift_location.y = height;
    if (shift_location.x > width) shift_location.x = 0;
    if (shift_location.y > height) shift_location.y = 0;
    
  }

  // Separation
  // Method checks for nearby blocks and steers away
  PVector separate (ArrayList<Block> blocks) {
    float desiredseparation = size*.25;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Block other : blocks) {
      float d = PVector.dist(shift_location, other.shift_location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(shift_location, other.shift_location);
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
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(shift_velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Block> blocks) {
    float neighbordist = size*.5;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Block other : blocks) {
      float d = PVector.dist(shift_location, other.shift_location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.shift_velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, shift_velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby blocks, calculate steering vector towards that location
  PVector cohesion (ArrayList<Block> blocks) {
    float neighbordist = size*.25;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Block other : blocks) {
      float d = PVector.dist(shift_location, other.shift_location);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.shift_location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } 
    else {
      return new PVector(0, 0);
    }
  }
  

  
  void display(){
//    stroke(0);
//    noFill();
//    rect(location.x, location.y, size, size);
//    
//    stroke(#FFFFFF);
//    strokeWeight(0);
//    noFill();
//    rect(shift_location.x, shift_location.y, size, size);
    //image(img, shift_location.x, shift_location.y);
    image(img, displacement.x, displacement.y);
  }
  
  void rotateHue(){
    img.loadPixels();
    for(int i = 0 ; i < img.pixels.length ; i++){
      colorMode(HSB,360,255,255);
      hue = hue(img.pixels[i]);
      saturation = saturation(img.pixels[i]);
      brightness = brightness(img.pixels[i]);
      
      hue+=0;
      if(hue < 0){
        hue += 360;
      }
      hue %= 360; 
      
      saturation+=0;
      if(saturation < 0){
        saturation += 255;
      }
      saturation %= 256; 
      
      brightness+=0;
      if(brightness < 0){
        brightness += 255;
      }
      brightness %= 256; 
      
      img.pixels[i] = color(hue, saturation, brightness);
    }
    img.updatePixels();
  }
  
}
