import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;
import wblut.math.*;

WB_GeometryFactory gf=WB_GeometryFactory.instance();
WB_Render3D render;
ArrayList<WB_Point> shell, hole;
WB_Polygon polygon;
WB_Mesh mesh;
void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  render=new WB_Render3D(this);
  shell= new ArrayList<WB_Point>();
  for (int i=0; i<20; i++) {
    shell.add(gf.createPointFromPolar(100*(i%2+1), TWO_PI/20.0*i));
  }
  hole= new ArrayList<WB_Point>();
  for (int i=0; i<10; i++) {
    hole.add(gf.createPointFromPolar(40*(i%2+1), -TWO_PI/10.*i));
  } 
  polygon=gf.createPolygonWithHole(shell, hole);
  mesh=gf.createPrism(polygon, 100);
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


