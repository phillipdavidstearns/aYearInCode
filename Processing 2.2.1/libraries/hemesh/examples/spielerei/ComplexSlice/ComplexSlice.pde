import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;
import java.util.List;

HE_Mesh mesh, smesh;
WB_Render render;
HEM_Slice ss;

void setup() {
  size(1920, 1080, OPENGL);
  smooth(8);
  HEC_Torus creator=new HEC_Torus();
  creator.setRadius(160, 245); 
  creator.setTubeFacets(6);
  creator.setTorusFacets(16);
  creator.setTwist(3);//twist the torus a given number of facets
  mesh=new HE_Mesh(creator);
  mesh.add(new HE_Mesh(creator.setRadius(120, 245)).flipAllFaces()); 
  mesh.add(new HE_Mesh(creator.setRadius(80, 245))); 
  mesh=new HE_Mesh(new HEC_FromFrame().setFrame(mesh).set);
  mesh.add(new HE_Mesh(creator.setRadius(40, 245))); 
  mesh.flipAllFaces();
  mesh.add(new HE_Mesh(creator.setRadius(200, 245))); 
  render=new WB_Render(this);
  create();
}

void draw() {
  background(55);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(width/2, height/2, 100);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  stroke(255, 50);
  render.drawEdges(mesh);
  stroke(0);
  render.drawEdges(smesh); 
  fill(255);
  noStroke();
  render.drawFaces(smesh);
}

void create() {
  smesh=mesh.get();
  WB_Plane P= new WB_Plane(100, 0, 0, 0, 0.4, 1);
  ss=new HEM_Slice().setPlane(P).setSimpleCap(false);
  smesh.modify(ss);
}

