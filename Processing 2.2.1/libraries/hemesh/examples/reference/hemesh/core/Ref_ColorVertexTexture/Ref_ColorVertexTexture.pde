import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_Render render;
PImage img;

void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  textureMode(NORMAL);
  mesh=new HE_Mesh(new HEC_Grid(25,25, 500,500)); 
  img=loadImage("texture.jpg");
  render=new WB_Render(this);
  render.setVertexColorFromTexture(mesh,img);
}

void draw() {
  background(120);
  lights();
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFacesVC(mesh);
  stroke(0);
  render.drawEdges(mesh);
}

