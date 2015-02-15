PVector gravity = new PVector(0,1);
ArrayList<Node> nodes = new ArrayList<Node>();
int qtyNodes = 5;

void setup(){
  size(500,500);
  for(int i = 0 ; i < qtyNodes ; i++){
    nodes.add(new Node(i));
  }
}

void draw(){
  background(255);
  for(int i = nodes.size()-1; i >= 0; i--){
    Node n = nodes.get(i);
    n.run(nodes);
  }
}


