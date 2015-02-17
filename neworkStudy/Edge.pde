class Edge{
  PVector head,tail;
  int node1_ID, node2_ID;
  float l;
  float k = 1;
  float dampening = .99;
  
  Edge(PVector _head, PVector _tail){

    head = _head;
    tail = _tail;
    l = PVector.dist(head, tail);
  }
  
  Edge(Node _node1, Node _node2){
    node1_ID=_node1.ID;
    node2_ID=_node2.ID;
    head = _node1.location;
    tail = _node2.location;
    l = PVector.dist(_node1.location, _node2.location);
  }
  void display(){
    stroke(0);
    strokeWeight(1);
    line(head.x, head.y, tail.x, tail.y);
  }
}


