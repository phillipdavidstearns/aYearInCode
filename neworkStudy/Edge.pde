class Edge{
  PVector head, tail;
  int head_ID, tail_ID;
  
  float l; //spring length
  float d; //distance between head and tail
    
  Edge(Node _node1, Node _node2){
    head_ID=_node1.ID;
    tail_ID=_node2.ID;
    head = _node1.location;
    tail = _node2.location;
    l = 20;
    d = head.dist(tail);
  }
  
  void display(){
    stroke(0);
    strokeWeight(0);
    line(head.x, head.y, tail.x, tail.y);
    textSize(10);
//    text(head.dist(tail), (head.x+tail.x)/2, (head.y+tail.y)/2);
//    text(l, head.x, head.y);
  }
}


