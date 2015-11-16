import wblut.core.*;
import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;
import wblut.math.*;

WB_GeometryFactory gf=WB_GeometryFactory.instance();
WB_Render2D render;
WB_Circle C;

void setup() {
  size(1280, 720);
  background(255);
  smooth(8);
  stroke(0, 50);

  render=new WB_Render2D(this);
  C=gf.createCircleWithRadius(0, 0, 200);
}

void draw() {
  translate(width/2, height/2);
  if (frameCount==1) {
    pushStyle();
    stroke(255, 0, 0);
    render.drawCircle(C);
    popStyle();
  }
  WB_Point p;
  float x=(frameCount-1);
  for (int i=0; i<201; i++) {

    p=gf.createPoint(x, (i-100)*20);
    p=gf.createInversionPoint(p, C);
    if (p!=null)render.drawPoint(p);
    p=gf.createPoint(-x, (i-100)*20);
    p=gf.createInversionPoint(p, C);
    if (p!=null)render.drawPoint(p);
  }
}

