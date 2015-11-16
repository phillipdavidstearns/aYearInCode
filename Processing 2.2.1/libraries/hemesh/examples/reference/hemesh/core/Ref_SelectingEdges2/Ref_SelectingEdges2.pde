import wblut.math.*;
import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_Render3D render;

void setup() {
  size(800, 800, P3D);
  smooth(8);
  HEC_Dodecahedron creator=new HEC_Dodecahedron();
  creator.setEdge(200); 
  mesh=new HE_Mesh(creator); 

  mesh.splitFacesCenter();
  mesh.splitFacesTri(40);
  mesh.smooth();
  render=new WB_Render3D(this);
}

void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, 0);
  rotateY(frameCount*0.005);
  stroke(0);
  strokeWeight(1);
  render.drawEdges(mesh);
  stroke(255, 0, 0);
  strokeWeight(2);
  HE_Halfedge e=render.pickEdge(mesh, mouseX, mouseY);
  if (e!=null) render.drawEdge(e);
  fill(255);
  noStroke();
  render.drawFaces(mesh);
  fill(255, 0, 0);
}

