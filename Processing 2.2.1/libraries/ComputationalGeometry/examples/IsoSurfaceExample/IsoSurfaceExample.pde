/*-----------------------------------
Library: ComputationalGeometry
By: Mark Collins & Toru Hasegawa
Example: IsoSurface

Creates a 3D isometric surface based
on a series of points. Points act
as meta-ball centers.
------------------------------------*/

import ComputationalGeometry.*;
IsoSurface iso;

void setup(){
  
  size(250,250, P3D);
  
  // Creating the Isosurface
  iso = new IsoSurface(this, new PVector(0,0,0), new PVector(100,100,100), 8);
  
  // Adding Data to the Isosurface
  for(int i=0; i<10; i++){
    PVector pt = new PVector( random(100), random(100), random(100) );
    iso.addPoint(pt);
  }
}
void draw(){
  
  camera(150,150,150,50,50,40,0,0,-1);
  lights();
  background(220);
  
  // Plot Voxel Space
  noFill();
  stroke(0,10);
  iso.plotVoxels();
  
  // Plot Surface at a Threshold
  fill(255,255,0);
  iso.plot(mouseX/10000.0);
}

