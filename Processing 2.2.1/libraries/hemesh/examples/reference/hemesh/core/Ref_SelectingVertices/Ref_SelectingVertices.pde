import wblut.math.*;
import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_SelectRender3D selrender;
WB_Render3D render;

void setup() {
  size(800, 800, P3D);
  smooth(8);
  HEC_Dodecahedron creator=new HEC_Dodecahedron();
  creator.setEdge(200); 
  mesh=new HE_Mesh(creator); 
  mesh.splitFacesCenter();
  selrender=new WB_SelectRender3D(this);
  render=new WB_Render3D(this);
}

void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, 0);
  rotateY(frameCount*0.001);
  stroke(0);
  render.drawEdges(mesh);
  fill(255);
  noStroke();
  render.drawFaces(mesh);
  selrender.drawVertices(mesh, 16);
  noFill();
  stroke(255, 0, 0);
  render.drawVertex(selrender.getKey(), 16, mesh);
  println(selrender.getKey());
}

