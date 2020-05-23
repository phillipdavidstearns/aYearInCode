PImage src, buffer;
String path;
String file;
float noiseScaleMin=0.0003;
float noiseScaleMax=0.005;
int warp=250;
int iterations=3;

void setup() {
  size(10, 10);
  background(0);
  frameRate(30);
  noiseDetail(8, 0.5);
  open_file();
  //noLoop();
}

void draw() {
  if (buffer != null) {
    buffer = src.copy();



    //perlinRows(buffer, int(warp*sin(frameCount/126.0)), map(sin(frameCount/120.0), -1, 1, noiseScaleMin, noiseScaleMax));
    //perlinCols(buffer, int(warp*sin(frameCount/127.0)), map(sin(frameCount/121.0), -1, 1, noiseScaleMin, noiseScaleMax));
    //perlinRows(buffer, int(warp*sin(frameCount/128.0)), map(sin(frameCount/122.0), -1, 1, noiseScaleMin, noiseScaleMax));
    //perlinCols(buffer, int(warp*sin(frameCount/129.0)), map(sin(frameCount/123.0), -1, 1, noiseScaleMin, noiseScaleMax));
    //perlinRows(buffer, int(warp*sin(frameCount/130.0)), map(sin(frameCount/124.0), -1, 1, noiseScaleMin, noiseScaleMax));
    //perlinCols(buffer, int(warp*sin(frameCount/131.0)), map(sin(frameCount/125.0), -1, 1, noiseScaleMin, noiseScaleMax));

    for (int i = 0; i < iterations; ++i) {
      int start = int(random(0, buffer.height));
      int end = int(start+random(0, buffer.height-start));
      int amount = int(random(0, buffer.width));
      
      shiftRows(buffer, start, end, amount);
      
      start = int(random(0, buffer.width));
      end = int(start+random(0, buffer.width-start));
      amount = int(random(0, buffer.height));
      
      shiftCols(buffer, start, end, amount);
    }

    image(buffer, 0, 0);
  }
}

PImage shiftRows(PImage image, int start, int end, int amount) {
  for (int i = start; i < end; ++i) {
    shiftRow(image, i, amount);
  }
  return image;
}

PImage shiftCols(PImage image, int start, int end, int amount) {
  for (int i = start; i < end; ++i) {
    shiftCol(image, i, amount);
  }
  return image;
}


PImage perlinRows(PImage image, int amount, float scale) {
  for (int i =0; i < image.height; ++i) {
    shiftRow(image, i, int(amount*map(noise(i*scale), 0, 1, -1, 1)));
  }
  return image;
}

PImage perlinCols(PImage image, int amount, float scale) {
  for (int i =0; i < image.width; ++i) {
    shiftCol(image, i, int(amount*map(noise(i*scale), 0, 1, -1, 1)));
  }
  return image;
}


PImage shiftRow(PImage image, int row, int amount) {
  if (image != null && row < image.height) {
    color[] pxls = new color[image.width];
    for (int i = 0; i < image.width; ++i) {
      pxls[(i+amount+image.width) % image.width] = image.pixels[row*image.width+i];
    }
    for (int i = 0; i < image.width; ++i) {
      image.pixels[row*image.width+i]=pxls[i];
    }
  }
  return image;
}

PImage shiftCol(PImage image, int col, int amount) {
  if (image != null && col < image.width) {
    color[] pxls = new color[image.height];
    for (int i = 0; i < image.height; ++i) {
      pxls[(i+amount+image.height) % image.height] = image.pixels[i*image.width+col];
    }
    for (int i = 0; i < image.height; ++i) {
      image.pixels[i*image.width+col]=pxls[i];
    }
  }
  return image;
}
