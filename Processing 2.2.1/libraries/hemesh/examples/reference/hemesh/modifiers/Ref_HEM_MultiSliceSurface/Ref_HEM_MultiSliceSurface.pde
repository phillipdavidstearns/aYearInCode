import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_Render render;
WB_Plane[] planes;
HEM_MultiSliceSurface modifier;
void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  createMesh();
  
  modifier=new HEM_MultiSliceSurface();
  planes=new WB_Plane[20];
  for(int i=0;i<2;i++){
  planes[i]=new WB_Plane(0,0,random(-50,50),random(-1,1),random(-1,1),random(-1,1));
  } 
  modifier.setPlanes(planes);// Cut plane 
  //planes can also be any Collection<WB_Plane>
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
 
  stroke(0,50);
  render.drawEdges(mesh);
  strokeWeight(4);
  stroke(0,0,255);
  render.drawEdgesWithInternalLabel(1,mesh);// New edges by the slice operation get label 1
  
  strokeWeight(1);
  stroke(255,0,0);
  for(int i=0;i<1;i++){
  render.drawPlane(planes[i],400);
  }

}


void createMesh(){
  HEC_Cylinder creator=new HEC_Cylinder();
  creator.setFacets(8).setSteps(1).setRadius(100).setHeight(400).setCenter(0,0,0);
  mesh=new HE_Mesh(creator);
  
}

