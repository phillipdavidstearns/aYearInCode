class Edge{
  PVector head, tail;
  int head_ID, tail_ID;
  float l;
  float k = 1;
  float dampening = .99;
    
  Edge(Node _node1, Node _node2){
    head_ID=_node1.ID;
    tail_ID=_node2.ID;
    head = _node1.location;
    tail = _node2.location;
    l = PVector.dist(_node1.location, _node2.location);
  }
  
  void display(){
    stroke(0);
    strokeWeight(0);
    line(head.x, head.y, tail.x, tail.y);
  }
}


