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
  createMesh();

  HES_CatmullClark subdividor=new HES_CatmullClark();
   subdividor.setKeepBoundary(true);// preserve position of vertices on a surface boundary
  subdividor.setKeepEdges(true);// preserve position of vertices on edge of selection (only useful if using subdivideSelected)
 
  mesh.subdivide(subdividor,3);

  render=new WB_Render(this);
}

void draw() {
  background(120);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  fill(255);
  noStroke();
  render.drawFaces(mesh);
  stroke(0);
  render.drawEdges(mesh);
}


void createMesh() {
   HEC_Cylinder creator=new HEC_Cylinder();
  creator.setFacets(6).setSteps(1).setRadius(150).setHeight(400).setCap(true,false);
  mesh=new HE_Mesh(creator);
}

