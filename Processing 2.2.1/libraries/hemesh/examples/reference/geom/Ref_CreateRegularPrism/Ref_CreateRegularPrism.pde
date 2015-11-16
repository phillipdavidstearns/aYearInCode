import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;
import wblut.math.*;

WB_GeometryFactory gf=WB_GeometryFactory.instance();
WB_Render3D render;
WB_Mesh mesh;
void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  render=new WB_Render3D(this);
  mesh=gf.createRegularPrism(12,200, 100);
  background(255);
}

void draw() {
  background(255);
  translate(width/2, height/2);
  lights();
  rotateX(map(mouseY, 0, height, -PI, PI));
  scale(1, -1, 1);
  fill(255, 0, 0);
  render.drawMesh(mesh);
}


