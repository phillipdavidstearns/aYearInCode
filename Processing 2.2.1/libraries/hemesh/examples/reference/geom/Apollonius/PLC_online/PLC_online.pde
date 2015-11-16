import wblut.processing.*;
import wblut.geom.*;
import wblut.math.*;
import java.util.List;

WB_GeometryFactory factory;
WB_Render2D render;

WB_Point p;
WB_Line L;
WB_Circle C;
List<WB_Circle> circles;

void setup() {
  size(800, 800);
  factory=WB_GeometryFactory.instance();
  render=new WB_Render2D(this);
}

void create() {
  p= factory.createPoint(width/2, height/2);
  L= factory.createLineWithDirection(width/2, height/2, 1, 0);
  C= factory.createCircleWithRadius( mouseX, mouseY, 100);
  circles=factory.createCirclePLC(p, L, C);
}

void draw() {
  background(255);
  create();
  noFill();
  strokeWeight(1);
  stroke(0, 120);
  render.drawPoint(p, 5);
  render.drawLine(L, 2*width);
  render.draw(C);
  stroke(255, 0, 0, 120);
  for (WB_Circle C:circles) {
    render.draw(C);
  }
}

