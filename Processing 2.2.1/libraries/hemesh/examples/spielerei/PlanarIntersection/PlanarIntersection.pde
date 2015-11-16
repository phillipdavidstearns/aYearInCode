import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;
import java.util.List;

HE_Mesh mesh;
WB_Render3D render;
List<WB_Segment> segs;

void setup() {
  size(1920, 1080, OPENGL);
  smooth(8);
  HEC_Torus creator=new HEC_Torus();
  creator.setRadius(160, 245); 
  creator.setTubeFacets(8);
  creator.setTorusFacets(16);
  mesh=new HE_Mesh(creator);
  mesh.add(new HE_Mesh(creator.setRadius(120, 245)).flipAllFaces()); 
  mesh.add(new HE_Mesh(creator.setRadius(80, 245))); 
  mesh=new HE_Mesh(new HEC_FromFrame().setFrame(mesh));
  mesh.add(new HE_Mesh(creator.setRadius(40, 245))); 
  mesh.flipAllFaces();
  mesh.add(new HE_Mesh(creator.setRadius(200, 245))); 
  render=new WB_Render3D(this);
  WB_Plane P= new WB_Plane(0, 0, 0, 1, 0, 0);
  segs=HE_Intersection.getIntersection(new WB_AABBTree(mesh, 16), P);
}

void draw() {
  background(55);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(width/2, height/2, 100);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  strokeWeight(0.5);
  stroke(255, 50);
  render.drawEdges(mesh);
  stroke(255, 0, 0);
  strokeWeight(2);
  render.drawSegment(segs); 
  WB_Plane P= new WB_Plane(0, 0, 0, cos(frameCount*0.01), 0, sin(frameCount*0.01));
  segs=HE_Intersection.getIntersection(new WB_AABBTree(mesh, 16), P);
}

