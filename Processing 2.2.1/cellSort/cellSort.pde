PImage input;
PImage output;

int higher=110;
int lower=190;

int offset_x = 0;
int offset_y = 0;

boolean play = false;
boolean record = false;

boolean wrap = false;

int mode = 0; //sets the threshold evaluation mode
int iterations = 0;
boolean[][] rules;

int logic = 0; // 0 is <, 1 is >, 2 is ==

boolean sequence = true;
int start = 0;
int end = 0;
int speed = 1; 

String recordPath;
int frameCounter;

void loadinput() {

  image(input, 0, 0);
}

void settings() {
  size(400, 400);
}

void setup() {
  surface.setLocation(0, 0);
  rules = new boolean[3][3];
  initRules();
  //image(input, 0, 0);
}

void draw() {

  if (play) {
    output = cellSort(input);
    image(output, 0, 0);
    if (record) output.save(recordPath);
    iterations++;
  }
}

void initRules() {
  rules[0][0]=false;
  rules[0][1]=false;
  rules[0][2]=false;
  rules[1][0]=false;
  rules[1][1]=false;
  rules[1][2]=false;
  rules[2][0]=false;
  rules[2][1]=false;
  rules[2][2]=false;
}

void keyPressed() {
  switch(key) {
  case 'r':
    initRules();
    break;  
  case '1':
    rules[0][0] = !rules[0][0];
    break;
  case '2':
    rules[0][1] = !rules[0][1];
    break;
  case '3':
    rules[0][2] = !rules[0][2];
    break;
  case '4':
    rules[1][0] = !rules[1][0];
    break;
  case '5':
    rules[1][1] = !rules[1][1];
    break;
  case '6':
    rules[1][2] = !rules[1][2];
    break;
  case '7':
    rules[2][0] = !rules[2][0];
    break;
  case '8':
    rules[2][1] = !rules[2][1];
    break;
  case '9':
    rules[2][2] = !rules[2][2];
    break;
  case 'o':
    openImage();
    break;
  case '=': // up arrow
    higher++;
    println(higher);
    break;
  case '-': // down arrow
    higher--;
    println(higher);
    break;
  case '[': // up arrow
    lower--;
    println(lower);
    break;
  case ']': // down arrow
    lower++;
    println(lower);
    break;
  case 'p': // play toggles animation
    play=!play;
    break;
  case 'w': // w toggles edge wrap mode
    wrap=!wrap;
    break;
  case '!': // w toggles edge wrap mode
    mode=0;
    break;
  case '@': // w toggles edge wrap mode
    mode=1;
    break;
  case '#': // w toggles edge wrap mode
    mode=2;
    break;
  case '$': // w toggles edge wrap mode
    mode=3;
    break;
  case '%': // w toggles edge wrap mode
    mode=4;
    break;
  case '^': // w toggles edge wrap mode
    mode=5;
    break;
  case '>':
    logic++;
    logic %= 3;
    break;
  }
}


int[] swapPixels(int[] _pixelArray, int _index1, int _index2) {
  int output = _pixelArray[_index1];
  _pixelArray[_index1] = _pixelArray[_index2];
  _pixelArray[_index2] = output;
  return _pixelArray;
}



PImage cellSort(PImage _image) {
  int swap_x = 0;
  int swap_y = 0;
  int neighbor_x = 0;
  int neighbor_y = 0;
  _image.loadPixels();
  for (int y = 0; y < _image.height; y++) {
    for (int x = 0; x < _image.width; x++) {
      swap_x = x;
      swap_y = y;
      for (int ny = 0; ny < 3; ny++ ) {
        for (int nx = 0; nx < 3; nx++) {
          if (rules[nx][ny] && (nx != 1 && ny != 1)) {
            if (!wrap) {
              neighbor_x = x + (nx-1);
              neighbor_y = y + (ny-1);
            } else {
              neighbor_x = (_image.width + x + (nx-1)) % _image.width;
              neighbor_y = (_image.height + y + (ny-1)) % _image.height;
            }
            if (isInBounds(_image, neighbor_x, neighbor_y)) {
              if (evalPixels(_image, neighbor_x, neighbor_y, swap_x, swap_y, logic)) {
                switch(mode) {
                case 0: // if the pixel color is less that the lower threshold and greater thatn the 
                  if (_image.pixels[y*_image.width+x] < color(lower) && _image.pixels[y*_image.width+x] > color(higher)) {
                    swap_x = neighbor_x;
                    swap_y = neighbor_y;
                  }
                  break;
                case 1:
                  if (_image.pixels[neighbor_y*_image.width+neighbor_x] < color(lower) && _image.pixels[neighbor_y*_image.width+neighbor_x] > color(higher)) {
                    swap_x = neighbor_x;
                    swap_y = neighbor_y;
                  }
                  break;
                case 2:
                  if (_image.pixels[swap_y*_image.width+swap_x] < color(lower) && _image.pixels[swap_y*_image.width+swap_x] > color(higher)) {
                    swap_x = neighbor_x;
                    swap_y = neighbor_y;
                  }
                  break;
                case 3:
                  if (!(_image.pixels[y*_image.width+x] < color(lower) && _image.pixels[y*_image.width+x] > color(higher))) {
                    swap_x = neighbor_x;
                    swap_y = neighbor_y;
                  }
                  break;
                case 4:
                  if (!(_image.pixels[neighbor_y*_image.width+neighbor_x] < color(lower) && _image.pixels[neighbor_y*_image.width+neighbor_x] > color(higher))) {
                    swap_x = neighbor_x;
                    swap_y = neighbor_y;
                  }
                  break;
                case 5:
                  if (!(_image.pixels[swap_y*_image.width+swap_x] < color(lower) && _image.pixels[swap_y*_image.width+swap_x] > color(higher))) {
                    swap_x = neighbor_x;
                    swap_y = neighbor_y;
                  }
                  break;
                }
              }
            }
          }
        }
      }
      if (!(swap_x == x && swap_y == y)) {
        _image.pixels = swapPixels(_image.pixels, y*_image.width+x, swap_y*_image.width+swap_x);
      }
    }
  }
  _image.updatePixels();
  return _image;
}

boolean evalPixels(PImage _image, int x1, int y1, int x2, int y2, int logic) {
  if (logic == 0 ) {
    return _image.pixels[y1*_image.width+x1] < _image.pixels[y2*_image.width+x2];
  } else if (logic == 1) {
    return _image.pixels[y1*_image.width+x1] > _image.pixels[y2*_image.width+x2];
  } else if (logic == 2) {
    return _image.pixels[y1*_image.width+x1] == _image.pixels[y2*_image.width+x2];
  } else {
    return false;
  }
}

boolean isInBounds(PImage _image, int x, int y) {
  return x >= 0 && x < _image.width && y >= 0 && y < _image.height;
}

PImage resetOutput() {
  return output=input.copy();
}