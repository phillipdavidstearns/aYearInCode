import wblut.processing.*;
import wblut.geom.*;
import wblut.math.*;
import java.util.List;

WB_GeometryFactory factory;
WB_Render2D render;


WB_Circle C1;
WB_Circle C2;
WB_Circle C3;
List<WB_Circle> circles;

void setup() {
  size(800, 800);
  factory=WB_GeometryFactory.instance();
  render=new WB_Render2D(this);
}

void create() {
  
  C1= factory.createCircleWithRadius(300, 400, 100);
  C2= factory.createCircleWithRadius(500, 400, 80);
  C3=factory.createCircleWithRadius(mouseX,mouseY,80);
  circles=factory.createCircleCCC(C1, C2,C3);
}

void draw() {
  background(255);
  create();
  noFill();
  stroke(0, 120);
  render.draw(C1);
  render.draw(C2);
  render.draw(C3);
  stroke(255, 0, 0,120);
   for (WB_Circle C:circles) {
      render.draw(C);
  } 
}

