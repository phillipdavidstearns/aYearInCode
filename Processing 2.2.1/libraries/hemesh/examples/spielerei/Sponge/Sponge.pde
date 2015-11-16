import wblut.math.*;
import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;

HE_Mesh mesh;
WB_Render3D render;
WB_Point[] points;
int num;

void setup() {
  size(800, 800, P3D);
  smooth(8);
  WB_RandomOnSphere rs=new WB_RandomOnSphere();
  HEC_ConvexHull creator=new HEC_ConvexHull();
  num=50;
  points =new WB_Point[num];
  for (int i=0; i<num; i++) {
    points[i]=rs.nextPoint().mulSelf(300.0);
  }
  creator.setPoints(points);
  creator.setN(num);  
  mesh=new HE_Mesh(creator); 
  mesh=new HE_Mesh(new HEC_Dual(mesh));
  HEM_Extrude ext=new HEM_Extrude().setChamfer(25).setRelative(false);
  mesh.modify(ext);
  HE_Selection sel=ext.extruded;
  ext=new HEM_Extrude().setDistance(-40);
  mesh.modifySelected(ext, sel);
  mesh.smooth(2);
  render=new WB_Render3D(this);
}

void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  stroke(0);
  render.drawEdges(mesh);
  noStroke();
  render.drawFaces(mesh);
}

void mousePressed(){
   WB_RandomOnSphere rs=new WB_RandomOnSphere();
  HEC_ConvexHull creator=new HEC_ConvexHull();
  num=50;
  points =new WB_Point[num];
  for (int i=0; i<num; i++) {
    points[i]=rs.nextPoint().mulSelf(300.0);
  }
  creator.setPoints(points);
  creator.setN(num);  
  mesh=new HE_Mesh(creator); 
  mesh=new HE_Mesh(new HEC_Dual(mesh));
  HEM_Extrude ext=new HEM_Extrude().setChamfer(25).setRelative(false);
  mesh.modify(ext);
  HE_Selection sel=ext.extruded;
  ext=new HEM_Extrude().setDistance(-40);
  mesh.modifySelected(ext, sel);
  mesh.smooth(2);
}


