import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_Render render;

void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  HEC_ConvexHull creator=new HEC_ConvexHull();
  float[][] points =new float[500000][3];
  for (int i=0;i<500000;i++) {
    points[i][0]=random(-200, 200); 
    points[i][1]=random(-200, 200); 
    points[i][2]=random(-200, 200);
  }
  creator.setPoints(points);
  //alternatively points can be WB_Point[], HE_Vertex[], any Collection<WB_Point>, any Collection<HE_Vertex>,
  //double[][] or int[][]
  creator.setN(500000); // set number of points, can be lower than the number of passed points, only the first N points will be used

  
  mesh=new HE_Mesh(creator); 
  HET_Diagnosis.validate(mesh);
  render=new WB_Render(this);
}

void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  stroke(0);
  render.drawEdges(mesh);
  noStroke();
  render.drawFaces(mesh);
}

