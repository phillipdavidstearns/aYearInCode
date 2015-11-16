import wblut.math.*;
import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;
import wblut.core.*;
HE_Mesh mesh, base;
WB_Render3D render;

void setup() {
  size(800, 800, P3D);
  smooth(8);

  render=new WB_Render3D(this);
  HEC_Dodecahedron creator=new HEC_Dodecahedron();
  creator.setEdge(200); 
  base=new HE_Mesh(creator);
  base.modify(new HEM_ChamferCorners().setDistance(50));
  create();
}

void create() {
  mesh=base.get();
  for (int r=0;r<4;r++) {
    int choice=(int)random(4.999);
    switch(choice) {
    case 0:
      mesh.splitFacesTri();
      break;
    case 1:
      mesh.splitFacesQuad();
      break;
    case 2:
      mesh.splitFacesHybrid();
      break;
    case 3:
      mesh.splitFacesMidEdge();
      break;
    case 4:
      mesh.splitFacesCenter();
      break;
    }
  }
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
  render.drawFaces(mesh);
}

void mousePressed() {
  create();
}

