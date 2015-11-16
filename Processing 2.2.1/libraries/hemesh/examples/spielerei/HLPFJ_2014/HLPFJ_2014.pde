import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;
import java.util.List;

WB_Triangulation2D tri;
WB_Render render;
int[][] triangles;
List<WB_Point> points;
List<WB_Point> tmppoints;
int n;
int m;
float[][] mov;
void setup() {
  size(1920, 1080, OPENGL);
  n=(int)random(200, 2000);
  m=(int)random(n/10, n/20);
  points=new ArrayList<WB_Point>(n);
  for (int i=0; i<n; i++) {
    points.add(new WB_Point(random(0, width), random(0, height)));
  } 
  createMovement();
  render=new WB_Render(this);  
  background(255);
  smooth(8);
}

void draw() {
  createTriangulation(frameCount);  
  for (int[] indices : triangles) {
    for (int j=0, k=2; j<3; k=j, j++) {
      if ((indices[j]>n+4)||(indices[k]>n+4)||(frameCount==1)) {
        if ((indices[j]>n+4)&&(indices[k]>n+4)) {
          float c=mov[(indices[j]-n-5)/4][4];        
          if (c<0) {
            stroke(255, 0, 0, 10);
          } else {
            stroke(255, 10);
          }
        } else {
          stroke(0, 10);
        }
        if (frameCount==1) {
          //stroke(0, 80);
        }
        WB_Point p=tmppoints.get(indices[j]);
        WB_Point q=tmppoints.get(indices[k]);
        line(p.xf(), p.yf(), q.xf(), q.yf());
      }
    }
  }
  for (WB_Point p : points) {
    p.addSelf(2, 0, 0);
    if (p.xd()>width+100) p.setX(p.xd()-width-200); 
    if (p.xd()<-100) p.setX(p.xd()+width+200);
  }
}
public void createTriangulation(float a)
{
  tmppoints=new ArrayList<WB_Point>();
  tmppoints.addAll(points);
  tmppoints.add(new WB_Point(-50, -50));
  tmppoints.add(new WB_Point(-50, height+50));
  tmppoints.add(new WB_Point(width+50, height+50));
  tmppoints.add(new WB_Point(width+50, -50));
  for (int i=0; i<m; i++) { 
    float la=a*mov[i][3];
    tmppoints.add(new WB_Point(mov[i][0]+cos(la)*mov[i][2], mov[i][1]+sin(la)*mov[i][2]));
    tmppoints.add(new WB_Point(mov[i][0]+cos(la+HALF_PI)*200, mov[i][1]+sin(la+HALF_PI)*mov[i][2]));
    tmppoints.add(new WB_Point(mov[i][0]+cos(la+PI)*mov[i][2], mov[i][1]+sin(la+PI)*mov[i][2]));
    tmppoints.add(new WB_Point(mov[i][0]+cos(la-HALF_PI)*mov[i][2], mov[i][1]+sin(la-HALF_PI)*mov[i][2]));
  }
  tri=WB_Triangulate.getTriangulation2D(tmppoints);
  triangles=tri.getTriangles();
}

void createMovement() {
  mov=new float[m][5];
  for (int i=0; i<m; i++) {
    mov[i][0]=random(0, width);
    mov[i][1]=random(0, height);
    mov[i][2]=random(10, 180);
    mov[i][3]=10*((random(100)<50)?-1:1);
    mov[i][4]=random(100);
  }
}

void mousePressed() {
  n=(int)random(200, 2000);
  m=(int)random(n/10, n/20);
  points=new ArrayList<WB_Point>(n);
  for (int i=0; i<n; i++) {
    points.add(new WB_Point(random(0, width), random(0, height)));
  } 
  createMovement();
  render=new WB_Render(this);  
  background(255);
  frameCount=0;
}

