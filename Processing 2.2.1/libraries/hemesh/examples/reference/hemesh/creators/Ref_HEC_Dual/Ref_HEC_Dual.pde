import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
HE_Mesh dual;
WB_Render render;

void setup() {
  size(800, 800, OPENGL);
  smooth(8);

  mesh=new HE_Mesh(new HEC_Octahedron().setEdge(350)); 

  HEC_Dual creator=new HEC_Dual();
  creator.setSource(mesh);
  dual=new HE_Mesh(creator);
  HET_Diagnosis.validate(dual);
  render=new WB_Render(this);
}

void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, 100);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  stroke(0);
  render.drawEdges(mesh);
  render.drawEdges(dual);
  noStroke();
  render.drawFaces(dual);
}

