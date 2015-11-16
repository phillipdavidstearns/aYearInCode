import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh1, mesh2, mesh3;
WB_Render3D render;

void setup() {
  size(1200, 800, OPENGL);
  smooth(8);
  HEC_Cylinder creator=new HEC_Cylinder();
  creator.setRadius(100); // upper and lower radius. If one is 0, HEC_Cone is called. 
  creator.setHeight(400);
  creator.setFacets(17).setSteps(5);
  creator.setCap(true,true);// cap top, cap bottom?
  creator.setZAxis(0,1,1);
  mesh1=new HE_Mesh(creator); 
  mesh2=mesh1.get();
  mesh3=mesh1.get();
 
  mesh2.modify(new HEM_Diagrid());
  
  HE_Selection selection=mesh3.selectRandomFaces(0.5);
  mesh3.modifySelected(new HEM_Diagrid(), selection);
  
  render=new WB_Render3D(this); 
}

void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(300, 400, 0);
  stroke(0);
  render.drawEdges(mesh1);
  noStroke();
  render.drawFaces(mesh1);
  translate(300, 0, 0);
  stroke(0);
  render.drawEdges(mesh2);
  noStroke();
  render.drawFaces(mesh2);
  translate(300, 0, 0);
  stroke(0);
  render.drawEdges(mesh3);
  noStroke();
  render.drawFaces(mesh3);
  
}

