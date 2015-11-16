/*-----------------------------------
Library: ComputationalGeometry
By: Mark Collins & Toru Hasegawa
Example: IsoWrap

Creates a simple boundary hull
around a group of points, effectively
shrink wrapping the point cloud
------------------------------------*/

import ComputationalGeometry.*;

IsoWrap wrap;

void setup() {
  
  size(250, 250, P3D);
  
  wrap = new IsoWrap(this);

  // Add points
  for (int i=0; i<30; i++) {
    wrap.addPt( new PVector(random(-100, 100), random(-100, 100), random(-100, 100) ) );
  }  
}

void draw(){
  
  background(220);
  lights();  
  float zm = 250;
  float sp = 0.01 * frameCount;
  camera(zm * cos(sp), zm * sin(sp), zm, 0, 0, 0, 0, 0, -1);

  fill(255,255,0);
  stroke(100);
  wrap.plot();
}
