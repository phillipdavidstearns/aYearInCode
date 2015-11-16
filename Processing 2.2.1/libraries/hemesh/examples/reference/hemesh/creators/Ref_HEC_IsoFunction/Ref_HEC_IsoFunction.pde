import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;
import processing.opengl.*;

HE_Mesh mesh;
WB_Render render;

void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  int R=20;
  float d=400.0/R;
  float o=2.5;
  float df=2.0/R;

  // Create an isosurface from an implementation of the WB_Function3D<Double> interface
  // Slower than using an explicit grid of values, but uses far less memory.

  HEC_IsoFunction creator=new HEC_IsoFunction();
  creator.setResolution(R, R, R);// number of cells in x,y,z direction
  creator.setSize(d, d, d);// cell size
  creator.setFunction(new IsoFunction(), o, o, o, df, df, df);// expects an implementation of the WB_Function3D<Double> interface.

  //first three values give center of function space
  //last three values give spacing in function space
  creator.setIsolevel(0.6);// isolevel to mesh
  creator.setInvert(false);// invert mesh
  creator.setBoundary(-1000000);// value of isoFunction outside grid
  // use creator.clearBoundary() to rest boundary values to "no value"

  mesh=new HE_Mesh(creator);
  HET_Diagnosis.validate(mesh);
  render=new WB_Render(this);
}

void draw() {
  background(120);
  lights();
  translate(300, 300, -100);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFaces(mesh);
  stroke(0);
  render.drawEdges(mesh);
}


class IsoFunction implements WB_Function3D<Double> {
  public Double f(double x, double y, double z) {
    return new Double(noise((float)x, (float)y, (float)z ));
  }
}

