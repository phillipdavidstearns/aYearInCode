import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_Render render;
PImage img;
PImage[] imgs;
void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  mesh=new HE_Mesh(new HEC_Torus(80, 200, 6, 12)); 
  mesh.modify(new HEM_Noise().setDistance(30));
  mesh.modify(new HEM_Crocodile().setDistance(75).setChamfer(0.25));
  mesh.modify(new HEM_Crocodile().setDistance(20).setChamfer(0.85));
  render=new WB_Render(this);
  //mesh.smooth();
  HET_Texture.setVertexColorFromVertexUmbrella(mesh, 0,3);
}

void draw() {
  background(120);
  noLights();
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFacesVC(mesh);
  stroke(0);
 // render.drawEdges(mesh);
}

