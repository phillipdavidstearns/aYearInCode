PVector origin;
int points = 100;
int x_radius = 2000;
int y_radius = 2000;
int x_shift = 0;
int y_shift = 250;
PImage output;
void setup(){
  size(1000,1000);
  output = createImage(6114, 6114, RGB);
  origin = new PVector(width/2, -250);
  noLoop();
  noSmooth();
}

void draw(){
  background(255);
  
  stroke(0);
  strokeWeight(0);
  for(int i = 0 ; i < points ; i++){
    float x = x_shift + origin.x + x_radius * sin(2*PI*i/(points-1));
    float y = y_shift + origin.y + y_radius * cos(2*PI*i/(points-1));
    line(origin.x , origin.y, x, y);
  }
}

void keyPressed(){
  switch(key){
    case '-':
    points--;
    println("lines: " + points);
    break;
    case '=':
    points++;
    println("lines: " + points);
    break;
  }
  redraw();
  
}