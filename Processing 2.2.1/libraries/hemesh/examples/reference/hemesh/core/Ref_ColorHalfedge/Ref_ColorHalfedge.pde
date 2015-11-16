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

  colorMode(HSB);
  HE_FaceIterator fitr=new HE_FaceIterator(mesh);
  int i=0;
  while (fitr.hasNext ()) {
    HE_Face f=fitr.next();
    int hue=6*(i++);
    HE_Halfedge he=f.getHalfedge();
    do {
      he.setColor(color(hue+random(10), 200, random(255)));
      he=he.getNextInFace();
    }
    while (he!=f.getHalfedge ());
  }
  colorMode(RGB);

  render=new WB_Render3D(this);
}

void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, 100);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  stroke(0);
  render.drawEdges(mesh);
  noStroke();
  render.drawFacesHC(mesh);
}

