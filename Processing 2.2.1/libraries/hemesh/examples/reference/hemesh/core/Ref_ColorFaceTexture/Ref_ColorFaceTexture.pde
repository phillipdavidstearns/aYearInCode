import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import processing.opengl.*;

HE_Mesh mesh;
WB_Render render;
PImage img;
PImage[] imgs;
void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  textureMode(NORMAL);
  mesh=new HE_Mesh(new HEC_Torus(80, 200, 6, 12).setTwist(4)); 
  mesh.smooth();
  img=loadImage("texture.jpg");
  render=new WB_Render(this);
  imgs=new PImage[] {
    img, img, img
  };
  mesh.triangulate();
  render.setFaceColorFromTexture(mesh, img);
}

void draw() {
  background(120);
  lights();
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFacesFC(mesh);
  stroke(0);
  render.drawEdges(mesh);
}

