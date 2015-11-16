import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_Render render;
WB_Line L;
HEM_Twist modifier;
void setup() {
  size(800, 800, P3D);
  createMesh();
  
  modifier=new HEM_Twist();
  
 
 L=new WB_Line(100,0,0,0,0,1);
  modifier.setTwistAxis(L);// Twist axis
  //you can also pass the line as two points:  modifier.setBendAxis(0,0,-200,1,0,-200)
  
  modifier.setAngleFactor(.51);// Angle per unit distance (in degrees) to the twist axis
  // points which are a distance d from the axis are rotated around it by an angle d*angleFactor;
  
  mesh.modify(modifier);
  
  render=new WB_Render(this);
}

void draw() {
  background(120);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 350, 0);
rotateY(.25*TWO_PI);
  fill(255);
  noStroke();
  render.drawFacesSmooth(mesh);
  stroke(0);
  //render.drawEdges(mesh);
  render.drawLine(L,800);
  
  
  createMesh();
  L=new WB_Line(0,0,0,0,cos(PI/800.0*mouseX),sin(PI/800.0*mouseX));
  modifier.setTwistAxis(L);
  modifier.setAngleFactor(mouseY*0.005);
  mesh.modify(modifier);
}


void createMesh(){
  HEC_Cylinder creator=new HEC_Cylinder();
  creator.setFacets(128).setSteps(32).setRadius(150).setHeight(400).setCap(false,false);
  mesh=new HE_Mesh(creator);

}

