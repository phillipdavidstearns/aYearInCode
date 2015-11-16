import wblut.math.*;
import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;
import java.util.List;

WB_FaceListMesh flm;
HE_Mesh mesh, mesh2;
WB_Render3D render;
WB_GeometryFactory factory;
WB_Geodesic geo;
List<HE_Path> paths;
WB_MeshGraph graph;
int currentSource;
List<PathFollower> followers;
PImage glowKernel;
float ax, ay;
void setup() {
  size(1280, 720, OPENGL);
  smooth(8);
  render= new WB_Render3D(this);
  factory=WB_GeometryFactory.instance();
  ArrayList<WB_Point> points=new ArrayList<WB_Point>(); 
  geo=new WB_Geodesic(250.0, 2, 2, WB_Geodesic.ICOSAHEDRON);
  flm=geo.getMesh();
  mesh=new HE_Mesh(geo.getMesh());
  mesh.modify(new HEM_Noise().setDistance(50));
  mesh.smooth(2);
  mesh2=new HE_Mesh(new HEC_Dual(mesh));
  graph=new WB_MeshGraph(mesh);
  create();
}

void create() {
  paths=new ArrayList<HE_Path>();
  followers=new ArrayList<PathFollower>();
  for (int i=0; i<mesh.getNumberOfVertices (); i++) {
    if (i!=currentSource) {
      HE_Path p=createPath(i);
      if (p.getPathLength()>20)paths.add(p);
    }
  }
  for (int i=0; i<mesh.getNumberOfVertices (); i++) {
    if (i!=currentSource) {
      HE_Path p=createPath(i);
      if (p.getPathLength()>500)paths.add(p);
    }
  }
  for (HE_Path p : paths) {
    followers.add(new PathFollower(p, 1.0));
  }


  float glowKernelWidth=4f;// glow core size parameter
  float glowKernelDecayPower=2f;// glow core decay power
  int reqGlowKernelSize =5*(int)pow(100f*glowKernelWidth, 1f/glowKernelDecayPower);// required image size to accomodate the glow kernel
  glowKernel=createImage(reqGlowKernelSize, reqGlowKernelSize, RGB);
  for (int i=0; i <  reqGlowKernelSize; i++) {
    for (int j=0; j <  reqGlowKernelSize; j++) {
      float r=dist(i, j, reqGlowKernelSize/2, reqGlowKernelSize/2);
      float bri=255.999999f*glowKernelWidth/(glowKernelWidth+pow(r, glowKernelDecayPower));// radial symmetric decreasing function
      glowKernel.pixels[i+reqGlowKernelSize*j] = color(bri, bri);
    }
  }
}

void draw() {
  background(20);
  directionalLight(255, 255, 255, 1, 1, -1);

  translate(width/2, height/2, 0);
  ay=frameCount*0.002;
  rotateY(ay);
  ax=mouseY*1.0f/height*TWO_PI;
  // rotateX(ax);
  fill(255);
  noStroke();

  stroke(255, 50);
  render.drawEdges(mesh2);   
  hint(DISABLE_DEPTH_MASK);
  blendMode(ADD);
  for (int r=0; r<3; r++) {
    for (PathFollower pf : followers) {   
      WB_Point p=pf.getPos();
      pushMatrix();
      translate(p.xf(), p.yf(), p.zf());

      rotateY(-ay);
      scale(0.5*(float)(1.1-pf.currentPosition/pf.length));
      translate(-glowKernel.width/2, -glowKernel.height/2);
      tint(50+(float)(pf.currentPosition/pf.length)*205);
      image(glowKernel, 0, 0);
      popMatrix();
      pf.update(0.20+0.25*cos(frameCount*0.2));
    }
  }
  hint(ENABLE_DEPTH_MASK); 
  blendMode(BLEND);
}


HE_Path createPath(int i) {
  int[] shortestpath=graph.getShortestPath(currentSource, i);
  return mesh.createPathFromIndices(shortestpath, false);
}

void keyPressed() {
  currentSource=(currentSource+1)%mesh.getNumberOfVertices();
  create();
}

class PathFollower {

  double length;
  double currentPosition;
  double[] incLengths;
  List<HE_Vertex> vertices;
  double numSteps;
  int currentIndex=0;
  double speed;
  WB_Segment currentSegment;

  PathFollower(HE_Path path, double speed) {
    length=path.getPathLength();
    numSteps=path.getPathOrder();
    incLengths=path.getPathIncLengths();
    vertices=path.getPathVertices();

    currentIndex=0;
    currentPosition=random((float)length);
    this.speed=speed;
    while (currentPosition>incLengths[currentIndex+1]) {
      currentIndex++;
    }
  }

  void update(double t) {
    currentPosition+=t*speed;
    if (currentPosition>=length) {
      reset();
      return;
    }

    while (currentPosition>incLengths[currentIndex+1]) {
      currentIndex++;
    }
  }

  WB_Point getPos() {
    if (vertices.size()==1) {
      return vertices.get(0).getPoint();
    } else {
      double d=currentPosition-incLengths[currentIndex];
      double cl=incLengths[currentIndex+1]-incLengths[currentIndex];
      double f=d/cl;
      return factory.createInterpolatedPoint(vertices.get(currentIndex), vertices.get(currentIndex+1), f);
    }
  }

  void reset() {
    currentIndex=0;
    currentPosition=0.0;
  }
}

