import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;
import wblut.core.*;
import wblut.math.*;

WB_Mesh  zono;
WB_Vector[] vectors;
WB_Vector[] axes;
int n;
WB_Render3D render;
WB_GeometryFactory gf=WB_GeometryFactory.instance();
HE_Mesh mesh;
void setup() {
  size(1280, 720, OPENGL);
  smooth(8);
  render=new WB_Render3D(this);
  n=10;
  vectors=new WB_Vector[n];
  axes=new WB_Vector[n];
  for (int i=0; i<n; i++) {
    vectors[i]=gf.createNormalizedVector(random(-1.0, 1.0), random(-1.0, 1.0), random(-1.0, 1.0));
    axes[i]=gf.createNormalizedVector(random(-1.0, 1.0), random(-1.0, 1.0), random(-1.0, 1.0));
  }
  zono=gf.createZonohedron(vectors, 40);
  mesh=new HE_Mesh(zono);
}

void draw() {
  background(50);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  scale(1);
  translate(width/2, height/2, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFaces(mesh);
  stroke(0);
  render.drawEdges(mesh);
  update();
}

void update() {
  for (int i=0; i<n; i++) {
    vectors[i].rotateAbout2PointAxisSelf(0.01, axes[i], WB_Point.ZERO());
  }

  zono=gf.createZonohedron(vectors, 40);
  mesh=new HE_Mesh(zono);
}




