import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;

WB_Frame frame;
HE_Mesh mesh;
HE_Mesh container;
WB_Render render;
Node node;
Node newNode;
int numNodes;
ArrayList<Node> nodes; 
float ay;
float ax;
float scale;
float startradius;
float minradius;
HEC_FromFrame ffc;

void setup() {
  size(800,800, OPENGL);
  smooth(8);
  background(0);
 reset();
 
}


void reset(){
   startradius = 60;
  minradius=startradius;
  container=new HE_Mesh(new HEC_Box(400, 400, 400, 1, 1, 1));
 container.modify(new HEM_Extrude().setDistance(400));
  firstNode();
  numNodes= 50;

 growToNumNodes(1, container);
  render=new WB_Render(this);
  createMesh();
   scale=.5;
}

void mouseReleased() {
  freeAllNodes();
  int nn=nodes.size();
  int trial=0;
  do{
  addNodes((random(100.0)<50), .95,container);
  trial++;
  }while((nodes.size()==nn)&&(trial<10));
 if(trial<10) createMesh();
}

void draw() {
  background(0);
  directionalLight(255, 255, 255, 1, 1, -1);
  directionalLight(127, 127, 127, -1, -1, 1);
  translate(height/2, height/2, 0);
  ay=mouseX*1.0/width*TWO_PI-PI;
  ax=-mouseY*1.0/height*TWO_PI-PI;
  scale(scale);
  rotateY(ay);
  rotateX(ax);
  noStroke();
  fill(255);
   render.drawFaces(mesh);
  stroke(255, 0, 0);
  render.drawEdges(container);
  stroke(0);
  render.drawEdges(mesh);
}



void keyPressed() {
if (key=='+') {
    scale*=1.1;
  }
  else if (key=='-') {
    scale/=1.1;
  } 
  else if (key=='s') {
   frame.smoothBiNodes();
    createMesh();
  }
  else {
   reset();
  }
}

int freeNodes() {
  int n= 0;
  for  (Node currentNode:nodes) {
    if (!currentNode.isParent) {
      currentNode.active=true;
      n++;
    }
  }
  return n;
}

int freeAllNodes() {
  int n= 0;
  for  (Node currentNode:nodes) {
    currentNode.active=true;
    n++;
  }
  return n;
}

void firstNode() {
  frame=new WB_Frame();
  node = new Node(new WB_Point(random(-200,200),random(-200,200),random(-200,200)),1.0, null, 0, 0);
  nodes= new ArrayList<Node>(numNodes); 
  nodes.add(node);
  frame.addNode(node.pos,1.0);
}

void growToNumNodes(float rf, HE_Mesh container) {
  int ni=nodes.size();
  int no=nodes.size()+1;
  while ( (ni<no)&&(no< numNodes)) {
    ni=nodes.size();
    addNodes(false, rf, container);
    no=nodes.size();
  }
}

void addNodes(boolean noSiblings, float rf, HE_Mesh container) {
  int n=nodes.size();
  for (int i=0;i<n;i++) {
    Node currentNode=nodes.get(i);
    if ((currentNode.active)&&((!noSiblings)||(!currentNode.isParent))) {
      newNode=findNeighbor(currentNode, rf,container);
      if (newNode!=null) {
        newNode.id=nodes.size();
        nodes.add(newNode);
        frame.addNode(newNode.pos,currentNode.radiusfactor*rf);
        frame.addStrut(newNode.id, currentNode.id);
      }
      else {
        currentNode.active=false;
      }
    }
  }
}


Node findNeighbor(Node node, float rf, HE_Mesh container) {
  float currentradius=startradius;//node.searchradius;
  float shrink= 0.95; 
  int numtries=50;
  WB_RandomOnSphere rnd=new WB_RandomOnSphere();
  WB_Vector v;
  while (currentradius>=minradius) { 
    for (int j=0;j<numtries;j++) {
      int c=(int)random(3.9999999);
      switch(c){
       case 0:
      v=new WB_Vector(1,1,1);
      break;
      case 1:
       v=new WB_Vector(-1,-1,1);
      break;
      case 2:
       v=new WB_Vector(-1,1,-1);
      break;
      default:
       v=new WB_Vector(1,-1,-1);
      break;
        
      }
      v.normalizeSelf();
      
      

      WB_Point neighborPos = node.pos.addMul(startradius*node.radiusfactor+currentradius,v);
      boolean free=(container==null)?true:inside(neighborPos, container);
      if (free) {
        for  (Node currentNode:nodes) {
          if (currentNode != node){
            if (currentNode.pos.getSqDistance3D(neighborPos) < (currentradius+startradius*currentNode.radiusfactor)*(currentradius+startradius*currentNode.radiusfactor)) { 
              free=false;
              break;
            }
          }
        }
      }
      if (free) {
        node.isParent=true;
        return new Node(neighborPos, node.radiusfactor*rf, node, -1, node.generation+1);
      }
    }
    currentradius*=shrink;
  }
  return null;
}

void createMesh() {
  ffc=new HEC_FromFrame().setFrame(frame).setStrutRadius(0.5*startradius).setStrutFacets(6).setTaper(true).setSuppressBalljoint(true);//.setUseNoPairing(true)
  mesh=new HE_Mesh(ffc);

}

boolean inside(WB_Point p, HE_Mesh mesh) {
  boolean b= mesh.contains(p, false);
  return b;
}

