PImage source;
PImage output;
int higher=110;
int lower=190;
int type = 1;
int offset_x = 0;
int offset_y = 0;
boolean play = false;
boolean wrap = false;
int eval_mode = 0;
int mode = 0; //sets the threshold evaluation mode
int iterations = 0;
boolean[][] rules;
int logic = 0;
boolean sequence = true;
int start = 0;
int end = 0;
int speed = 1; 

void loadSource() {
  //  source = loadImage("Purple-1200_rotate.jpg");
  //  output = loadImage("Purple-1200_rotate.jpg");
//  source = loadImage("Nebula.jpg");
//  output = loadImage("Nebula.jpg");
//  source = loadImage("orion_nebula_complex_wide.jpeg");
//  output = loadImage("orion_nebula_complex_wide.jpeg");
source = loadImage("orion.jpeg");
output = loadImage("orion.jpeg");


  image(source, 0, 0);
}

void setup() {
  loadSource();
  size(source.width, source.height);
  rules = new boolean[3][3];
  setRules();
  image(source, 0, 0);
  //  noLoop();
}

void draw() {

  if (play) {
    
    source.loadPixels();
    output = cellSort(source);
    output.updatePixels();
    image(output, 0, 0);
    output.save("output/nebula_03/orion_cellSort_Test_01-"+nf(iterations,4)+".png");
    iterations++;
  }
}

void setRules() {
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
  println(keyCode);
  switch(keyCode) {
  case 48:
    setRules();
    break;  
  case 49:
    rules[0][0] = !rules[0][0];
    break;
  case 50:
    rules[0][1] = !rules[0][1];
    break;
  case 51:
    rules[0][2] = !rules[0][2];
    break;
  case 52:
    rules[1][0] = !rules[1][0];
    break;
  case 53:
    rules[1][1] = !rules[1][1];
    break;
  case 54:
    rules[1][2] = !rules[1][2];
    break;
  case 55:
    rules[2][0] = !rules[2][0];
    break;
  case 56:
    rules[2][1] = !rules[2][1];
    break;
  case 57:
    rules[2][2] = !rules[2][2];
    break;

  case 82:
    loadSource();
    break;
  case 38: // up arrow
    higher++;
    println(higher);
    break;
  case 40: // down arrow
    higher--;
    println(higher);
    break;
  case 37: // up arrow
    lower--;
    println(lower);
    break;
  case 39: // down arrow
    lower++;
    println(lower);
    break;
  case 32: // space toggles animation
    play=!play;
    break;
  case 87: // w toggles edge wrap mode
    wrap=!wrap;
    break;
  case 65: // w toggles edge wrap mode
    mode=0;
    break;
  case 66: // w toggles edge wrap mode
    mode=1;
    break;
  case 67: // w toggles edge wrap mode
    mode=2;
    break;
  case 68: // w toggles edge wrap mode
    mode=3;
    break;
  case 69: // w toggles edge wrap mode
    mode=4;
    break;
  case 70: // w toggles edge wrap mode
    mode=5;
    break;
  case 44:
    logic = 0;
    break;
  case 46:
    logic = 1;
    break;  
  
  }
}


int[] swapPixels(int[] _pixelArray, int _index1, int _index2) {
  int buffer = _pixelArray[_index1];
  _pixelArray[_index1] = _pixelArray[_index2];
  _pixelArray[_index2] = buffer;
  return _pixelArray;
}



PImage cellSort(PImage _image) {
  int swap_x = 0;
  int swap_y = 0;
  int neighbor_x = 0;
  int neighbor_y = 0;

  for (int y = 0; y < _image.height; y++) {
    for (int x = 0; x < _image.width; x++) {
      swap_x = x;
      swap_y = y;
      for (int ny = 0; ny < 3; ny++ ) {
        for (int nx = 0; nx < 3; nx++) {
          if (rules[nx][ny] /*&& (nx != 1 && ny != 1)*/) {
            if (!wrap) {
              neighbor_x = x + (nx-1);
              neighbor_y = y + (ny-1);
            } else {
              neighbor_x = (_image.width + x + (nx-1)) % _image.width;
              neighbor_y = (_image.height + y + (ny-1)) % _image.height;
            }
            if (coordinateInBounds(_image, neighbor_x, neighbor_y)) {
              if (evalPixels(_image, neighbor_x, neighbor_y, swap_x, swap_y, logic)) {
                switch(mode) {
                case 0:
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
  return _image;
}

boolean evalPixels(PImage _image, int x1, int y1, int x2, int y2 , int logic){
  boolean output = false;
 
   switch(logic){
     case 0:
      output = _image.pixels[y1*_image.width+x1] < _image.pixels[y2*_image.width+x2];
      break;
    case 1:
      output =  _image.pixels[y1*_image.width+x1] > _image.pixels[y2*_image.width+x2];
      break;
   }
   return output;
}

boolean coordinateInBounds(PImage _image, int x, int y) {
  return x >= 0 && x < _image.width && y >= 0 &&y < _image.height;
}


boolean pixelWithinWindow(PImage _image, int x, int y, int lower, int higher) {
  return _image.pixels[y*_image.width+x] < color(lower) && _image.pixels[y*_image.width+x] > color(higher);
}

