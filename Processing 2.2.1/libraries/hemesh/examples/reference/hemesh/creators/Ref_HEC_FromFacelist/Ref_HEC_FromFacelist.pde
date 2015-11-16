
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

  //Array of all vertices
  float[][] vertices=new float[121][3];
  int index = 0;
  for (int j = 0; j < 11; j++) {
    for (int i = 0; i < 11; i++) {
      vertices[index][0] =-300+ i * 60+(((i!=0)&&(i!=10))?random(-20, 20):0);
      vertices[index][1] =-300+j * 60+(((j!=0)&&(j!=10))?random(-20, 20):0);
      vertices[index][2] = sin(TWO_PI/20*i)*60+cos(TWO_PI/10*j)*60;
      index++;
    }
  }
  //Array of faces. Each face is an arry of vertex indices;
  index = 0;
  int[][] faces = new int[100][];
  for (int j = 0; j < 10; j++) {
    for (int i = 0; i < 10; i++) {
      faces[index]=new int[4];
      faces[index][0] = i + 11 * j;
      faces[index][1] = i + 1 + 11 * j;
      faces[index][2] = i + 1 + 11 * (j + 1);
      faces[index][3] = i + 11 * (j + 1);
      index++;
    }
  }

  //HEC_Facelist uses the vertices and the indexed faces to create a mesh with all connectivity.
  HEC_FromFacelist creator=new HEC_FromFacelist();
  creator.setVertices(vertices);
  //Alternatively vertices can be WB_Point[], any Collection<WB_Point>, double[][],
  //double[], float[][] and float[]
  creator.setFaces(faces);
  creator.setDuplicate(false);//check for duplicate points, by default true 
  creator.setCheckNormals(false);//check for face orientation consistency, can be slow
  mesh=new HE_Mesh(creator);
  HET_Diagnosis.validate(mesh);
  render=new WB_Render(this);
}

void draw() {
  background(120);
  lights();
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFaces(mesh);
  stroke(0);
  render.drawEdges(mesh);
}



