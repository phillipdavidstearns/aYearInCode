PGraphics output;
PGraphics input;
PImage source_image;
PImage destination_image;
int w;
int h;
int position;
int steps = 0;
boolean direction = false;
int paste = 0;
boolean paste_direction = true;
boolean scan = true;

void setup() {
  size(10, 10);
  surface.setResizable(true);
  source_image = loadImage("mountain.jpg");
  w=source_image.width;
  h=source_image.height;
  destination_image = createImage(w, h, RGB);
  surface.setSize(w, h);
  input = createGraphics(w, h);
  output = createGraphics(w, h);
  position=int(random(w));
  
}

void draw() {
  background(255);
  
  //image(source_image, 0, 0);
  pastePixels(copyPixels(source_image, position), destination_image, paste);
  image(destination_image, 0, 0);
  copySource(input);
  pasteDestination(output);
  if(frameCount%(width/2) == 0){
    saveFrame("output/mountain/complete/mountain-######.PNG");
  }
  //image(input, 0, 0);
  //image(output, 0, 0);
  //if(frameCount >= 512){
  //  saveFrame("output/mountain/mountain-####.png");
  //}
  //if(frameCount >= 2048){
  //  exit();
  //}
  }

color[] copyPixels(PImage image, int column) {
  color[] source_pixels = new color[image.height];

  image.loadPixels();
  for (int i = 0; i < image.height; i++) {
    source_pixels[i] = image.pixels[(i*width) + column];
  }

  return source_pixels;
}

void pastePixels(color[] source_pixels, PImage image, int column) {
  image.loadPixels();
  for (int i = 0; i < image.height; i++) {
    image.pixels[(i*width) + column] = source_pixels[i];
    image.pixels[(i*width) + ((width-1)-column)] = source_pixels[i];
  }
  image.updatePixels();
}

void keyPressed(){
  switch(key){
    case '[':
    direction = false;
    break;
    case ']':
    direction = true;
    break;
    case 'p':
    scan = !scan;
    break;
  }
}

void copySource(PGraphics image) {

  //if (steps <= 0) {
  //  steps = int(random(25));
  //  direction = !direction;
  //}
  if(scan){
  if (direction && position >=0 && position < width) {
    position++;
  } else if(!direction && position > 0) {
    position--;
  } else if (direction && position >= width) {
    direction = !direction;
    position--;
  } else if (!direction && position <= 0 ) {
    direction = !direction;
    position++;
  }
  }
  
  position = width+position % width;
  
  //image.beginDraw();
  //image.background(0x00FFFFFF);
  //image.stroke(color(0xFFFF0000));
  //image.line(position, 0, position, image.height);
  //image.endDraw();

  

  //steps--;
}

void pasteDestination(PGraphics graphic) {
  //graphic.beginDraw();
  //graphic.background(0x00FFFFFF);
  //graphic.stroke(color(0xFF00FF00));
  //graphic.line(paste, 0, paste, graphic.height);
  //graphic.line((graphic.width - 1) - paste, 0, (graphic.width - 1) - paste, graphic.height);
  //graphic.endDraw();

  //if (paste_direction && paste >= graphic.width/2) {
  // paste_direction = false;
  //} else if (!paste_direction && paste <=0) {
  // paste_direction = true;
  //}

  //if (paste_direction) {
  // paste++;
  //} else {
  // paste--;
  //}
  
  paste++;
  paste %= width;
}