import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;
import java.util.*;

HE_Mesh mesh;
ArrayList<HE_Mesh> meshes;
WB_Render render;
WB_Point[][] environments;
void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  mesh=new HE_Mesh(new HEC_Geodesic().setB(5).setC(3).setRadius(300));
  meshes=new ArrayList<HE_Mesh>();
  meshes.add(new HE_Mesh(new HEC_Geodesic().setB(5).setC(3).setRadius(300)));
  render=new WB_Render(this);
  collectNeighbors();
  for (int i=0;i<5;i++) {
    for (int r=0;r<20;r++) average();
    meshes.add(mesh.get());
  }
  mesh.subdivide(new HES_CatmullClark(),2);
  smooth();
}

void draw() {
  background(55);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(width/2, height/2, 0);


  for (int i=0;i<meshes.size();i++) {
    stroke(200, 25);
    render.drawEdges(meshes.get(i));
  }
  noStroke();
blendMode(ADD);
  render.drawFacesSmooth(mesh);
noLoop();
}

void collectNeighbors() {
  int nv=mesh.getNumberOfVertices();
  environments=new WB_Point[nv][];
  WB_Point[] vertices=mesh.getVerticesAsPoint();
  Iterator<HE_Vertex> vItr=mesh.vItr();
  int i=0;
  while (vItr.hasNext ()) {
    if (random(100)<2) {
      environments[i]=new WB_Point[1];
      environments[i][0]=vItr.next().getPoint();
    }
    else if (random(100)<8) {
      WB_Point[] points=vItr.next().getNeighborsAsPoints();
      environments[i]=new WB_Point[points.length+1];
      for (int j=0;j<points.length;j++) {
        environments[i][j]=points[j];
      }
      environments[i][points.length]=vertices[(int)random(nv-0.000001)];
    }
    else {

      environments[i]=vItr.next().getNeighborsAsPoints();
    }

    i++;
  }
}

void mousePressed() {
  mesh=new HE_Mesh(new HEC_Geodesic().setB(5).setC(3).setRadius(300));
  meshes=new ArrayList<HE_Mesh>();
  meshes.add(new HE_Mesh(new HEC_Geodesic().setB(5).setC(3).setRadius(300)));
  render=new WB_Render(this);
  collectNeighbors();
  for (int i=0;i<5;i++) {
    for (int r=0;r<20;r++) average();
    meshes.add(mesh.get());
    loop();
  }
  mesh.subdivide(new HES_CatmullClark(),2);
}

void keyPressed() {
  saveFrame("collapse.png");
}

void average() {
  int nv=mesh.getNumberOfVertices();
  WB_Point[] newPos=new WB_Point[nv];
  for (int i=0;i<nv;i++) {
    int nn=environments[i].length;
    newPos[i]=new WB_Point();
    for (int j=0;j<nn;j++) {
      newPos[i]._addSelf(environments[i][j]);
    }
    newPos[i]._mulSelf(1.0/nn);
  }  

  Iterator<HE_Vertex> vItr=mesh.vItr();
  vItr=mesh.vItr();  
  int i=0;
  while (vItr.hasNext ()) {
    vItr.next()._set(newPos[i]); 
    i++;
  }
}

