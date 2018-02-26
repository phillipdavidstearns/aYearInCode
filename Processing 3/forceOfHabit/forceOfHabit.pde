import controlP5.*;

color min;
color max;

int tileSize=16;

PImage input;
PImage output;

boolean play;
boolean record;
boolean visible;

String recordPath;
int frameCounter;

ControlFrame controls;
color controlsBGColor = color(0);

float forceMult = 1;

ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Force> forces = new ArrayList<Force>();
void settings() {
  size(400, 400);
}

void setup() {
  controls = new ControlFrame(this, 100, 150, "Controls");
  surface.setLocation(420, 10);
  play = false;
  record=false;
  visible = false;
  background(0);
}

void draw() {
  if (output != null) {
    image(output, 0, 0);
    for (Node n : nodes) {
      //loadPixels();
      n.copyPixels(output);
      n.applyForce(calcForce(output, n));
      n.pastePixels(output);
      //updatePixels();
      //image(n.image, n.p.x-n.w/2, n.p.y-n.h/2);
      //n.update();
      //n.render();
    }
    //for (Force f : forces) {
    //  f.setForce(calcForce(output, f));
    //  f.render();
    //} 
    if (play) {
      if (record) {
        recordOutput();
      }
    }
  }
}

void generateGrid() {
  forces = new ArrayList<Force>();
  nodes = new ArrayList<Node>();
  int boxW = tileSize;
  int boxH = tileSize;
  int gridW = int(width/boxW);
  int gridH = int(height/boxH);
  int gridX = int((width-(gridW*boxW))/2);
  int gridY = int((height-(gridH*boxH))/2);
  for (int x = 0; x < gridW; x++) {
    for (int y = 0; y < gridH; y++) {
      noFill();
      stroke(255);
      strokeWeight(1);
      rectMode(CENTER);
      rect(gridX+(boxW/2)+(x*boxW), gridY+(boxH/2)+(y*boxH), boxW, boxH);
      forces.add(new Force(gridX+(boxW/2)+(x*boxW), gridY+(boxH/2)+(y*boxH)));
      nodes.add(new Node(gridX+(boxW/2)+(x*boxW), gridY+(boxH/2)+(y*boxH), tileSize));
    }
  }
}

boolean inBounds(int _x, int _y) {
  return _x >= 0 && _x < width && _y >= 0 && _y < height;
}

void mousePressed() {
  int x = mouseX;
  int y = mouseY;
  if (inBounds(x, y)) nodes.add(new Node(x, y));
}

PVector calcForce(PImage _image, Node _n) {
  _image.loadPixels();
  float r=0;
  float g=0;
  float b=0;
  int count=0;
  color avgC;
  for (int x = 0; x < _n.w; x++) {
    for (int y = 0; y < _n.h; y++) {
      int sX = int(_n.o.x + (x - (float(_n.w)/2)));
      int sY = int(_n.o.y + (y - (float(_n.h)/2)));
      sX = (sX+_image.width) % _image.width;
      sY = (sY+_image.height) % _image.height;
      color c = _image.pixels[sY*_image.width+sX];
      r += c >> 16 & 0xFF;
      g += c >> 8 & 0xFF;
      b += c & 0xFF;
      count++;
    }
  }
  avgC = color(r/count,g/count,b/count);
  PVector force = new PVector(0, -1);
  force.rotate(hue(avgC)*2*PI/255);
  force.setMag(forceMult*brightness(avgC)/255);
  return force;
}

PVector calcForce(PImage _image, Force _f) {
  _image.loadPixels();
  float r=0;
  float g=0;
  float b=0;
  int count=0;
  color avgC;
  for (int x = 0; x < tileSize; x++) {
    for (int y = 0; y < tileSize; y++) {
      int sX = int(_f.p.x + (x - (float(tileSize)/2)));
      int sY = int(_f.p.y + (y - (float(tileSize)/2)));
      sX = (sX+_image.width) % _image.width;
      sY = (sY+_image.height) % _image.height;
      color c = _image.pixels[sY*_image.width+sX];
      r += c >> 16 & 0xFF;
      g += c >> 8 & 0xFF;
      b += c & 0xFF;
      count++;
    }
  }

  avgC = color(r/count,g/count,b/count);
  
  PVector force = new PVector(0, -1);
  force.rotate(hue(avgC)*2*PI/255);
  force.setMag(forceMult*brightness(avgC)/255);
  return force;
}

void mouseDragged() {
}


void mouseReleased() {
  //background(0);
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