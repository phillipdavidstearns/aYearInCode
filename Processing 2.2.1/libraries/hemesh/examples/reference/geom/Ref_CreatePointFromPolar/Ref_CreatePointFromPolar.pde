import wblut.core.*;
import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;
import wblut.math.*;

WB_GeometryFactory gf=WB_GeometryFactory.instance();
WB_Render2D render;


void setup(){
 size(1280,720);
  background(255);
 smooth(8);
 stroke(0,50);
 fill(255,50);
 render=new WB_Render2D(this);
  
}

void draw(){
  translate(width/2,height/2);
  float angle=TWO_PI/60.0*frameCount;
  float radius=frameCount;
  
  WB_Point p=gf.createPointFromPolar(angle,radius);
  ellipse(p.xf(),p.yf(),10,10);
  render.drawPoint(p);
  
  
}
