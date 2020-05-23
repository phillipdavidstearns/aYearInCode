class Edge{
  
  Node head, tail;
  
  float l = 15; //spring length
    
  Edge(Node _node1, Node _node2){
    head = _node1;
    tail = _node2; 
  }
  
  float distance(){
    return PVector.dist(head.position, tail.position);
  }
  
  void display(){
    stroke(0);
    strokeWeight(1);
    line(head.position.x, head.position.y, tail.position.x, tail.position.y);
  }
}
