import processing.opengl.*;

import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_Render render;

void setup() {
  size(1000, 1000, OPENGL);
  smooth(8);
  createMesh();

  HEM_Wireframe modifier=new HEM_Wireframe();
  modifier.setStrutRadius(6);// strut radius
  modifier.setStrutFacets(6);// number of faces in the struts, min 3, max whatever blows up the CPU
 // modifier.setMaximumStrutOffset(20);// limit the joint radius by decreasing the strut radius where necessary. Joint offset is added after this limitation.
  modifier.setAngleOffset(0.5);// rotate the struts by a fraction of a facet. 0 is no rotation, 1 is a rotation over a full facet. More noticeable for low number of facets.
  modifier.setTaper(false);// allow struts to have different radii at each end?
  mesh.modify(modifier);
  
mesh.modify(new HEM_Slice().setPlane(0,0,-50,0,0,1));

  render=new WB_Render(this);
}

void draw() {
  background(120);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(500, 500, 100);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  fill(255);
  noStroke();
  render.drawFaces(mesh);
  stroke(0);
  render.drawEdges(mesh);
}

void createMesh(){
  HEC_SuperDuper sd=new HEC_SuperDuper();
  sd.setU(16).setV(8).setRadius(80);
  sd.setDonutParameters(0, 10, 10, 10, 3, 6, 12, 12, 3,4);
  mesh=new HE_Mesh(sd); 
}

