import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;


HE_Mesh mesh;
WB_Render render;

void setup() {
  size(800, 800, OPENGL);
  smooth(8);
  // Creates a mesh from a frame. A WB_Frame is a collection of points and a list of 
  // indexed connections.

  //Array of all points
  float[][] vertices=new float[441][3];
  int index = 0;
  for (int j = 0; j < 21; j++) {
    for (int i = 0; i < 21; i++) {
      vertices[index][0] =-400+ i * 40+(((i!=0)&&(i!=20))?random(-20, 20):0);
      vertices[index][1] =-400+j * 40+(((j!=0)&&(j!=20))?random(-20, 20):0);
      vertices[index][2] = sin(TWO_PI/20*i)*40+cos(TWO_PI/10*j)*40;
      index++;
    }
  }

  // WB_Frame frame=new WB_Frame(vertices);
  // alternatively vertices can be WB_Point[], WB_XYZ[],any Collection<WB_XYZ>, double[][],
  // float[][] or int[][]. 

  //For more control add the nodes one by one, a value can be given to each node for future use.
  WB_Frame frame=new WB_Frame();
  index=0;
  for (int j = 0; j < 21; j++) {
    for (int i = 0; i < 21; i++) {
       frame.addNode(vertices[index][0],vertices[index][1],vertices[index][2],(i+1)*0.050);
       index++;
    }
  }
      
  //adding random connections to the frame
  for (int j = 0; j < 20; j++) {
    for (int i = 0; i < 20; i++) {
      if (random(100)>30) frame.addStrut(i+21*j, i+1+21*j);
      if (random(100)>30) frame.addStrut(i+21*j, i+21*(j+1));
    }
  }
  // If the connections are known in advance these can be given as parameter as int[][]. The
  // second index gives index of first and second point of connection in the points array.
  // frame=new WB_Frame(vertices, connections);
  

  HEC_FromFrame creator=new HEC_FromFrame();
  creator.setFrame(frame);
  //alternatively you can specify a HE_Mesh instead of a WB_Frame.
  creator.setStrutRadius(6);// strut radius
  creator.setStrutFacets(6);// number of faces in the struts, min 3, max whatever blows up the CPU
  creator.setAngleOffset(0.25);// rotate the struts by a fraction of a facet. 0 is no rotation, 1 is a rotation over a full facet. More noticeable for low number of facets.
  creator.setMinimumBalljointAngle(TWO_PI/3.0);//Threshold angle to include sphere in joint.
  creator.setMaximumStrutLength(30);//divide strut into equal parts if larger than maximum length.
  creator.setCap(true); //cap open endpoints of struts?
  creator.setTaper(true);// allow struts to have different radii at each end?
  creator.setCreateIsolatedNodes(false);// create spheres for isolated points?
  creator.setUseNodeValues(true);// use the value of the WB_Node as scaling factor, only useful if the frame was created using addNode().
  mesh=new HE_Mesh(creator);
HET_Diagnosis.validate(mesh);
  render=new WB_Render(this);
}

void draw() {
  background(120);
  lights();
  translate(400, 400, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFaces(mesh);
  stroke(0);
  render.drawEdges(mesh);
}



