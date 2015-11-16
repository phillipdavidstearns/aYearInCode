import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;


HE_Mesh mesh;
WB_AABBTree tree;
WB_Render render;
WB_Plane[] planes;
HEM_MultiSlice modifier;
WB_RandomOnSphere rnds;
WB_Ray randomRay;
boolean growing;


void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  rnds=new WB_RandomOnSphere();
  createMesh(); 
  render=new WB_Render(this);
  growing=true;
}

void draw() {
  background(120, 120, 120);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  fill(255);
  noStroke();
  render.drawFaces(mesh);
  noFill();
  stroke(0, 50);
  render.drawEdges(mesh);
  fill(255, 0, 0);
  stroke(255, 0, 0);
  if (growing) for (int i=0;i<20;i++)grow();
  if (frameCount==100) {
    mesh.subdivide(new HES_CatmullClark());
    growing=false;
  }
}


void createMesh() {
  int u=6;
  int v=12;
  HEC_Torus creator=new HEC_Torus(50, 150, u, v);
  mesh=new HE_Mesh(creator);
  creator=new HEC_Torus(40, -150, u, v);
  mesh.add(new HE_Mesh(creator));
  tree=new WB_AABBTree(mesh, 10);
}



void grow() {
  randomRay=new WB_Ray(new WB_Point(0, 0, -150), new WB_Vector(random(-1, 1), random(-1, 1), random(-1, 1)));
  HE_FaceIntersection fi=HE_Intersection.getFurthestIntersection( tree, randomRay);
  WB_Point point;
  if (fi!=null) {
    point=fi.point;
    point.addMulSelf(50,randomRay.getDirection());
    HEM_TriSplit.splitFaceTri(mesh,fi.face, point);
    tree=new WB_AABBTree(mesh, 10);
  }
}

