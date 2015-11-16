PImage source;
PImage output;
color higher=color(75);
color lower=color(150);
int mode = 0;
int type = 1;
int offset_x = 0;
int offset_y = 0;
boolean play = false;
int iterations =0;
boolean[][] rules;

boolean sequence = true;
int start = 0;
int end = 0;
int speed = 1; 

void loadSource() {
//  source = loadImage("Purple-1200_rotate.jpg");
//  output = loadImage("Purple-1200_rotate.jpg");
    source = loadImage("Nebula.jpg");
    output = loadImage("Nebula.jpg");
}

void setup() {
  loadSource();
  size(source.width, source.height);
  rules = new boolean[3][3];

  image(source, 0, 0);
  //  noLoop();
}

void draw() {
//  if (play) {
    output.loadPixels();
    if (sequence) {

      output = lineSweeper(source, start, end, 0);

      if (end >= source.height-1) {
        sequence = false;
      } else {
        end++;
      }
    } else {

      output = lineSweeper(source, start, end, 1);

      if (start >= source.height-1) {
        sequence = false;
      } else {
        start++;
      }
    }
    output.updatePixels();
//    output.save("output/Nebula_GIF_02/Nebula_GIF_"+nf(iterations, 4)+".png");
    iterations++;
//  }
  //    cellSort(source);


  image(output, 0, 0);
}



void keyPressed() {
  println(keyCode);
  switch(keyCode) {
  case 32:
    play=!play;
    break;
  }
}




PImage lineSweeper(PImage _image, int _start, int _end, int _mode) {
  PImage processed = createImage(_image.width, _image.height, ARGB);
  int y_start = (_image.height + _start) % _image.height;
  int y_end = (_image.height + _end) % _image.height;
  color[] buffer = new color[_image.width];

  switch(_mode) {
  case 0:
    for (int x = 0; x < _image.width; x++) {
      buffer[x] = _image.pixels[y_end*_image.width+x];
    }
    break;
  case 1:
    for (int x = 0; x < _image.width; x++) {
      buffer[x] = _image.pixels[y_start*_image.width+x];
    }
    break;
  }

  for (int y = 0; y < _image.height; y++) {
    for (int x = 0; x < _image.width; x++) {
      if ( y >= y_start && y <= y_end) {
        if(buffer[x] > lower && buffer[x] > source.pixels[y*_image.width+x] ){
        processed.pixels[y*_image.width+x] = buffer[x];
        } else {
          processed.pixels[y*_image.width+x] = _image.pixels[y*_image.width+x];
        }
      } else {
        processed.pixels[y*_image.width+x] = _image.pixels[y*_image.width+x];
      }
    }
  }
  return processed;
}



