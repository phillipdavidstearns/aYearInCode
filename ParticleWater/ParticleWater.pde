/**
 * Circle Collision with Swapping Velocities
 * by Ira Greenberg. 
 * 
 * Based on Keith Peter's Solution in
 * Foundation Actionscript Animation: Making Things Move!
 * Tweeks by Phillip Stearns for aYearInCode(); http://ayearincode.tumblr.com
 * 1/30/2015
 */
 
Ball[] balls = new Ball[50000];

void setup() {
  size(500, 500);
  for(int i = 0 ; i < balls.length ; i++){
    balls[i] = new Ball(0,0, 1);
  }
}

void draw() {
  background(0);
  noSmooth();
  for (int j = 0; j < balls.length ; j++) {
    Ball b = balls[j];
    b.update();
    b.display();
    b.checkBoundaryCollision();
    for(int i = 0 ; i < balls.length ; i++){
      if(i!=j){
        b.checkCollision(balls[i]);
      }
    }
  }
  saveFrame("output/particles_50000-####.PNG");
}




