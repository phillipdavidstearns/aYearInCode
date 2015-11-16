import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;
import processing.opengl.*;

HE_Mesh mesh;
WB_Render3D render;
WB_DebugRender3D drender;
 HEC_IsoSurfaceSNAP creator;
 float gamma;
 float[][][] values;
void setup() {
  size(800, 800, OPENGL);
  smooth(8);

// Create an isosurface from an explicit grid of values.
// Potentially uses a lot of memory.

  values=new float[41][41][41];
  for (int i = 0; i < 41; i++) {
    for (int j = 0; j < 41; j++) {
      for (int k = 0; k < 41; k++) {
        values[i][j][k]=2.1*noise(0.07*i, 0.07*j, 0.07*k);
      }
    }
  }

  creator=new HEC_IsoSurfaceSNAP();
 creator.setGamma(0.3);// eliminate sharp triangles, 0=no effect, 0.3=optimized result
  creator.setResolution(40,40,40);// number of cells in x,y,z direction
  creator.setSize(10, 10, 10);// cell size
  creator.setValues(values);// values corresponding to the grid points
  // values can also be double[][][]
  creator.setIsolevel(1);// isolevel to mesh
  creator.setInvert(true);// invert mesh
  creator.setBoundary(1000);
  // use creator.clearBoundary() to rest boundary values to "no value".
  // A boundary value of "no value" results in an open mesh

  mesh=new HE_Mesh(creator);
  render=new WB_Render3D(this);
  drender=new WB_DebugRender3D(this);
}

void draw() {
  background(120);
  lights();
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFaces(mesh);
  stroke(0);
  render.drawEdges(mesh);
  
}


