import wblut.math.*;
import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_Render3D render;

void setup() {
  size(800, 800, P3D);
  smooth(8);
  HEC_Dodecahedron creator=new HEC_Dodecahedron();
  creator.setEdge(160); 
  mesh=new HE_Mesh(creator); 

  mesh.modify( new HEM_ChamferEdges().setDistance(25));
  mesh.splitFacesTri();
  mesh.splitFacesMidEdge();
  mesh.splitFacesMidEdge();
  mesh.triangulate();
  HE_FaceIterator fitr=new HE_FaceIterator(mesh);
  colorMode(HSB);
  while (fitr.hasNext ()) {
    fitr.next().setColor(color((int)random(4.0)*10, 255, 255));
  }

  HE_VertexIterator vitr=new HE_VertexIterator(mesh);
  colorMode(HSB);
  while (vitr.hasNext ()) {
    vitr.next().setColor(color((int)random(4.0)*10, 255, 255));
  }
  colorMode(RGB);
  HET_Export.saveToWRLWithFaceColor(mesh, sketchPath("meshes1"),"testfc");
  HET_Export.saveToWRLWithVertexColor(mesh, sketchPath("meshes2"),"testvc");
  HET_Export.saveToWRL(mesh, sketchPath("meshes3"),"test");
  HET_Export.saveToPLY(mesh, sketchPath("meshes4"),"test");
  HET_Export.saveToSTL(mesh, sketchPath("meshes5"),"test");
  HET_Export.saveToOBJ(mesh, sketchPath("meshes6"),"test");
  HET_Export.saveToOBJWithFaceColor(mesh, sketchPath("meshes7"),"testfc");
  HET_Export.saveToOBJWithVertexColor(mesh, sketchPath("meshes8"),"testvc");
  HET_Export.saveToPLYWithVertexColor(mesh, sketchPath("meshes9"),"testvc");
  HET_Export.saveToPLYWithFaceColor(mesh,sketchPath("meshes10"),"testfc");
  render=new WB_Render3D(this);
}

void draw() {
  background(60);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, 100);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  stroke(0);
  render.drawEdges(mesh);
  noStroke();
  render.drawFacesFC(mesh);
}

