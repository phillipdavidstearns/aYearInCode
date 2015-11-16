/*-----------------------------------
Library: ComputationalGeometry
By: Mark Collins & Toru Hasegawa
Example: IsoContour

Creates a 2D isometric contour, 
based on a series of random points.
------------------------------------*/

import ComputationalGeometry.*;
IsoContour iso;

void setup(){
  
  size(250,250,P3D);

  // Creating the Isocontour
  iso = new IsoContour(this, new PVector(0,0), new PVector(width,height), 10,10); 
  
  // Adding Meta-blobs to the Isocontour
  randomSeed(1);
  for(int i=0; i<20; i++){
    PVector pt = new PVector( random(width), random(height), 0 );
    iso.addPoint(pt);
  }
}
void draw(){
  
  background(220);
  
  // Plot Voxel Space
  noFill();
  stroke(0,50);
  iso.plotGrid();
  
  // Plot Contour at a Threshold
  fill(255,200);
  noStroke();
  float threshold = abs(sin(frameCount/100.0f)) * .01;
  iso.plot( threshold); // you must provide a threshold to render the iso contour
}

