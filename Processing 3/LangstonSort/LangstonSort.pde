
import controlP5.*;
RadioButton[][] buttons = new RadioButton[8][3];

PImage input;
PImage buffer;
PImage output;

boolean play;
boolean visible;

int iterations = 100;

int[][] turn = new int[8][3];
boolean[][] swap = new boolean[8][3];

ControlFrame controls;


Ant[] ants = new Ant[5000];

void settings() {
  size(400, 400);
}

void setup() {
  
  controls = new ControlFrame(this, 400, 1200, "Controls");
  surface.setLocation(420, 10);
  play = false;
  visible = false;
  for (int i = 0; i < ants.length; i++) {
    ants[i] = new Ant();
  }
  generateRules();
}

void draw() {

  stroke(255);
  if (buffer != null) {
    image(buffer, 0, 0);
    for (int j = 0; j < iterations; j++) {
      for (int i = 0; i < ants.length; i++) {
        ants[i].update(buffer);
        if(visible)point(ants[i].x, ants[i].y);
      }
    }
  }
}


void generateRules() {
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 3; j++) {
      turn[i][j] = int(random(3));
      swap[i][j] = boolean(int(random(2)));
    }
    println();
  }
}

PImage swapPixel(PImage _src, int _x1, int _y1, int _x2, int _y2) {
  int _next = _src.pixels[_y2*width+_x2];
  int _current = _src.pixels[_y1*width+_x1];
  _src.pixels[_y2*width+_x2]=_current;
  _src.pixels[_y1*width+_x1]=_next;
  return _src;
}

color getPixel(PImage _src, int _x, int _y) {
  return _src.pixels[_y*width+_x];
}