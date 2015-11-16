import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;


float[][] points;
int numpoints;
HE_Mesh container;
HE_Mesh[] cells;
int numcells;

WB_Render render;

void setup() {
  size(800,800,OPENGL);
  smooth(8);
  // Brute force approach to 3D Voronoi cells constrained to a maximum radius. Very inefficient, useful
  // for prototyping tens to hundreds of points, painfully slow
  // for more...
  

  
  //generate points
  numpoints=100;
  points=new float[numpoints][3];
  for(int i=0;i<numpoints;i++) {
    points[i][0]=random(-250,250);
    points[i][1]=random(-250,250);
    points[i][2]=random(-250,250);
  }
  
  // generate voronoi cells
  HEMC_VoronoiSpheres multiCreator=new HEMC_VoronoiSpheres();
  multiCreator.setPoints(points);
  // alternatively points can be WB_Point[], any Collection<WB_Point> and double[][];
  multiCreator.setN(100);//number of points, can be smaller than number of points in input. 
  multiCreator.setLevel(3);// subdivision level for cell spheres
  multiCreator.setCutoff(100);// maximum radius of cell
   multiCreator.setApprox(false);// approximate cells by point expansion or precise cells by sphere slicing
  multiCreator.setNumTracers(100);// random points per cell in approcimate mode
  multiCreator.setTraceStep(1);// step size for random points expansion
  cells=multiCreator.create();
  numcells=cells.length;
  
  render=new WB_Render(this);
}

void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  drawFaces();
  drawEdges();
}

void drawEdges(){
  
  stroke(0);
  for(int i=0;i<numcells;i++) {
    render.drawEdges(cells[i]);
  } 
}

void drawFaces(){
  
  noStroke();
  fill(255);
  for(int i=0;i<numcells;i++) {
    render.drawFaces(cells[i]);
  }   
}

