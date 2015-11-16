import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_Render render;
WB_Plane P;

void setup() {
  size(800, 800, P3D);
  createMesh();
  
  HEM_SliceSurface modifier=new HEM_SliceSurface();
  
  P=new WB_Plane(0,0,0,1,1,1); 
  modifier.setPlane(P);// Cut plane 
  //you can also pass directly as origin and normal:  modifier.setPlane(0,0,-200,0,0,1)
  modifier.setOffset(0);// shift cut plane along normal
  
  mesh.modify(modifier);
  
  render=new WB_Render(this);
}

void draw() {
  background(120);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(0.25*TWO_PI);
  fill(255);
  noStroke();
  render.drawFaces(mesh);
  noFill();
  stroke(0);
  render.drawEdges(mesh);
  strokeWeight(4);
  stroke(0,0,255);
  render.drawEdgesWithInternalLabel(1,mesh);// New edges by the slice operation get label 1
   strokeWeight(1);
  stroke(255,0,0);
  render.drawPlane(P,300);

}


void createMesh(){
  HEC_Cylinder creator=new HEC_Cylinder();
  creator.setFacets(32).setSteps(16).setRadius(50).setHeight(400).setCenter(0,0,0);
  mesh=new HE_Mesh(creator);
  
}

