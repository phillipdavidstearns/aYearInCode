PVector gravity = new PVector(0,1);
ArrayList<Node> nodes = new ArrayList<Node>();
int qtyNodes = 1500;

void setup(){
  size(500,500);
  for(int i = 0 ; i < qtyNodes ; i++){
    nodes.add(new Node(i));
  }
  frameRate(30);
}

void draw(){
  background(255);
  for(int i = nodes.size()-1; i >= 0; i--){
    Node n = nodes.get(i);
    n.run(nodes);
  }
  for(int i = nodes.size()-1; i >= 0; i--){
    Node n = nodes.get(i);
    n.display();
  }
//  saveFrame("output/2015-02-16/dynamic_edges_02_####.PNG");
//  if(frameCount >= 30){
//    exit();
//  }

}


