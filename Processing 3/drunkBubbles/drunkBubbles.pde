Ball[] balls;

void setup(){
  size(640,640);
  balls = new Ball[50];
  for(int i = 0 ; i < balls.length ; i++){
    balls[i] = new Ball();
  }
  colorMode(RGB);
  background(0);
}

void draw(){
  fill(0, 3);
  noStroke();
  blendMode(MULTIPLY);
  rect(0, 0, width, height);
  for(int i = 0 ; i < balls.length ; i++){
  balls[i].velocity.rotate(random(-.25,.25));
  balls[i].update();
  balls[i].display();
  }
  if(frameCount<=450){
     saveFrame("output/001/#####.PNG");
  } else {
    exit();
  }
}

class Ball{
  float k = -0.005;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float size;
  
  Ball(){
    location = new PVector(random(width),random(height));
    velocity = new PVector(random(-2,2),random(-2,2));
    acceleration = new PVector();
    size = 10;
  }
  
  void applyForce(PVector force){
    acceleration.add(force);
  }
  
  void update(){
    size+=random(-2,2);
    acceleration = new PVector(random(-.3,.3),random(-.3,.3));
    applyForce(drag());
    velocity.add(acceleration);
    location.add(velocity);
    location.x=(location.x+width) % width;
    location.y=(location.y+height) % height;
    acceleration.mult(0);
  }
  
  PVector drag(){
    return PVector.mult(velocity, k);
  }
  
  void display(){
    blendMode(LIGHTEST);
    stroke(255);
    strokeWeight(1);
    noFill();
    ellipseMode(CENTER);
    ellipse(location.x,location.y,size,size);
  }
}