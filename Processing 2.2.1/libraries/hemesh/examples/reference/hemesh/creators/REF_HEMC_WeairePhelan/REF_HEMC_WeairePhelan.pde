import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;



HE_Mesh[] meshes;
int nom;
WB_Render render;
void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  HEMC_WeairePhelan wp=new HEMC_WeairePhelan();
  wp.setOrigin(new WB_Point(-200, -200, -200));
  wp.setExtents(new WB_Vector(400, 400, 400));
  wp.setNumberOfUnits(2, 2, 2);
  wp.setScale(150, 150, 150);
  meshes=wp.create();
  nom=wp.numberOfMeshes();
  render=new WB_Render(this);
}


void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, -200);

  scale(1, -1, 1);

  rotateY(TWO_PI/width*mouseX-PI);
  rotateX(TWO_PI/height*mouseY-PI);
  noStroke();
  for (int i=0;i<nom;i++) {
    render.drawFaces(meshes[i]);
  }
  stroke(0);
  for (int i=0;i<nom;i++) {
    render.drawEdges(meshes[i]);
  }
}

