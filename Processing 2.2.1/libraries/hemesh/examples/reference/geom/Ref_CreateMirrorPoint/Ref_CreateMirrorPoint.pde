import wblut.core.*;
import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;
import wblut.math.*;

WB_GeometryFactory gf=WB_GeometryFactory.instance();
WB_Render2D render;
WB_Line L;

void setup() {
  size(1280, 720);
  background(255);
  smooth(8);
  stroke(0, 50);
  render=new WB_Render2D(this);
  L=gf.createLineWithDirection(0,0,cos(PI/6),sin(PI/6));
 
}

void draw() {
  translate(width/2, height/2);
   if(frameCount==1){
     pushStyle();
     stroke(255,0,0);
     render.drawLine(L,400);
     popStyle();
   }
  WB_Point p;
  float x=(frameCount-1);
  for (int i=0; i<201; i++) {
    p=gf.createPoint(x,(i-100)*2);
    render.drawPoint(p);
    p=gf.createMirrorPoint(p,L);
    render.drawPoint(p);
     p=gf.createPoint(-x,(i-100)*2);
    render.drawPoint(p);
    p=gf.createMirrorPoint(p,L);
    render.drawPoint(p);
  }
}

