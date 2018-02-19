import controlP5.*;

PImage input;
PImage output;

boolean play;
boolean record;
boolean wrap;

String recordPath;

color min = color(110);
color max = color(190);

String compareMode = new String();
String thresholdMode = new String();

Toggle[][] neighborToggles = new Toggle[3][3];

boolean[][] rules = new boolean[3][3];

ControlFrame controls;

void settings() {
  size(400, 400);
}

void setup() {
  controls = new ControlFrame(this, 1200, 400, "Controls");

  surface.setLocation(0, 0);
  play = false;
  record = false;
  initRules();
}


void draw() {
  if (output != null) {
    image(output, 0, 0);
    ruleToggles();
    cellSort(output);
  }
}


PImage cellSort(PImage _image) {

  Pixel current ;
  Pixel neighbor;
  Pixel swap;

  for (int y = 0; y < _image.height; y++) {
    for (int x = 0; x < _image.width; x++) {

      current = new Pixel(x, y, _image.pixels[y*_image.width+x]);
      neighbor = current;
      swap = current;

      boolean change = false;

      for (int x2 = 0; x2 < 3; x2 ++) {
        for (int y2 = 0; y2 < 3; y2 ++) {

          int xn = x + (x2-1);
          int yn = y + (y2-1);

          if (wrap) {
            xn = (xn + _image.width) % _image.width;
            yn = (yn + _image.height) % _image.height;
          }

          if ( /*(x2!=1 && y2!=1) &&*/ rules[x2][y2]) {

            if ( isInBounds(_image, xn, yn) ) {

              neighbor = new Pixel(xn, yn, _image.pixels[yn*_image.width+xn]);
              if (threshold(current, min, max, thresholdMode)) {
                if (compare(current, neighbor, compareMode)) {
                  if (compare(swap, neighbor, compareMode)) {
                    swap = neighbor;
                    change=true;
                  }
                }
              }
            }
          }
        }
      }
      if (change) swapPixels(_image, current, swap);
    }
  }
  _image.updatePixels();
  return _image;
}

boolean isInBounds(PImage _image, int _x, int _y) {
  return _x < _image.width && _x >= 0 && _y < _image.height && _y >= 0;
}

boolean threshold(Pixel _px, int _min, int _max, String _mode) {
  switch(_mode) {
  case "RGB": //pixel value is 
    return _px.isGreater(_min) && !_px.isGreater(_max);
  case "!RGB":
    return  !(_px.isGreater(_min) && !_px.isGreater(_max));
  case "HUE":
    return _px.hIsGreater(_min) && !_px.hIsGreater(_max);
  case "!HUE":
    return !(_px.hIsGreater(_min) && !_px.hIsGreater(_max));
  case "SAT":
    return _px.sIsGreater(_min) && !_px.sIsGreater(_max);
  case "!SAT":
    return !(_px.sIsGreater(_min) && !_px.sIsGreater(_max));
  case "VAL":
    return _px.vIsGreater(_min) && !_px.vIsGreater(_max);
  case "!VAL":
    return !(_px.vIsGreater(_min) && !_px.vIsGreater(_max));
  case "RED":
    return _px.rIsGreater(_min) && !_px.rIsGreater(_max);
  case "!RED":
    return !(_px.rIsGreater(_min) && !_px.rIsGreater(_max));
  case "GRN":
    return _px.gIsGreater(_min) && !_px.gIsGreater(_max);
  case "!GRN":
    return !(_px.gIsGreater(_min) && !_px.gIsGreater(_max));
  case "BLU":
    return _px.bIsGreater(_min) && !_px.bIsGreater(_max);
  case "!BLU":
    return !(_px.bIsGreater(_min) && !_px.bIsGreater(_max));
  default:
    return false;
  }
}

boolean compare(Pixel _px1, Pixel _px2, String _mode) {
  switch(_mode) {
  case "RGB<":
    return !(_px1.isGreater(_px2));
  case "RGB>":
    return _px1.isGreater(_px2);
  case "HUE<":
    return !(_px1.hIsGreater(_px2));
  case "HUE>":
    return _px1.hIsGreater(_px2);
  case "SAT<":
    return !(_px1.sIsGreater(_px2));
  case "SAT>":
    return _px1.sIsGreater(_px2);
  case "VAL<":
    return !(_px1.vIsGreater(_px2));
  case "VAL>":
    return _px1.vIsGreater(_px2);
  case "RED<":
    return !(_px1.rIsGreater(_px2));
  case "RED>":
    return _px1.rIsGreater(_px2);
  case "GRN<":
    return !(_px1.gIsGreater(_px2));
  case "GRN>":
    return _px1.gIsGreater(_px2);
  case "BLU<":
    return !(_px1.bIsGreater(_px2));
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
  return output=input.copy();
}