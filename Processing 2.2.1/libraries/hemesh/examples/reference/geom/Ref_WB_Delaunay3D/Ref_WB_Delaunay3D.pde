import wblut.processing.*;
import wblut.geom.*;
import wblut.core.*;
import wblut.math.*;
import java.util.List;

List<WB_Point> points;
WB_Triangulation3D triangulation;
int[][] tetrahedra;
WB_Predicates pred=new WB_Predicates();
WB_Render3D render;

void setup() {
  size(800, 800, OPENGL);
  render= new WB_Render3D(this);
  smooth(8);
  create();
}

void create() {
  points=new ArrayList<WB_Point>();
  float x, y, z;
  float r=200;
  float[] point=new float[3];
  for (int i=0;i<400;i++) {
    do {
      point[0]=random(-r, r); 
      point[1]=random(-r, r); 
      point[2]=random(-r, r);
    }
    while (noise (10+0.006*point[0], 10+0.006*point[1], 10+0.006*point[2])<0.6);
    points.add(new WB_Point(point[0], point[1], point[2]));
  }
  float m=millis();
  triangulation= WB_Triangulate.getTriangulation3D(points, 0.001);
  tetrahedra=triangulation.getTetrahedra();
  println(millis()-m);
}


void draw() {
  background(255);
  translate(400, 400, 0);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noFill();
  for (int i=0;i<tetrahedra.length;i++) {
    render.drawTetrahedron(tetrahedra[i], points);
  }
}


float r(int[] tetra) {
  return (float) pred.circumradiusTetra(points.get(tetra[0]), points.get(tetra[1]), points.get(tetra[2]), points.get(tetra[3]));
}



