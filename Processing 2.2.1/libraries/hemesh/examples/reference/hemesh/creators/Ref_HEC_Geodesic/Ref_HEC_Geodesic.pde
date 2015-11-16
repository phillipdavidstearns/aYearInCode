import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_Render render;
int B, C;
void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  B=1;
  C=1;
  HEC_Geodesic creator=new HEC_Geodesic();
  creator.setRadius(200); 
  // http://stackoverflow.com/questions/3031875/math-for-a-geodesic-sphere
  // N=B+C=number of divisions
  // B=N and C=0 or B=0 and C=N: class I
  // B=C=N/2: class II
  // Other: class III 
  creator.setB(B);
  creator.setC(C);

  // class I, II and III: TETRAHEDRON,OCTAHEDRON,ICOSAHEDRON
  // class II only: CUBE, DODECAHEDRON
  creator.setType(HEC_Geodesic.ICOSAHEDRON);
  mesh=new HE_Mesh(creator); 
  render=new WB_Render(this);
}

void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  text("B="+B+" C="+C,50,750);
  translate(400, 400, 100);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  stroke(0);
  render.drawEdges(mesh);
  noStroke();
  render.drawFaces(mesh);
}

void mousePressed() {
  if (mouseX<width/2) B++;
  if (mouseX>width/2) C++;

  HEC_Geodesic creator=new HEC_Geodesic();
  creator.setRadius(200); 
  creator.setB(B);
  creator.setC(C);
  creator.setType(HEC_Geodesic.ICOSAHEDRON);
  mesh=new HE_Mesh(creator);
}

