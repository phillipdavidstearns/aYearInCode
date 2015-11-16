import wblut.processing.*;
import wblut.geom.*;
import java.util.List;

WB_GeometryFactory factory;
WB_Render2D render;

WB_Line L1;
WB_Line L2;
WB_Point p;
List<WB_Circle> circles;
 WB_Predicates pred=new WB_Predicates();
void setup() {
  size(800, 800);
  factory=WB_GeometryFactory.instance();
  render=new WB_Render2D(this);
}

void create() {
  L1= factory.createLineWithDirection( width/2, height/2, 0,1);
  L2= factory.createLineWithDirection( width/2, height/2, 1, 0);
  p= factory.createPoint( mouseX,mouseY);
circles=factory.createCirclePLL(p, L1, L2);

}

void draw() {
  background(255);
  create();
  noFill();
  stroke(0, 120);
  render.drawLine(L1, width);
  render.drawLine(L2, width);
  render.drawPoint(p, 5);
  stroke(255,0,0, 120);
 
  for (WB_Circle C:circles) {
    render.draw(C);
  }

}

