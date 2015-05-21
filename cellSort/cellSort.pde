PImage source;
int higher=90;
int lower=175;
int mode = 0;
int type = 1;
int offset = 5;
boolean play = false;
int iterations = 0 ;

void setup() {
  source = loadImage("blackwhite_MISSONI.jpg");
  size(source.width, source.height);
}

void draw() {
  
  
  if (play) {
    if(iterations <120){
      mode = 0;
    } else {
      mode = 1;
    }
    if(iterations >= 240){
      exit();
    }   
    source.loadPixels();
    cellSort(source);
    source.updatePixels();
    source.save("output/Black/012/BW_cellSort_02-"+nf(iterations,4)+".png");
    iterations++;
  }
  
  image(source, 0, 0);
}

void keyPressed() {
  //  println(keyCode);
  switch(keyCode) {
  case 49:
    mode = 0;
    break;
  case 50:
    mode = 1;
    break;
  case 51:
    type = 0;
    break;
  case 52:
    type = 1;
    break;
  case 53:
    resetSource();
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
  case 32:
    play=!play;
    break;
  }
}

void resetSource() {
  source = loadImage("MISSONI_BLACK_45_1800.jpg");
}

int[] swapPixels(int[] _pixelArray, int _index1, int _index2) {
  int buffer = _pixelArray[_index1];
  _pixelArray[_index1] = _pixelArray[_index2];
  _pixelArray[_index2] = buffer;
  return _pixelArray;
}

PImage cellSort(PImage _image) {

  if (mode == 0) {
    for (int y = 0; y < _image.height; y++) {
      for (int x = 0; x < _image.width; x++) {  

        switch(1) {
        case 0:
          for (int ny = 0; ny < 3; ny++) {
            for (int nx = 0; nx < 3; nx++) {
              if (nx != 0 && ny !=0) {
                int neighbor_x = x + nx - offset;
                int neighbor_y = y + ny -5;
                if (neighbor_x >= 0 && neighbor_x < _image.width && neighbor_y >= 0 && neighbor_y < _image.height) {
                  if (_image.pixels[y*_image.width+x] < color(lower) && _image.pixels[y*_image.width+x] > color(higher) ) {
                    if (_image.pixels[y*_image.width+x] < _image.pixels[neighbor_y*_image.width+neighbor_x]) {
                      _image.pixels = swapPixels(_image.pixels, y*_image.width+x, neighbor_y*_image.width+neighbor_x);
                    }
                  }
                }
              }
            }
          }
          break;

        case 1:
          for (int ny = 2; ny >= 0; ny--) {
            for (int nx = 2; nx >= 0; nx--) {
              if (nx != 0 && ny !=0) {
                int neighbor_x = x + nx - offset;
                int neighbor_y = y + ny - offset;
                if (neighbor_x >= 0 && neighbor_x < _image.width && neighbor_y >= 0 && neighbor_y < _image.height) {
                  if (_image.pixels[y*_image.width+x] < color(lower) && _image.pixels[y*_image.width+x] > color(higher) ) {
                    if (_image.pixels[y*_image.width+x] < _image.pixels[neighbor_y*_image.width+neighbor_x]) {
                      _image.pixels = swapPixels(_image.pixels, y*_image.width+x, neighbor_y*_image.width+neighbor_x);
                    }
                  }
                }
              }
            }
          }
          break;
        }
      }
    }
  }

  if (mode == 1) {
    for (int y = _image.height - 1; y >=0; y--) {
      for (int x = _image.width - 1; x >=0; x--) {  

        switch(1) {
        case 0:
          for (int ny = 0; ny < 3; ny++) {
            for (int nx = 0; nx < 3; nx++) {
              if (nx != 0 && ny !=0) {
                int neighbor_x = x + nx - offset;
                int neighbor_y = y + ny - offset;
                if (neighbor_x >= 0 && neighbor_x < _image.width && neighbor_y >= 0 && neighbor_y < _image.height) {
                  if (_image.pixels[y*_image.width+x] < color(lower) && _image.pixels[y*_image.width+x] > color(higher) ) {
                    if (_image.pixels[y*_image.width+x] < _image.pixels[neighbor_y*_image.width+neighbor_x]) {
                      _image.pixels = swapPixels(_image.pixels, y*_image.width+x, neighbor_y*_image.width+neighbor_x);
                    }
                  }
                }
              }
            }
          }
          break;

        case 1:
          for (int ny = 2; ny >= 0; ny--) {
            for (int nx = 2; nx >= 0; nx--) {
              if (nx != 0 && ny !=0) {
                int neighbor_x = x + nx - offset;
                int neighbor_y = y + ny - offset;
                if (neighbor_x >= 0 && neighbor_x < _image.width && neighbor_y >= 0 && neighbor_y < _image.height) {
                  if (_image.pixels[y*_image.width+x] < color(lower) && _image.pixels[y*_image.width+x] > color(higher) ) {
                    if (_image.pixels[y*_image.width+x] > _image.pixels[neighbor_y*_image.width+neighbor_x]) {
                      _image.pixels = swapPixels(_image.pixels, y*_image.width+x, neighbor_y*_image.width+neighbor_x);
                    }
                  }
                }
              }
            }
          }
          break;
        }
      }
    }
  }
  return _image;
}

