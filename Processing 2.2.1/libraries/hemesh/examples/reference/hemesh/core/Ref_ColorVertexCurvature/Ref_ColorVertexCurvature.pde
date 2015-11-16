import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_Render render;

void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  mesh=new HE_Mesh(new HEC_Grid(15, 15, 500, 500)); 
  mesh.modify(new HEM_Noise().setDistance(40));
  render=new WB_Render(this);
  mesh.smooth(3);
 
  HET_Texture.setVertexColorFromVertexCurvature(mesh, -0.0002,0.0002);
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

