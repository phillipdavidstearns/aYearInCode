import wblut.math.*;
import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;


import processing.opengl.*;

HE_Mesh mesh;
WB_Render render;

int[][] targetIndex;
float[][][] dv;
float[][] origPos;
float[][] currentPos;
float[] origNoise;
void setup() {
  size(1280, 720, OPENGL);
  smooth(8);
  render=new WB_Render(this);
  importOBJ("data/base.obj");
  origPos=mesh.getVerticesAsFloat();
  origNoise=new float[origPos.length];
  dv=new float[4][][];
  targetIndex=new int[4][];
  importTarget("data/stomach-pregnant-incr.target", 0);
  importTarget("data/african-female-old.target", 1);
  importTarget("data/female-young-minmuscle-maxweight-maxcup-minfirmness.target", 2);
  importTarget("data/caucasian-male-baby.target", 3);
  create(0.0);
}

void create(float phase) {

  float noisescale=0.03;
  
  for (int i=0;i<origPos.length;i++) {
    origNoise[i]=constrain(-0.5+2*noise(noisescale*(origPos[i][0]+phase), noisescale*(origPos[i][1]+phase), noisescale*(origPos[i][2]+phase)),0,1);
  }
  currentPos=new float[origPos.length][3]; 
  for (int i=0;i<origPos.length;i++) {
    currentPos[i][0]=origPos[i][0];
    currentPos[i][1]=origPos[i][1];
    currentPos[i][2]=origPos[i][2];
  }
  float exag=1.25;
  for (int i=0;i<targetIndex[1].length;i++) {
    int n=targetIndex[1][i];
    float f=exag*((origNoise[n]<0.5)?1-2*origNoise[n]:0);//*origNoise[n]*(1-origNoise[n]);
    currentPos[n][0]+=f*dv[1][i][0];
    currentPos[n][1]+=f*dv[1][i][1];
    currentPos[n][2]+=f*dv[1][i][2];
  }
exag=1.1;
  for (int i=0;i<targetIndex[2].length;i++) {
    int n=targetIndex[2][i];
    float f=exag*((origNoise[n]<=0.5)?2*origNoise[n]:2-2*origNoise[n]);//(1.0-origNoise[n]);
    currentPos[n][0]+=f*dv[2][i][0];
    currentPos[n][1]+=f*dv[2][i][1];
    currentPos[n][2]+=f*dv[2][i][2];
  }
exag=1.25;
  for (int i=0;i<targetIndex[3].length;i++) {
    int n=targetIndex[3][i];
    float f=exag*((origNoise[n]>0.5)?2*origNoise[n]-1:0);//2*origNoise[n]*(1-origNoise[n]);


    currentPos[n][0]+=f*dv[3][i][0];
    currentPos[n][1]+=f*dv[3][i][1];
    currentPos[n][2]+=f*dv[3][i][2];
  }
exag=1.0;

  for (int i=0;i<targetIndex[0].length;i++) {
    int n=targetIndex[0][i];
     float f=exag*((origNoise[n]<=0.5)?2*origNoise[n]:2-2*origNoise[n]);//(1.0-origNoise[n]);
    currentPos[n][0]+=f*dv[0][i][0];
    currentPos[n][1]+=f*dv[0][i][1];
    currentPos[n][2]+=f*dv[0][i][2];
  }

  mesh.setVerticesFromFloat(currentPos);
}

void draw() {

  background(55);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(width/2, height/2, 100);
  //rotateY(mouseX*1.0f/width*TWO_PI);
  //rotateX(mouseY*1.0f/height*TWO_PI);

  noStroke();
  fill(255);
  pushMatrix();
  scale(25, -25, 25);
  render.drawFaces(mesh);

  popMatrix();
  pushMatrix();
  translate(-350, 0, 0);
  rotateY(HALF_PI);

  scale(25, -25, 25);
  render.drawFaces(mesh);
  popMatrix();
  pushMatrix();
  translate(350, 0, 0);
  rotateY(PI);
  scale(25, -25, 25);
 render.drawFaces(mesh);
  popMatrix();
  create(frameCount*0.125);
}

//import an OBJ file 
void importOBJ(String path) {

  //ArrayLists to store the vertex and face data, we keep track of the face count
  ArrayList<WB_Point> vertexList =  new ArrayList();
  ArrayList<int[]> faceList = new ArrayList();
  int faceCount = 0;
  int stopper=-1;
  //load OBJ file as an array of strings
  String objStrings[] = loadStrings(path);  
  for (int i = 0; i<objStrings.length; i++) {

    //split every line in parts divided by spaces  
    String[] parts =  splitTokens(objStrings[i]);

    //the first part indicates the kind of data that is in that line
    //v stands for vertex data
    if (parts[0].equals("v")) {
      float x1 = float(parts[1]);
      float y1 = float(parts[2]);
      float z1 = float(parts[3]);
      WB_Point pointLoc = new WB_Point(x1, y1, z1);
      vertexList.add(pointLoc);
    }

    if (parts[0].equals("g")) {
      stopper++;
      if (stopper>0) break;
    }

    //f stands for facelist data 
    //should work for non triangular faces 
    if (parts[0].equals("f")) {
      int[] tempFace = new int[parts.length-1];
      for (int j=0; j<parts.length-1; j++) {
        String[] num = split(parts[j+1], '/');
        tempFace[j] = int(num[0])-1;
      }
      faceList.add(tempFace);
      faceCount++;
    }
  }

  //the HEC_FromFacelist wants the face data as int[][] 
  int[][] faceArray = new int[faceCount][];
  for (int i=0; i<faceCount; i++) {
    int[] tempFace = faceList.get(i);
    faceArray[i] = tempFace;
  }
  //et voila... add to the creator
  HEC_FromFacelist creator=new HEC_FromFacelist();
  creator.setVertices(vertexList);
  creator.setFaces(faceArray);
  creator.setDuplicate(true);
  creator.setCheckNormals(false);


  mesh=new HE_Mesh(creator);
}

void importTarget(String path, int id) {
  String objStrings[] = loadStrings(path);  
  targetIndex[id]=new int[objStrings.length-19];
  dv[id]=new float[objStrings.length-19][3];
  for (int i = 0; i<objStrings.length-19; i++) {
    String[] parts =  splitTokens(objStrings[i+19]);
    targetIndex[id][i]=int(parts[0]);
    dv[id][i][0] = float(parts[1]);
    dv[id][i][1] = float(parts[2]);
    dv[id][i][2] = float(parts[3]);
  }
}

