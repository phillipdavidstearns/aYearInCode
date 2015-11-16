import wblut.processing.*;
import wblut.geom.*;
import wblut.core.*;
import wblut.math.*;
import java.util.List;

List<WB_Point4D> points;
int[][] triangulation;

WB_Render3D render;

void setup() {
  size(800, 800, OPENGL);
  render= new WB_Render3D(this);
  smooth(8);
  points=new ArrayList<WB_Point4D>();
  float x, y, z, w;
  float r=300;
  float r2=r*r;
  for (int i=0;i<10;i++) {
    x=random(-r, r);
    y=random(-r, r);
    z=random(-r, r);
    w=random(-r, r);
    points.add(new WB_Point4D(x, y, z, w));
  }
  float m=millis();
  triangulation= WB_Delaunay.getTriangulation4D(points, 0.001).Tri;
  println(millis()-m);
  fill(255);
  noStroke();
  noFill();
  stroke(0, 50);
}

void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(width/2, height/2, 0);
  rotateY(PI/4.0);
  float xt=200*cos(frameCount*0.01);
  for (int i=0;i<triangulation.length;i++) {
    drawHyperTetrahedron(points.get(triangulation[i][0]), points.get(triangulation[i][1]), points.get(triangulation[i][2]), points.get(triangulation[i][3]), points.get(triangulation[i][4]));
  }
  for (WB_Point4D p:points) {

    p.rotateXW(0.02);
  }
}



void drawHyperTetrahedron(final WB_Coordinate p0, final WB_Coordinate p1, 
final WB_Coordinate p2, final WB_Coordinate p3, final WB_Coordinate p4) {
  render.drawTetrahedron(p0, p1, p2, p3);
  render.drawTetrahedron(p0, p1, p2, p4);
  render.drawTetrahedron(p0, p1, p4, p3);
  render.drawTetrahedron(p0, p4, p2, p3);
  render.drawTetrahedron(p4, p1, p2, p3);
}


