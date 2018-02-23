import controlP5.*;

color min;
color max;

PImage input;
PImage output;

boolean play;
boolean record;
boolean visible;

String recordPath;
int frameCounter;

ControlFrame controls;
color controlsBGColor = color(0);

void settings() {
  size(400, 400);
}

void setup() {

  controls = new ControlFrame(this, 600, 900, "Controls");
  surface.setLocation(420, 10);
  play = false;
  record=false;
  visible = false;

}

void draw() {

  stroke(255);
  if (output != null) {
    image(output, 0, 0);
    if (play) {
      
      if (record) {
        recordOutput();
      }
    }
  }
}

void recordOutput() {
  output.save(recordPath+"_"+nf(frameCounter, 4)+".png");
  frameCounter++;
}


color getPixel(PImage _image, int _x, int _y) {
  return _image.pixels[_y*width+_x];
}

PImage resetOutput() {
  return output=input.copy();
}