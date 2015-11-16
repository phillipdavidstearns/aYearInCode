import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

WB_Render render;
WB_RBSpline P;
WB_BSpline T;
WB_Point[] points;
double[] weights;
HE_Mesh mesh;

void setup() {
  size(800, 800, OPENGL);
smooth(8);
// Several WB_Surface classes are in development. HEC_FromSurface provides
// a way of generating meshes from them.
// Example of a surface, a swung NURBS surface generated from a path curve and a trace curve.
  points=new WB_Point[17];
  weights=new double[17];
  for (int i=0;i<17;i++) {
    points[i]=new WB_Point(random(50, 250), 0, -200+i*25); 
    weights[i]=random(1.0);
  }
  
  //Path curve
  P=new WB_RBSpline(points, 2, weights);
  points=new WB_Point[11];
  weights=new double[11];
  for (int i=0;i<11;i++) {
    float a=i*0.080*PI;
    float r=1+random(-.5, .510);
    points[i]=new WB_Point(r*cos(a), r*sin(a), 0); 
    weights[i]=random(1.0);
  }
  
  //Trace curve
  T=new WB_RBSpline(points, 4, weights);
  
  WB_RBSplineSurface surface=WB_NurbsSwungSurface.getSwungSurface(P, T, 1);
  HEC_FromSurface creator=new HEC_FromSurface();
  creator.setSurface(surface);//surface can be any implementation of the WB_Surface interface
  creator.setU(20);// steps in U direction
  creator.setV(20);// steps in V direction
  creator.setUWrap(false);// wrap around in U direction
  creator.setVWrap(false);// wrap around in V direction
  mesh=new HE_Mesh(creator); 
  HET_Diagnosis.validate(mesh);
  render=new WB_Render(this);
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
  render.drawFaces(mesh);}

