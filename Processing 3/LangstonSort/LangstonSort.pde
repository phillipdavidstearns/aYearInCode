import controlP5.*;

String evalMode;

color min;
color max;

PImage input;
PImage buffer;
PImage output;

boolean play;
boolean record;
boolean visible;

int iterations = 10;
int orientations = 8; // UP, DOWN, LEFT, RIGHT
int evaluations = 3;  // <, >, ==
int directions = 3;    // Left, Right, Straight

String recordPath;
int frameCounter;

ControlFrame controls;
color controlsBGColor = color(0);

//for the rule set
int[][] turn = new int[orientations][evaluations];
boolean[][] swap = new boolean[orientations][evaluations];

RadioButton[][] buttons = new RadioButton[orientations][evaluations];
Toggle[][] toggles = new Toggle[orientations][evaluations];

int qtyAnts = 1;
ArrayList<Ant> ants = new ArrayList<Ant>();
void settings() {
  size(400, 400);
}

void setup() {

  controls = new ControlFrame(this, 600, 900, "Controls");
  surface.setLocation(420, 10);
  play = false;
  record=false;
  visible = false;

  evalMode = new String("RGB");
  
  for (int i = 0; i < qtyAnts; i++) {
    ants.add(new Ant());
  }

  generateRules();
}

void draw() {

  stroke(255);

  if (buffer != null) {
    image(buffer, 0, 0);
    updateAntList();
    if (play) {
      for (int j = 0; j < iterations; j++) {
        for (Ant a : ants) {
          a.update(buffer);
        }
      }
      if (visible) {
        for (Ant a : ants) {
          point(a.x, a.y);
        }
      }
      if (record) {
        recordOutput();
      }
    }
  }
}

void recordOutput() {
  buffer.save(recordPath+"_"+nf(frameCounter, 4)+".png");
  frameCounter++;
}

void updateAntList() {
  while (ants.size() > qtyAnts) ants.remove(ants.size()-1);
  while (ants.size() < qtyAnts) ants.add(new Ant());
}

void generateRules() {
  for (int i = 0; i < orientations; i++) {
    for (int j = 0; j < evaluations; j++) {
      turn[i][j] = int(random(directions));
      swap[i][j] = boolean(int(random(2)));
    }
  }
}

PImage swapPixel(PImage _image, int _x1, int _y1, int _x2, int _y2) {
  int _swap = _image.pixels[_y2*width+_x2];
  _image.pixels[_y2*width+_x2]=_image.pixels[_y1*width+_x1];
  _image.pixels[_y1*width+_x1]=_swap;
  return _image;
}

color getPixel(PImage _image, int _x, int _y) {
  return _image.pixels[_y*width+_x];
}

PImage resetBuffer() {
  return buffer=input.copy();
}

void randomizeAnts() {
  for (Ant a : ants) {
    a.randomize();
  }
}