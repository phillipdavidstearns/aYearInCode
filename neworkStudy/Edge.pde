class Edge{
  Node node1, node2;
  int node1_ID, node2_ID;
  float l;
  float k = 1;
  float dampening = .99;
  
  Edge(Node _node1, Node _node2){
    
    node1_ID=_node1.ID;
    node2_ID=_node2.ID;
    node1.location = _node1.location;
    node2.location = _node2.location;
    l = PVector.dist(node1.location, node2.location);
    
  }
  void display(){
    stroke(0);
    strokeWeight(1);
    line(node1.location.x, node1.location.y, node2.location.x, node2.location.y);
  }
}

class edgeNetwork {
  ArrayList<Edge> edges;
  
  edgeNetwork(){
    edges = new ArrayList<Edge>();
  }
  
  void add(Node _node1, Node _node2){
    Edge e = new Edge(_node1, _node2);
//    edges.add();
  }
  
  void add(Edge edge){
    edges.add(edge);
  }
  
  edgeNetwork createEdges(ArrayList<Node> _nodes){
    edgeNetwork _edgeNetwork = new edgeNetwork();
    for(int i = _nodes.size() - 1 ; i >= 0 ; i--){
      Node _node1 = _nodes.get(i);
      for(int j = _nodes.size() - 1 ; j >= 0 ; j--){
        if(i!= j){
          Node _node2 = _nodes.get(j);
//          if(PVector.dist(_node1.location ,_node2.location)){
//          }
        } 
      }
    }
    return _edgeNetwork;
  }
  
}
