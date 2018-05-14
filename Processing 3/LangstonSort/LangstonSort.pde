//--------------------------------------------------------------------------------------------
// LangstonSort
// a quircky sketch by Phillip David Stearns
// created 2018 with Processing 3.3.7
//
// Adapts the concept of Langston's Ant Cellular Automata to perform a process similar to PixelSorting
//
// KeyBindings:
//
// 'o' open a file - please keep it smaller than 1920x1080.
// 's' save the current frame
// 'r' randomizes ant locations
// 'g' generates random rule set
// 'p' starts/stops iteration
// 'f' resets the image
// 'v' toggles the ant visibility
//
//  GUI Notes
//
//  'O' button opens image
//  'S' button saves image
//  'RUN' starts and stops animation
//  'REC' saves a sequence of frames (hint: can be used to create animations!)
//  'RST' resets the source image
//  'GEN' creates a random set of rules
//  'RND' randomizes the location of the ants
//  'VIS' toggles visibility of the ants
//
//  'ITERATIONS' slider sets how many iterations are performed between each frame
//  '# OF ANTS' is pretty self explanatory, no?
//
//  The Radio with the RGB, HUE, SAT, etc. determins how the pixel values are determined.
//  If set to SAT, the evaluations apply to whether the saturation of pixels being evaluated against one another.
//
//  The following radios and toggles are a bit tricky to understand.
//  They set the rules that the ants follow.
//
//  1.  There are four major sections. Each contains three rows of buttons.
//      Each of these sections corresponds to the orientation of the Ant.
//      From top to bottom, these sections correspond to UP, RIGHT, DOWN, and LEFT.
//      If the ant is facing UP, the rules in the first group apply. Don't worry,
//      Understanding this in detail isn't necessary to get results. This is mostly to understand the layout.
//
//  2.  Within each group, there are essentially two sections: a matrix of 3x3 buttons with labels like CC, CW, STR
//      and two toggles with SW labels.
//      The 3x3 Matrix tells the ant which direction it should turn, based on how its current pixel compares with the one it's facing.
//      Each row sets the rules corresponding with the following evaluations from top to bottom: <, >, =
//      The SW toggles tell the ant whether to swap pixels before advancing.
//--------------------------------------------------------------------------------------------

import controlP5.*;

String evalMode;

color min;
color max;

PImage input;
PImage output;

boolean play;
boolean record;
boolean visible;
boolean simple = true; //whether there are 8 or 4 orientations, am trying to figure out how best to make this selectable later

int iterations = 10;

int maxIterations=1000;
int maxAnts=10000;

int orientations; // UP, DOWN, LEFT, RIGHT
int evaluations = 3;  // <, >, ==
int directions = 3;   // Left, Right, Straight

String recordPath;
int frameCounter;

ControlFrame controls;
color controlsBGColor = color(0);

//for the rule set
int[][] turn = new int[orientations][evaluations];
boolean[][] swap = new boolean[orientations][evaluations];

RadioButton[][] radios = new RadioButton[orientations][evaluations];
Toggle[][] toggles = new Toggle[orientations][evaluations];

int qtyAnts = 500;
ArrayList<Ant> ants = new ArrayList<Ant>();
//--------------------------------------------------------------------------------------------
void settings() {
  size(400, 400);
}
//--------------------------------------------------------------------------------------------
void setup() {
  initializeRules();
  createControlWindow();
  surface.setLocation(420, 10);
  
  play = false;
  record=false;
  visible = false;
  evalMode = new String("RGB");

  for (int i = 0; i < qtyAnts; i++) {
    ants.add(new Ant());
  }

}
//--------------------------------------------------------------------------------------------
void draw() {
  stroke(255);
  if (output != null) {
    image(output, 0, 0);
    updateAntList();
    if (play) {
      for (int j = 0; j < iterations; j++) for (Ant a : ants) a.update(output);
      if (visible) for (Ant a : ants) point(a.x, a.y);
      if (record)recordOutput();
    }
  }
}
//--------------------------------------------------------------------------------------------
void recordOutput() {
  output.save(recordPath+"_"+nf(frameCounter, 4)+".png");
  frameCounter++;
}
//--------------------------------------------------------------------------------------------
void updateAntList() {
  while (ants.size() > qtyAnts) ants.remove(ants.size()-1);
  while (ants.size() < qtyAnts) ants.add(new Ant());
}
//--------------------------------------------------------------------------------------------
PImage swapPixel(PImage _image, int _x1, int _y1, int _x2, int _y2) {
  _image.loadPixels();
  int _swap = _image.pixels[_y2*width+_x2];
  _image.pixels[_y2*width+_x2]=_image.pixels[_y1*width+_x1];
  _image.pixels[_y1*width+_x1]=_swap;
  _image.updatePixels();
  return _image;
}
//--------------------------------------------------------------------------------------------
color getPixel(PImage _image, int _x, int _y) {
  return _image.pixels[_y*width+_x];
}
//--------------------------------------------------------------------------------------------
PImage resetOutput() {
  return output=input.copy();
}
//--------------------------------------------------------------------------------------------
void randomizeAnts() {
  for (Ant a : ants) {
    a.randomize();
  }
}
//--------------------------------------------------------------------------------------------
void initializeRules() {
  
  if (simple) {
    orientations = 4;
  } else {
    orientations = 8;
  }

  turn = new int[orientations][evaluations];
  swap = new boolean[orientations][evaluations];

  radios = new RadioButton[orientations][evaluations];
  toggles = new Toggle[orientations][evaluations];
 
  generateRules();
}
//--------------------------------------------------------------------------------------------
void generateRules() {
  for (int o = 0; o < orientations; o++) {
    for (int e = 0; e < evaluations; e++) {
      turn[o][e] = int(random(directions));
      if (e<2)swap[o][e] = boolean(int(random(2)));
    }
  }
}
//--------------------------------------------------------------------------------------------
void createControlWindow() {
  int _w;
  int _h;

  if (simple) {
    _w = 300;
    _h = 550;
  } else {
    _w = 420;
    _h = 550;
  }
  
  controls = new ControlFrame(this, _w, _h, "Langston's Ant Controls");
}
