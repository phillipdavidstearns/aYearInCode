import controlP5.*;

//input and output image objects
PImage input;
PImage output;

//sortlogic controls
boolean play;
boolean record;
boolean wrap;
boolean pixelCheck; //used for checking either the current or neighbor pixel against the threshold

//sort logic selectors
String compareMode = new String();
String thresholdMode = new String();

String recordPath; //string that holds the save path and filename for recorded fram sequences

int iterations = 1; // how many times the sort is run before the window is updated.
long iterationCount = 0;
color min = color(random(256), random(256), random(256));
color max = color(random(256), random(256), random(256));

Toggle[][] neighborToggles = new Toggle[3][3]; //holds GUI cp5 Toggle objects for cell logic

boolean[][] rules = new boolean[3][3]; //used to enable checking current cell against specific neighbor cells

//GUI WINDOW
ControlFrame controls;

void settings() {
  size(400, 400);
}

void setup() {

  controls = new ControlFrame(this, 1100, 400, "Controls"); //initializes the GUI window
  surface.setLocation(0, 0);

  play = false;
  record = false;
  wrap = false;
  pixelCheck = true;

  initRules();
}


void draw() {

  if (output != null) {
    image(output, 0, 0);
    if (play) {
      ruleToggles();
      for (int i = 0; i < iterations; i++) {
        cellSort(output);
      }
    }
  }
}


PImage cellSort(PImage _image) {
  boolean finished = true;
  Pixel current ;
  Pixel neighbor;
  Pixel swap;

  for (int x = 0; x < _image.width; x++) {
    for (int y = 0; y < _image.height; y++) {

      current = new Pixel(x, y, _image.pixels[y*_image.width+x]);
      neighbor = current;
      swap = current;

      boolean change = false;
      if (threshold(current, min, max, thresholdMode)) {
        
        for (int x2 = 0; x2 < 3; x2 ++) {
          for (int y2 = 0; y2 < 3; y2 ++) {


            if (rules[x2][y2]) {

              int xn = x + (x2-1);
              int yn = y + (y2-1);

              if (wrap) {
                xn = (xn + _image.width) % _image.width;
                yn = (yn + _image.height) % _image.height;
              }


              if ( isInBounds(_image, xn, yn) ) {

                neighbor = new Pixel(xn, yn, _image.pixels[yn*_image.width+xn]);

                if (compare(current, neighbor, compareMode) && threshold(neighbor, min, max, thresholdMode)) {
                  if (compare(swap, neighbor, compareMode)) {
                    swap = neighbor;
                    change=true;  
                  }
                }
              }
            }
          }
        }
        if (change){
          finished = false;
          swapPixels(_image, current, swap);
        }
      }
    }
  }
  
  if(finished){
    controls.playToggle(false);
    controls.recordToggle(false);
    println("Sorting Complete! "+iterationCount);
    _image.updatePixels();
    return _image;
  }
  
  iterationCount++;
  _image.updatePixels();
  return _image;
}

boolean isInBounds(PImage _image, int _x, int _y) {
  return _x < _image.width && _x >= 0 && _y < _image.height && _y >= 0;
}

boolean threshold(Pixel _px, color _min, color _max, String _mode) {
  switch(_mode) {
  case "<RGB>": //RGB pixel value is > min and < max
    return _px.isGreater(_min) && !_px.isGreater(_max);
  case ">RGB<": //RGB pixel value is < min and > max
    return  !(_px.isGreater(_min) && !_px.isGreater(_max));
  case "<HUE>":
    return _px.hIsGreater(_min) && !_px.hIsGreater(_max);
  case ">HUE<":
    return !(_px.hIsGreater(_min) && !_px.hIsGreater(_max));
  case "<SAT>":
    return _px.sIsGreater(_min) && !_px.sIsGreater(_max);
  case ">SAT<":
    return !(_px.sIsGreater(_min) && !_px.sIsGreater(_max));
  case "<VAL>":
    return _px.vIsGreater(_min) && !_px.vIsGreater(_max);
  case ">VAL<":
    return !(_px.vIsGreater(_min) && !_px.vIsGreater(_max));
  case "<RED>":
    return _px.rIsGreater(_min) && !_px.rIsGreater(_max);
  case ">RED<":
    return !(_px.rIsGreater(_min) && !_px.rIsGreater(_max));
  case "<GRN>":
    return _px.gIsGreater(_min) && !_px.gIsGreater(_max);
  case ">GRN<":
    return !(_px.gIsGreater(_min) && !_px.gIsGreater(_max));
  case "<BLU>":
    return _px.bIsGreater(_min) && !_px.bIsGreater(_max);
  case ">BLU<":
    return !(_px.bIsGreater(_min) && !_px.bIsGreater(_max));
  default:
    return false;
  }
}

boolean compare(Pixel _px1, Pixel _px2, String _mode) {
  switch(_mode) {
  case "RGB<":
    return _px2.isGreater(_px1);
  case "RGB>":
    return _px1.isGreater(_px2);
  case "HUE<":
    return _px2.hIsGreater(_px1);
  case "HUE>":
    return _px1.hIsGreater(_px2);
  case "SAT<":
    return _px2.sIsGreater(_px1);
  case "SAT>":
    return _px1.sIsGreater(_px2);
  case "VAL<":
    return _px2.vIsGreater(_px1);
  case "VAL>":
    return _px1.vIsGreater(_px2);
  case "RED<":
    return _px2.rIsGreater(_px1);
  case "RED>":
    return _px1.rIsGreater(_px2);
  case "GRN<":
    return _px2.gIsGreater(_px1);
  case "GRN>":
    return _px1.gIsGreater(_px2);
  case "BLU<":
    return _px2.bIsGreater(_px1);
  case "BLU>":
    return _px1.bIsGreater(_px2);
  default:
    return false;
  }
}

PImage swapPixels(PImage _image, Pixel _px1, Pixel _px2) {
  _image.pixels[_px1.y*_image.width+_px1.x] = _px2.c;
  _image.pixels[_px2.y*_image.width+_px2.x] = _px1.c;
  return _image;
}

void initRules() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      rules[i][j]=false;
    }
  }
}

void ruleToggles() {
  for (int x = 0; x < 3; x++) {
    for (int y = 0; y < 3; y++) {
      if (!(x==1 && y==1)) rules[x][y] = neighborToggles[x][y].getState();
    }
  }
}

PImage resetOutput() {
  iterationCount=0;
  return output=input.copy();
}