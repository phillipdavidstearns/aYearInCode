import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_Render render;
HEM_ChamferCorners modifier;
void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  createMesh();
  
  // Unpredictable results with concave meshes!
  modifier=new HEM_ChamferCorners();
  modifier.setDistance(50);  
  
  mesh.modify(modifier);
  
  render=new WB_Render(this);
}

void draw() {
  background(120);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400,400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  fill(255);
  noStroke();
  render.drawFaces(mesh);
  stroke(0);
  render.drawEdges(mesh);
  //recreate mesh and modifier
  createMesh();
  modifier.setDistance(mouseX/4.0); 
  mesh.modify(modifier);

}


void createMesh(){
  HEC_Cube creator=new HEC_Cube(300,5,5,5);
  mesh=new HE_Mesh(creator); 
}

