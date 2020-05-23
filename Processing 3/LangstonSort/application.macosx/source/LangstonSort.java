import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class LangstonSort extends PApplet {

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



String evalMode;

int min;
int max;

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
int controlsBGColor = color(0);

//for the rule set
int[][] turn = new int[orientations][evaluations];
boolean[][] swap = new boolean[orientations][evaluations];

RadioButton[][] radios = new RadioButton[orientations][evaluations];
Toggle[][] toggles = new Toggle[orientations][evaluations];

int qtyAnts = 500;
ArrayList<Ant> ants = new ArrayList<Ant>();
//--------------------------------------------------------------------------------------------
public void settings() {
  size(400, 400);
}
//--------------------------------------------------------------------------------------------
public void setup() {
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
public void draw() {
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
public void recordOutput() {
  output.save(recordPath+"_"+nf(frameCounter, 4)+".png");
  frameCounter++;
}
//--------------------------------------------------------------------------------------------
public void updateAntList() {
  while (ants.size() > qtyAnts) ants.remove(ants.size()-1);
  while (ants.size() < qtyAnts) ants.add(new Ant());
}
//--------------------------------------------------------------------------------------------
public PImage swapPixel(PImage _image, int _x1, int _y1, int _x2, int _y2) {
  _image.loadPixels();
  int _swap = _image.pixels[_y2*width+_x2];
  _image.pixels[_y2*width+_x2]=_image.pixels[_y1*width+_x1];
  _image.pixels[_y1*width+_x1]=_swap;
  _image.updatePixels();
  return _image;
}
//--------------------------------------------------------------------------------------------
public int getPixel(PImage _image, int _x, int _y) {
  return _image.pixels[_y*width+_x];
}
//--------------------------------------------------------------------------------------------
public PImage resetOutput() {
  return output=input.copy();
}
//--------------------------------------------------------------------------------------------
public void randomizeAnts() {
  for (Ant a : ants) {
    a.randomize();
  }
}
//--------------------------------------------------------------------------------------------
public void initializeRules() {
  
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
public void generateRules() {
  for (int o = 0; o < orientations; o++) {
    for (int e = 0; e < evaluations; e++) {
      turn[o][e] = PApplet.parseInt(random(directions));
      if (e<2)swap[o][e] = PApplet.parseBoolean(PApplet.parseInt(random(2)));
    }
  }
}
//--------------------------------------------------------------------------------------------
public void createControlWindow() {
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
class Ant {

  int x;
  int y;
  int orientation; // 0 = UP, 1 = RIGHT, 2 = DOWN, 3 = LEFT

  Ant (int _x, int _y, int _orientation) {
    x = _x;
    y = _y;  
    orientation = _orientation;
  }

  Ant () {
    randomize();
  }

  public void randomize() {
    x = PApplet.parseInt(random(width));
    y = PApplet.parseInt(random(height));  
    orientation = PApplet.parseInt(random(4));
  }

  public void update(PImage _image) {

    //get and store and wrap the coordinates of our next location
    int nextX = (getNextX(x) + width) % width; 
    int nextY = (getNextY(y) + height) % height;

    // retrieve and evaluate the pixels associated with our current and next location
    int eval = evaluate(evalMode, getPixel(_image, x, y), getPixel(_image, nextX, nextY) );

    //refer to the rules and swap if appropriate
    if (swap[orientation][eval]) swapPixel(_image, x, y, nextX, nextY);

    //apply the new location
    x = nextX;
    y = nextY;

    //update the orientation of the ant
    if (eval > -1 && eval < 2) {
      switch(turn[orientation][eval]) {
      case 0: // counter clockwise
        orientation--;
        break;
      case 1: // clockwise
        orientation++;
        break;
      default:
        break;
      }
      //wrap the orientation value
      orientation = (orientation + orientations) % orientations;
    }
  }

  //tells us whether the next pixel is < ,> , = the current pixel
  public int evaluate(String _mode, int _c1, int _c2) {
    switch(_mode) {
    case "RGB":
      return evaluate(_c1, _c2);
    case "HUE":
      return evaluate(hue(_c1), hue(_c2));
    case "SAT":
      return evaluate(saturation(_c1), saturation(_c2));
    case "VAL":
      return evaluate(brightness(_c1), brightness(_c2));
    case "RED":
      return evaluate(red(_c1), red(_c2));
    case "GRN":
      return evaluate(green(_c1), green(_c2));
    case "BLU":
      return evaluate(blue(_c1), blue(_c2));
    default:
      return -1;
    }
  }

  public int evaluate(int _c1, int _c2) {
    if (_c1 < _c2) {
      return 0;
    } else if (_c1 > _c2) {
      return 1;
    } else if (_c1 == _c2) {
      return 2;
    } else {
      return -1;
    }
  }

  public int evaluate(float _f1, float _f2) {
    if (_f1 < _f2) {
      return 0;
    } else if (_f1 > _f2) {
      return 1;
    } else if (_f1 == _f2) {
      return 2;
    } else {
      return -1;
    }
  }

  public int getNextX(int _x) {
    if (!simple) {
      switch(orientation) {
        //0 = UP  
      case 1: //1 = UP+RIGHT
        return _x+1;
      case 2: //2 = RIGHT
        return _x+1;
      case 3: //3 = RIGHT+DOWN
        return _x+1;
        //4= DOWN
      case 5: //5 = DOWN + LEFT
        return _x-1;
      case 6: //6 = LEFT
        return _x-1;
      case 7: //7 = LEFT + UP
        return _x-1;
      default:
        return _x;
      }
    } else {
      switch(orientation) {
        //0 = UP
      case 1: //1 =  RIGHT
        return _x+1;
        //2 =  DOWN
      case 3: //3 =  LEFT
        return _x-1;
      default:
        return _x;
      }
    }
  }


  public int getNextY(int _y) {
    if (!simple) {
      switch(orientation) {
      case 0: // UP
        return _y-1;
      case 1: // UP+RIGHT
        return _y-1;
        // 2 = // RIGHT
      case 3: // DOWN + RIGHT
        return _y+1;
      case 4: // DOWN
        return _y+1;
      case 5: // DOWN + LEFT
        return _y+1;
        // 6 = LEFT
      case 7: // UP + LEFT
        return _y-1;
      default:
        return _y;
      }
    } else {
      switch(orientation) {
      case 0: // UP
        return _y-1;
        //1 = RIGHT
      case 2:// DOWN
        return _y+1;
        //3 = LEFT
      default:
        return _y;
      }
    }
  }
}
// Opening an Image
public void openImage() {
  selectInput("Select an image to open:", "inputSelected");
}
//--------------------------------------------------------------------------------------------
public void inputSelected(File selection) {
  String path;
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    path = selection.getAbsolutePath();
    println("User selected " + path);
    loadInput(path);
  }
}
//--------------------------------------------------------------------------------------------
public void loadInput(String path) {
  input = loadImage(path);
  output=input.copy();
  surface.setSize(input.width, input.height);
  randomizeAnts();
}
//--------------------------------------------------------------------------------------------
//Saving an Image
public void saveImage() {
  selectOutput("Save to file:", "outputSelected");
}
//--------------------------------------------------------------------------------------------
public void outputSelected(File selection) {
 
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String[] temp = split(selection.getAbsolutePath(),'.');
    String path = temp[0]+".png";
    println("User selected " + path);
    saveOutput(path);
  }
}
//--------------------------------------------------------------------------------------------
public void saveOutput(String path) {
  saveFrame(path);
}
//--------------------------------------------------------------------------------------------
// Setting up a record path
public void selectRecordPath(){
  selectOutput("Save to file:", "recordPathSelected");
}
//--------------------------------------------------------------------------------------------
public void recordPathSelected(File selection) {
  if (selection == null) {
    controls.cp5.getController("recordToggle").setValue(0);
    println("Window was closed or the user hit cancel.");
  } else {
    String[] temp = split(selection.getAbsolutePath(),'.');
    String path = temp[0];
    println("User selected " + path);
    recordPath=path;
  }
}
public class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;

  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
  }

  public void setup() {
    surface.setLocation(10, 10);
    cp5 = new ControlP5(this);
    
    //positions of the basic Load, Save, Play, Etc controls
    int buttonX=10;
    int buttonY=10;
    int buttonW=20;
    int buttonH=20;
    int buttonspacing=35;
    
    //iteration and quantity sliders
    int sliderX=10;
    int sliderY=85;
    int sliderW=200;
    int sliderH=20;
    int sliderSpacing=30;
    
    //evaluation mode selector
    int modeRadioX=10;
    int modeRadioY=150;
    int modeRadioW=20;
    int modeRadioH=20;
    int modeRadioSpacing=20;

    //rule radios
    int radioColSpacing = 220;
    int radioX=10;
    int radioY=190;
    int radioW=20;
    int radioH=20;
    int radioSpacing=25;

    //swap toggles
    int toggleW=20;
    int toggleH=20;
    int toggleX=160;
    int toggleY=radioY;
    int toggleSpacing=25;

    for ( int o = 0; o < orientations; o++) {
      for (int e = 0; e < evaluations; e++) {
        int col=0;
        if (o > 3) col=1;
        String name = "o"+o+"e"+e;
        radios[o][e] = cp5.addRadioButton(name+"R")
          .setSize(radioW, radioH)
          .setItemsPerRow(3)
          .setSpacingColumn(radioSpacing)
          .setSpacingRow(radioSpacing)
          .setPosition(radioX+(col*radioColSpacing), radioY+(e*radioSpacing)+((o%4)*2*(radioH+radioSpacing)))
          .addItem("CCW"+o+e, 0)
          .addItem("CW"+o+e, 1)
          .addItem("STR"+o+e, 2)
          .activate(turn[o][e])
          ;
        if (e<2) {
          toggles[o][e] = cp5.addToggle(name+"T")
            .setLabel("SW"+o+e)
            .setSize(toggleW, toggleH)
            .setPosition(toggleX+(col*radioColSpacing), toggleY+(e*toggleSpacing)+((o%4)*2*(radioH+radioSpacing)))
            .setValue(swap[o][e])
            ;
        }
      }
    }

    cp5.addRadioButton("evalModeRadio")
      .setLabel("evalMode")
      .setSize(modeRadioW, modeRadioH)
      .setItemsPerRow(8)
      .setSpacingColumn(modeRadioSpacing)
      .setSpacingRow(modeRadioSpacing)
      .setPosition(modeRadioX, modeRadioY+(0*modeRadioSpacing)+(0*2*(modeRadioH+modeRadioSpacing)))
      .addItem("RGB", 0)
      .addItem("HUE", 1)
      .addItem("SAT", 2)
      .addItem("VAL", 3)
      .addItem("RED", 4)
      .addItem("GRN", 5)
      .addItem("BLU", 6)
      .activate(0)
      ;

    cp5.addSlider("iterationSlider")
      .setLabel("Iterations")
      .setPosition(sliderX, sliderY+(0*sliderSpacing))
      .setRange(1, maxIterations)
      .setSize(sliderW, sliderH)
      .setValue(iterations);
    ;

    cp5.addSlider("qtyAntsSlider")
      .setLabel("# of Ants")
      .setPosition(sliderX, sliderY+(1*sliderSpacing))
      .setRange(1, maxAnts)
      .setSize(sliderW, sliderH)
      .setValue(qtyAnts);
    ;


    //play controls

    cp5.addButton("open")
      .setLabel("O")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(0*buttonspacing), buttonY+(0*buttonspacing))
      ;
    cp5.addButton("save")
      .setLabel("S")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(0*buttonspacing), buttonY+(1*buttonspacing))
      ;

    cp5.addToggle("playToggle")
      .setLabel("RUN")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(1*buttonspacing), buttonY+(0*buttonspacing))
      ;
    cp5.addToggle("recordToggle")
      .setLabel("REC")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(1*buttonspacing), buttonY+(1*buttonspacing))
      ;

    cp5.addButton("reset")
      .setLabel("RST")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(2*buttonspacing), buttonY+(0*buttonspacing))
      ;

    cp5.addButton("generate")
      .setLabel("GEN")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(2*buttonspacing), buttonY+(1*buttonspacing))
      ;

    cp5.addButton("randomize")
      .setLabel("RND")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(3*buttonspacing), buttonY+(0*buttonspacing))
      ;
    cp5.addToggle("antVisibleToggle")
      .setLabel("VIS")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(3*buttonspacing), buttonY+(1*buttonspacing))
      ;
    //cp5.addToggle("simpleToggle")
    //  .setLabel("4/8")
    //  .setSize(buttonW, buttonH)
    //  .setPosition(buttonX+(4*radiospacing), buttonY+(0*radiospacing))
    //  ;
  }


  public void evalModeRadio(int _mode) {
    switch(_mode) {
    case 0: 
      evalMode = "RGB"; 
      break;
    case 1: 
      evalMode = "HUE"; 
      break;
    case 2: 
      evalMode = "SAT"; 
      break;
    case 3: 
      evalMode = "VAL"; 
      break;
    case 4: 
      evalMode = "RED"; 
      break;
    case 5: 
      evalMode = "GRN"; 
      break;
    case 6: 
      evalMode = "BLU"; 
      break;
    }
  }

  public void open() {
    cp5.getController("playToggle").setValue(0);
    openImage();
  }
  public void save() {
    cp5.getController("playToggle").setValue(0);
    saveImage();
  }

  public void playToggle(boolean _value) {
    play = _value;
  }
  public void recordToggle(boolean _value) {
    cp5.getController("playToggle").setValue(0);
    if (_value) selectRecordPath();
    record = _value;
    frameCounter=0;
  }

  public void reset() {
    if (output!=null) {
      randomizeAnts();
      resetOutput();
    }
  }
  public void generate() {
    randomizeAnts();
    generateNewRules();
  }


  public void randomize() {
    randomizeAnts();
  }

  public void antVisibleToggle(boolean _value) {
    visible = _value;
  }

  //To do: have a toggle dynamically switch between simple and complex mode, 4 and 8 directions, respectively.
  //public void simpleToggle(int _val) {
  //pseudocode:
  //destroyThisControllerFrame()
  //reinitializeRules()
  //createNewControllerFrame()
  //}

  public void draw() {
    background(controlsBGColor);
    for ( int o = 0; o < orientations; o++) {
      for (int e = 0; e < evaluations; e++) {
        turn[o][e] = PApplet.parseInt(radios[o][e].getValue());
        if (e<2) swap[o][e] = PApplet.parseBoolean(PApplet.parseInt(toggles[o][e].getValue()));
      }
    }
    iterations = PApplet.parseInt(cp5.getValue("iterationSlider"));
    qtyAnts = PApplet.parseInt(cp5.getValue("qtyAntsSlider"));
  }

  public void generateNewRules() {
    generateRules();
    //update radios and radios
    for ( int o = 0; o < orientations; o++) {
      for (int e = 0; e < evaluations; e++) {
        radios[o][e].activate(turn[o][e]);
        if (e<2) toggles[o][e].setValue(swap[o][e]);
      }
    }
  }
  
  //key bindings
  public void keyPressed() {
    switch(key) {
    case 'o': //open
      openImage();
      break;
    case 's': //save
      saveImage();
      break;
    case 'r': //randomize ant locations
      if (ants != null) randomize();
      break;
    case 'g': //generate random rule set
      controls.generateNewRules();
      break;
    case 'p':
      cp5.getController("playToggle").setValue(PApplet.parseInt(!play));
      break;
    case 'f': 
      reset();
      break;
    case 'v':
      cp5.getController("antVisibleToggle").setValue(PApplet.parseInt(!visible));
      break;
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "LangstonSort" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
