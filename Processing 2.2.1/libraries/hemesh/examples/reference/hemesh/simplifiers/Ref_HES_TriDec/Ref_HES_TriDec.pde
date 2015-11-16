import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh, oldmesh;
WB_Render render;

void setup() {
  size(800, 800, P3D);
  createMesh();


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
  stroke(255,0,0);
  render.drawEdges(oldmesh);
  stroke(0);
  render.drawEdges(mesh);

}


void createMesh() {
   HEC_Torus creator=new HEC_Torus(80,240,40,80);
  mesh=new HE_Mesh(creator);

  oldmesh=mesh.get();
   mesh.simplify(new HES_TriDec().setGoal(160)); 
}








