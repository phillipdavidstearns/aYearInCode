import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import processing.opengl.*;

HE_Mesh mesh;
WB_Render render;

PImage[] imgs;
PImage[] imgs2;
PImage[] current;
void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  textureMode(NORMAL);
  HEC_Box creator=new HEC_Box(300, 300, 300, 5,2, 3);
  
  mesh=new HE_Mesh(creator); 
  render=new WB_Render(this);
  imgs=new PImage[] {
    loadImage("front.jpg"), loadImage("back.jpg"), loadImage("top.jpg"), loadImage("bottom.jpg"), loadImage("right.jpg"), loadImage("left.jpg")
    };
    PImage texture=loadImage("texture.jpg");
  imgs2=new PImage[] {
    texture, texture, texture, texture, texture, texture
  };
  current=imgs;
}

void draw() {
  background(120);
  lights();
  translate(400, 400, 0);
  scale(1, -1, 1);
  rotateY(-PI+mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFaces(mesh, current);
  stroke(0);
  render.drawEdges(mesh);
}

void mousePressed() {
  if (current==imgs) {
    current=imgs2;
  } else {
    current=imgs;
  }
}

