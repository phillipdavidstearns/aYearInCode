import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_DynamicMesh dynMesh;
WB_Render render;
HEM_Lattice lattice;

void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  HE_Mesh cube=new HE_Mesh(new HEC_Cube().setEdge(600));  
  //a dynamic mesh is called with the base mesh as argument
  dynMesh = new HE_DynamicMesh(cube);

  //subdividors can be added directly as parameter, to be applied more than once it should be added again
  dynMesh.add(new HES_CatmullClark());

  //modifiers can also be added directly as parameter
  dynMesh.add(new HEM_Extrude().setDistance(0).setChamfer(0.5));
  //However adding implicitely is not useful as the parameters can no longer be changed.
  //It is better to apply these kind of fixed modifiers to the base mesh before passing it through to
  //the HE_DynamicMesh. This way their overhead is avoided each update().

  //Modifiers or subdividors that are to be dynamic should be called as referenced objects.
  lattice=new HEM_Lattice().setWidth(10).setDepth(5);
  dynMesh.add(lattice);
  //All modifiers and subdividors are applied on a call to update()
  dynMesh.update();

  render=new WB_Render(this);
}

void draw() {
  background(255);
  lights();
  translate(400, 400);
  float d=-80.0+mouseY*160.0/height;
  float w=1.0+mouseX*60.0/width;
  lattice.setWidth(w).setDepth(d);
  dynMesh.update();
  noStroke();
  fill(255);
  render.drawFaces(dynMesh);
  stroke(0);
  render.drawEdges(dynMesh);
}

