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
  // Brute force approach to 3D Voronoi inside a container mesh. Very inefficient, useful
  // for prototyping tens to hundreds of points, painfully slow
  // for more...
  
  //create a container mesh
  container=new HE_Mesh(new HEC_Geodesic().setRadius(250));
  
  //generate points
  numpoints=100;
  points=new float[numpoints][3];
  for(int i=0;i<numpoints;i++) {
    points[i][0]=random(-250,250);
    points[i][1]=random(-250,250);
    points[i][2]=random(-250,250);
  }
  
  // generate voronoi cells
  HEMC_VoronoiCells multiCreator=new HEMC_VoronoiCells();
  multiCreator.setPoints(points);
  // alternatively points can be WB_Point[], any Collection<WB_Point> and double[][];
  multiCreator.setN(numpoints);//number of points, can be smaller than number of points in input. 
  multiCreator.setContainer(container);// cutoff mesh for the voronoi cells, complex meshes increase the generation time
  multiCreator.setOffset(5);// offset of the bisector cutting planes, sides of the voronoi cells will be separated by twice this distance
  multiCreator.setSurface(false);// is container mesh a volume (false) or a surface (true)
  multiCreator.setCreateSkin(false);// create the combined outer skin of the cells as an additional mesh? This mesh is the last in the returned array.

  // can help speed up things for complex container and give more stable results. Creates the voronoi cells for a simple box and
  // uses this to reduce the number of slicing operations on the actual container. Not fully tested yet.
  
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

