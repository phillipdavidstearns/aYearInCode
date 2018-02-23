import controlP5.*;

String evalMode;

color min;
color max;

PImage input;
PImage output;

boolean play;
boolean record;
boolean visible;
boolean simple = true; //whether there are 8 or 4 orientations

int iterations = 10;

int maxIterations=2500;
int maxAnts=25000;
int orientations; // UP, DOWN, LEFT, RIGHT
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

  if (simple) {
    orientations = 4;
  } else {
    orientations = 8;
  }

  turn = new int[orientations][evaluations];
  swap = new boolean[orientations][evaluations];

  buttons = new RadioButton[orientations][evaluations];
  toggles = new Toggle[orientations][evaluations];


  createControlWindow();

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

  if (output != null) {
    image(output, 0, 0);
    updateAntList();
    if (play) {
      for (int j = 0; j < iterations; j++) {
        for (Ant a : ants) {
          a.update(output);
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
  output.save(recordPath+"_"+nf(frameCounter, 4)+".png");
  frameCounter++;
}

void updateAntList() {
  while (ants.size() > qtyAnts) ants.remove(ants.size()-1);
  while (ants.size() < qtyAnts) ants.add(new Ant());
}

void generateRules() {
  for (int o = 0; o < orientations; o++) {
    for (int e = 0; e < evaluations; e++) {
      turn[o][e] = int(random(directions));
      if(e<2)swap[o][e] = boolean(int(random(2)));
    }
  }
}

PImage swapPixel(PImage _image, int _x1, int _y1, int _x2, int _y2) {
  _image.loadPixels();
  int _swap = _image.pixels[_y2*width+_x2];
  _image.pixels[_y2*width+_x2]=_image.pixels[_y1*width+_x1];
  _image.pixels[_y1*width+_x1]=_swap;
  _image.updatePixels();
  return _image;
}

color getPixel(PImage _image, int _x, int _y) {
  return _image.pixels[_y*width+_x];
}

PImage resetoutput() {
  return output=input.copy();
}

void randomizeAnts() {
  for (Ant a : ants) {
    a.randomize();
  }
}
void createControlWindow() {
  int _w;
  int _h;

  if (simple) {
    _w = 600;
    _h = 450;
  } else {
    _w = 600;
    _h = 900;
  }
  controls = new ControlFrame(this, _w, _h, "Langston's Ant Controls");
}