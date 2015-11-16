import wblut.processing.*;
import wblut.geom.*;
import wblut.core.*;
import wblut.math.*;
import java.util.List;


List<WB_Point> points;
List<WB_Point> boundary;
List<WB_VoronoiCell2D> voronoiXY;

WB_Render3D render;
WB_GeometryFactory gf=WB_GeometryFactory.instance();
WB_Context2D XY=gf.createEmbeddedPlane();

 
void setup() {
  size(800, 800, OPENGL);
  smooth(8);
render= new WB_Render3D(this);
  
  points=new ArrayList<WB_Point>();
  // add points to collection
  for (int i=0;i<10;i++) {
    for (int j=0;j<10;j++) {
    points.add(new WB_Point(-270+i*60, -270+j*60,2));
    }  
}
  boundary=new ArrayList<WB_Point>();
  boundary.add(new WB_Point(-300,-300));
  boundary.add(new WB_Point(-300,300));
  boundary.add(new WB_Point(300,300));
  boundary.add(new WB_Point(300,-300));
  
  voronoiXY= WB_Voronoi.getClippedVoronoi2D(points,boundary,XY);
  noFill();
}

void draw() {
  background(255);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  strokeWeight(2);
  render.drawPoints(points,1); 
  strokeWeight(1);
  for (WB_VoronoiCell2D vor: voronoiXY) {
    
    render.drawPolygonEdges(vor.getPolygon());
  }
}


void mousePressed(){
 for (WB_Point p:points) {
    
    p.addSelf(random(-5,5),random(-5,5),0);

    
} 
   voronoiXY= WB_Voronoi.getClippedVoronoi2D(points,boundary,XY);
}
