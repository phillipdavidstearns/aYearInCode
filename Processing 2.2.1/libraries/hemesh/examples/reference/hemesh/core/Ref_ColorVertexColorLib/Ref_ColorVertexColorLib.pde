import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;
import colorlib.webservices.*;
import colorlib.tools.*;
import colorlib.*;

HE_Mesh mesh;
WB_Render render;

void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  mesh=new HE_Mesh(new HEC_Torus(80, 200, 12, 24).setTwist(12).setZAxis(1, 1, 1)); 
  mesh.modify(new HEM_Crocodile().setDistance(100).setChamfer(0.25));
  mesh.smooth(2);
  assignColorsAlongZAxis();
  render=new WB_Render(this);
}

void assignColorsAlongZAxis() {
  color[] colors = new color[ 2 ];
  colors[0] = color( 255, 0, 255 );
  colors[1] = color( 255, 255, 0 );

  Palette palette = new Gradient( this ).addColors( colors ).setSteps(64 );
  WB_AABB box=mesh.getAABB();
  float zmin=(float)box.getMin(2);
  float zmax=(float)box.getMax(2);
  int numOfColors= palette.numSwatches();
  HE_VertexIterator vitr=mesh.vItr();
  HE_Vertex v;
  while (vitr.hasNext ()) {
    v=vitr.next();
    
    int colorIndex= (int) (numOfColors*(v.zf()-zmin)/(zmax-zmin));
    if (colorIndex==numOfColors) colorIndex=numOfColors-1;
    v.setLabel(colorIndex);
  }
  HET_Texture.setVertexColorFromPalette(mesh, palette);
}

void draw() {
  background(120);
  noLights();
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFacesVC(mesh);
  stroke(0);
  render.drawEdges(mesh);
}

