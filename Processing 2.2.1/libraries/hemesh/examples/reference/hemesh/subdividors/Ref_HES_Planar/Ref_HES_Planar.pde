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

  HES_Planar subdividor=new HES_Planar();
  
  subdividor.setRandom(true);// Randomize center edge and center face points 
  subdividor.setRange(0.3);// Random range of center offset, from 0 (no random) to 1(fully random)
  subdividor.setSeed(1234L);// Seed of random point generator
  subdividor.setKeepTriangles(true);// Subdivide triangles into 4 triangles instead of 3 quads
  mesh.subdivide(subdividor,2);

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
  HEC_Cube creator=new HEC_Cube(400, 1,1, 1);
  mesh=new HE_Mesh(creator);
  mesh.modify(new HEM_ChamferCorners().setDistance(70));
}

