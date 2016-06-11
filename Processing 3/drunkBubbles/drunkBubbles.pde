Ball[] balls;
PImage[] diatom;
int numberDiatoms = 8;
void setup() {
  size(1920, 1080);
  balls = new Ball[100];
  for (int i = 0; i < balls.length; i++) {
    balls[i] = new Ball();
  }
  diatom = new PImage[numberDiatoms];
  for (int i = 0; i < diatom.length; i++) {
    diatom[i] = loadImage("diatom_"+nf(i+1, 3)+".png");
  }

  colorMode(RGB);
  background(0);
}

void draw() {
  fill(0, 100);
  noStroke();
  rect(0, 0, width, height);
  for (int i = 0; i < balls.length; i++) {
    balls[i].velocity.rotate(random(-.25, .25));
    balls[i].update();
    balls[i].display();
  }
  if (frameCount<=450) {
    saveFrame("output/001/#####.PNG");
  } else {
    exit();
  }
}

class Ball {
  float k = -0.005;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float size;
  int diatomIndex;
  float rotation;
  float angularVelocity;
  float angularAcceleration;

  Ball() {
    location = new PVector(random(width), random(height));
    velocity = new PVector(random(-2, 2), random(-2, 2));
    acceleration = new PVector();
    size = 25+random(250);
    diatomIndex = int(random(numberDiatoms));
    rotation = 0;
    angularVelocity = random(-PI/64,PI/64);
    angularAcceleration = 0;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void update() {
    size+=random(-2, 2);
    acceleration = new PVector(random(-.5, .5), random(-.5, .5));
    applyForce(drag());
    angularAcceleration = random(-.01,.01);
    angularVelocity += angularAcceleration; 
    rotation+=angularVelocity;
    velocity.add(acceleration);
    location.add(velocity);
    location.x=(location.x+width) % width;
    location.y=(location.y+height) % height;
    acceleration.mult(0);
  }

  PVector drag() {
    return PVector.mult(velocity, k);
  }

  void display() {

    //    stroke(255);
    //    strokeWeight(1);
    //    noFill();
    //    ellipseMode(CENTER);
    //    ellipse(location.x,location.y,size,size);
    pushMatrix();
    imageMode(CENTER);
    translate(location.x, location.y);
    rotate(rotation);
    image(diatom[diatomIndex], 0, 0, size, size);
    popMatrix();
  }
}

