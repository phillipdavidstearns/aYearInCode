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
  HEC_UVParametric creator=new  HEC_UVParametric();
  creator.setUVSteps(40, 40);
  creator.setRadius(100); //scaling factor
  creator.setUWrap(true); // needs to be set manually
  creator.setVWrap(true); // needs to be set manually
  creator.setEvaluator(new UVFunction());// expects an implementation of the WB_Function2D<WB_Point3d> interface, taking u and v from 0 to 1

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
  noStroke();
  render.drawFaces(mesh);
  stroke(0);
  render.drawEdges(mesh);
}

class UVFunction implements WB_Function2D<WB_Point> {
  WB_Point f(double u, double v) {
    double pi23=2*Math.PI/3;
    double ua=Math.PI*2*u;
    double va=Math.PI*2*v;
    double sqrt2=Math.sqrt(2.0d);
    double px = Math.sin(ua) / Math.abs(sqrt2+ Math.cos(va));
    double py = Math.sin(ua+pi23) / Math.abs(sqrt2 +Math.cos(va + pi23));
    double pz = Math.cos(ua-pi23) / Math.abs(sqrt2 +Math.cos(va - pi23));
    return new WB_Point(px, py, pz);
  }
}

