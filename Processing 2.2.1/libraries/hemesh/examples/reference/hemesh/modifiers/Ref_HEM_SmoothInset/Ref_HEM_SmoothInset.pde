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
  createMesh();
  
  HEM_SmoothInset modifier=new HEM_SmoothInset();
  modifier.setLevel(2);// level of recursive division
  modifier.setOffset(10);// distance between inset face and original faces (should be > 0)
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
   fill(255,0,0);
  noStroke();
  render.drawFacesWithInternalLabel(1,mesh);//HEM_SmoothInset sets all inset faces to label 1
  fill(255,100);
 render.drawFacesWithInternalLabel(2,mesh);//HEM_SmoothInset sets all "wall" faces to label 2
  
  stroke(0);
  render.drawEdges(mesh);
}


void createMesh(){
  HEC_Cube creator=new HEC_Cube(300,5,5,5);
  mesh=new HE_Mesh(creator); 
   
  mesh.modify(new HEM_Diagrid());
 
}

