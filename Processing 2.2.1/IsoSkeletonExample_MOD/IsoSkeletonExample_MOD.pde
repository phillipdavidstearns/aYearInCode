/*-----------------------------------
 Library: ComputationalGeometry
 By: Mark Collins & Toru Hasegawa
 Example: IsoSkeleton
 
 Creates a 3D skeleton with adjustable 
 thickness and node size, based on an
 edge pairing of points.
 ------------------------------------*/

import ComputationalGeometry.*;



//ArrayList<PVector> points;

Point[] points;
Ball[] balls;

IsoSkeleton skeleton;
IsoSurface iso;
IsoWrap wrap;

PGraphics gradient;
PImage frameBuffer;

int blend_mode = 0;
float offset_skeleton = 0;
float offset_iso = 0;
float offset_wrap = 0;

float skeleton_distance = 50;

boolean save = false;
boolean render_iso = false;
boolean render_wrap = false;
boolean render_skeleton = false;
boolean render_texture = false;
boolean render_balls = false;

int num_points = 100;
int num_balls = 250;
float sp_mult = .0125;
float cam_x_mult = .5;
float cam_y_mult = .5;
float bounds = 125;
float velocity_mult = 1;

boolean move = false;

void setup() {
  size(1280, 720, P3D);
  frame.setSize(1280, 720);
  frame.setLocation(0, 0);
  noCursor();
  generatePoints(num_points);  
  gradient = createGradient(200, 200);
  frameBuffer = createImage(width, height, RGB);
  generateFrame(frameBuffer);
  balls = new Ball[num_balls];
  for (int i = 0; i < balls.length; i++) {
    balls[i] = new Ball();
  }
}

void draw() {
  background(pow(sin(.125*frameCount/(2*PI)), 2)*256, 25, 255);
  lights(); 
  ambientLight(64,64,64); 
  float zm = 150;
  float sp = sp_mult * frameCount;
  camera(zm * cos(cam_x_mult*sp), zm * sin(cam_y_mult*sp), zm, 0, 0, 0, 0, 0, -1);

  if (render_balls) {
    for (int i = 0; i < balls.length; i++) {
      balls[i].update();
      balls[i].render();
    }
  }

  if (move) {
    updatePoints();
  }

  colorMode(HSB, 256, 256, 256);

  switch(blend_mode) {
  case 0:
    blendMode(NORMAL);
    break;
  case 1:
    blendMode(ADD);
    break;
  case 2:
    blendMode(SUBTRACT);
    break;
  case 3:
    blendMode(MULTIPLY);
    break;
  case 4:
    blendMode(SCREEN);
    break;
  case 5:
    blendMode(ALPHA);
    break;
  }

  if (render_iso) {
    createIso();
    fill((pow(sin(.27*frameCount/(2*PI)), 2)*255 + offset_iso)%256, 100, 255, 255);
    noStroke();
    iso.plot(mouseX/100000.0);
  }

  if (render_texture) {
    textureMap();
  }

  if (render_skeleton) {
    createSkeleton();
    fill((pow(sin(.35*frameCount/(2*PI)), 2)*256 + offset_skeleton)%256, 100, 255);
    stroke(0);
    strokeWeight(0);
    //  skeleton.plot(1*pow(sin(.0135*frameCount),2), 1*pow(cos(.035*frameCount),2));
    skeleton.plot(1, 0);
  }

  if (render_wrap) {
    createWrap();
    fill((pow(sin(.5*frameCount/(2*PI)), 2)*256 + offset_wrap)%256, 100, 255, 255);
    noStroke();
    wrap.plot();
  }

  generateFrame(frameBuffer);
  if(save){
    saveFrame("output/001/001_######.JPG");
  }
}



void generateFrame(PImage _image) {
  _image.loadPixels();
  loadPixels();
  for (int i = 0; i < _image.pixels.length; i++) {
    _image.pixels[i] = pixels[i];
  }
  _image.updatePixels();
}

void textureMap() {
  noSmooth();
  for (int i = 0; i <  points.length; i+=4) {
    stroke(0);
    strokeWeight(0);
    textureMode(IMAGE);
    beginShape();
    //    texture(gradient);

    texture(frameBuffer);
    for (int j=0; j<4; j++) {
      int ux = 0;
      int uy = 0;
      switch(j%4) {
      case 0:
        ux = 0;
        uy = 0;
        break;
      case 1:
        ux = frameBuffer.width;
        uy = 0;
        break;
      case 2:
        ux = frameBuffer.width;
        uy = frameBuffer.height;
        break;
      case 3:
        ux = 0;
        uy = frameBuffer.height;
        break;
      } 
      vertex(points[i+j].position.x, points[i+j].position.y, points[i+j].position.z, ux, uy);
    }
    endShape();
  }
}

void generatePoints(int _points) {
  points = new Point[_points];
  for (int i=0; i<_points; i++) {
    //    pts[i] = new PVector(random(-100, 100), random(-100, 100), random(-100, 100) );
    Point point = new Point();
    points[i]=point;
  }
}

void updatePoints() {
  for (int i=0; i<points.length; i++) {
    points[i].update();
  }
}

void randomizeVelocities() {
  for (int i=0; i<points.length; i++) {
    points[i].velocity = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
  }
}

void randomizePositions() {
  for (int i=0; i<points.length; i++) {
    points[i].position = new PVector(random(-bounds, bounds), random(-bounds, bounds), random(-bounds, bounds));
  }
}

void createIso() {
  iso = new IsoSurface(this, new PVector(-bounds, -bounds, -bounds), new PVector(bounds, bounds, bounds), 10);
  for (int i=0; i<points.length; i++) {
    iso.addPoint(points[i].position);
  }
}

void createWrap() {
  wrap = new IsoWrap(this);
  for (int i=0; i<points.length; i++) {
    wrap.addPt(points[i].position);
  }
}

void createSkeleton() {
  skeleton = new IsoSkeleton(this);
  for (int i=0; i<points.length; i++) {
    for (int j=i+1; j<points.length; j++) {
      PVector pointA = points[i].position;
      PVector pointB = points[j].position;
      if (pointA.dist( pointB ) < skeleton_distance) {
        skeleton.addEdge(pointA, pointB);
      }
    }
  }
}


PGraphics createGradient(int w, int h) {
  PGraphics graphic = createGraphics(w, h, P3D);
  graphic.beginDraw();
  graphic.loadPixels();
  colorMode(HSB, 256, 256, 256);
  color colorA = color(random(256), 64, 255);
  color colorB = color(random(256), 64, 255);
  color colorC = color(random(256), 64, 255);
  color colorD = color(random(256), 64, 255);
  for (int y = 0; y < graphic.height; y++) {
    color colorL = lerpColor(colorA, colorB, float(y)/float(graphic.height-1));
    color colorR = lerpColor(colorC, colorD, float(y)/float(graphic.height-1));
    for (int x = 0; x < graphic.width; x++ ) {
      graphic.pixels[y*graphic.width+x] = lerpColor(colorL, colorR, float(x)/float(graphic.width-1));
    }
  }
  graphic.updatePixels();
  graphic.endDraw();
  return graphic;
}

PGraphics createGradient(int w, int h, color colorA, color colorB, color colorC, color colorD) {
  PGraphics graphic = createGraphics(w, h, P3D);
  graphic.beginDraw();
  graphic.loadPixels();

  for (int y = 0; y < graphic.height; y++) {
    color colorL = lerpColor(colorA, colorB, float(y)/float(graphic.height-1));
    color colorR = lerpColor(colorC, colorD, float(y)/float(graphic.height-1));
    for (int x = 0; x < graphic.width; x++ ) {
      graphic.pixels[y*graphic.width+x] = lerpColor(colorL, colorR, float(x)/float(graphic.width-1));
    }
  }
  graphic.updatePixels();
  graphic.endDraw();
  return graphic;
}
