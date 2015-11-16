import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

WB_Render2D render;
ArrayList<WB_Point> points;
WB_Triangulation2D triangulation;

public void setup() {
    size (800,800,P2D);
    smooth(8);
    background(255);
    render = new WB_Render2D(this);
    points = new ArrayList<WB_Point>();
    float x, y;
    float r = 250;
    for (int i =0; i < 500; i++){
        x = width/2 + random(-r, r);
        y = height/2 + random(-r, r);
        WB_Point newPoint = new WB_Point (x, y);      
        points.add(newPoint);
    }
    triangulation = WB_Triangulate.getTriangulation2D(points);
}

public void draw() {
    background(255);
    for(WB_Point p : points){
      render.drawPoint(p, 2);
    }
    render.drawTriangulationEdges(triangulation, points) ;
}
