import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

import processing.opengl.*;

HE_Mesh mesh;
WB_Render render;
PImage img;
int MODE=0;

void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  textureMode(NORMAL);
  create();
  img=loadImage("texture.jpg");
  render=new WB_Render(this);
}

void create() {
  switch(MODE) {
  case 0:
    float[][] values=new float[21][21];
    for (int j = 0; j < 21; j++) {
      for (int i = 0; i < 21; i++) {
        values[i][j]=200*noise(0.35*i, 0.35*j);
      }
    }
    HEC_Grid creator0=new HEC_Grid();
    creator0.setU(20);
    creator0.setV(20);
    creator0.setUSize(500);
    creator0.setVSize(500);
    creator0.setWValues(values);
    mesh=new HE_Mesh(creator0);
    break;
  case 1:
    HEC_Cylinder creator1=new HEC_Cylinder();
    creator1.setRadius(150, 150); 
    creator1.setHeight(400);
    creator1.setFacets(14).setSteps(1);
    creator1.setCap(true, true);
    mesh=new HE_Mesh(creator1); 
    break;
  case 2:
    HEC_Cone creator2=new HEC_Cone();
    creator2.setRadius(150); 
    creator2.setHeight(400);
    creator2.setFacets(14).setSteps(5);
    creator2.setCap(true);
    mesh=new HE_Mesh(creator2); 
    break;
  case 3:
    mesh=new HE_Mesh(new HEC_Torus(80, 200, 6, 12).setTwist(4)); 
    break;
  case 4:
    mesh=new HE_Mesh(new HEC_Sphere().setRadius(200).setUFacets(16).setVFacets(8));
    break;
  case 5:
    HEC_UVParametric creator5=new  HEC_UVParametric();
    creator5.setUVSteps(40, 40);
    creator5.setRadius(100); 
    creator5.setUWrap(true); 
    creator5.setVWrap(true); 
    creator5.setEvaluator(new UVFunction());
    mesh=new HE_Mesh(creator5);
    break;
  case 6:
    HEC_SuperDuper creator6=new HEC_SuperDuper();
    creator6.setU(64);
    creator6.setV(8);
    creator6.setUWrap(true);
    creator6.setVWrap(false); 
    creator6.setRadius(50);
    creator6.setDonutParameters(0, 10, 10, 10, 5, 6, 12, 12, 3, 1);
    mesh=new HE_Mesh(creator6); 
    break;
  }
}

void draw() {
  background(120);
  lights();
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFaces(mesh, img);
  stroke(0);
  render.drawEdges(mesh);
}

void mousePressed(){
 MODE=(MODE+1)%7;
create(); 
}

class UVFunction implements WB_Function2D<WB_Point> {
  WB_Point f(double u, double v) {
    double pi23=2*Math.PI/3;
    double ua=Math.PI*2*u;
    double va=Math.PI*2*v;
    double sqrt2=Math.sqrt(2.0d);
    double px = Math.sin(ua) / Math.abs(sqrt2+ Math.cos(va));
    double py = Math.sin(ua+pi23) / Math.abs(sqrt2 +Math.cos(va + pi23));
    double pz = Math.cos(ua-pi23) / Math.abs(sqrt2 +Math.cos(va - pi23));
    return new WB_Point(px, py, pz);
  }
}

