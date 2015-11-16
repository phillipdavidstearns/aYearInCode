import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

WB_HashGrid	grid;
HE_Mesh		mesh;
WB_Render	render;

public void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  int R=128;
  
  // Create an isosurface from a WB_HashGrid. Uses less memory
  // than an explict grid of values.
  
  float dR=400.0/R;
  grid = new WB_HashGrid(R, R, R);
 
  // Fill grid with 400 metaballs
  for (int i = 0; i < 400; i++) {
    int k=(int)random(R);
    int l=(int)random(R);
    int m=(int)random(R);
    int r=(int)random(10,20);//radius of metaball
    double r2=r*r;
  
    for (int dk=-r;dk<=r;dk++) {
      for (int dl=-r;dl<=r;dl++) {
        for (int dm=-r;dm<=r;dm++) {
          double d2=(dk*dk+dl*dl+dm*dm)/r2;
          if(d2<1.0){
          double v=1.0-d2;
          grid.addValue(v*v, k+dk, l+dl, m+dm);
          }
        }
      }
    }
  }
  
  final HEC_IsoGrid igc = new HEC_IsoGrid().setIsolevel(0.5).setSize(dR, dR, dR).setValues(
  grid).setGridCenter(0, 0, 0);
  mesh = new HE_Mesh(igc);
  HET_Diagnosis.validate(mesh);
  render = new WB_Render(this);
}


public void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, 0);
  rotateY(mouseX * 1.0f / width * TWO_PI - PI);
  rotateX(mouseY * 1.0f / height * TWO_PI - PI);
  noStroke();
  render.drawFaces(mesh);
  

}

