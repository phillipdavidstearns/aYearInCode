import wblut.processing.*;
import wblut.geom.*;

WB_GeometryFactory factory;
WB_Render2D render;

WB_Point o;
WB_Point p;
WB_Point q;
WB_Circle C;
void setup() {
  size(800, 800);
  factory=WB_GeometryFactory.instance();
  render=new WB_Render2D(this);
}

void create() {
  o= factory.createPoint(320, 400);
  p=factory.createPoint(480, 400);
  q= factory.createPoint( mouseX, mouseY);
  C=factory.createCirclePPP(o, p, q);
}

void draw() {
  background(255);
  create();
  noFill();
  stroke(0, 120);
  render.drawPoint(o, 10);
  render.drawPoint(p, 10);
  render.drawPoint(q, 10);
  stroke(255, 0, 0, 120);
  render.draw(C);
}

