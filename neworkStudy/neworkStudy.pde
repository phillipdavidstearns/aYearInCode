PVector gravity = new PVector(0, 1);
boolean[][] edgeCatalog;
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<Edge> edges = new ArrayList<Edge>();

int qtyNodes = 2500;

float make_bond = 20;
float break_bond = 20;

void setup() {
  size(500, 500);
  
  for (int i = 0; i < qtyNodes; i++) {
    nodes.add(new Node(i));
  }
  
  edgeCatalog = new boolean[qtyNodes][qtyNodes];
  
  for(int a = 0; a < qtyNodes ; a++){
    for(int b = 0; b < qtyNodes ; b++){
      edgeCatalog[a][b]=false;
    }
  }
  
  frameRate(30);
}

void draw() {
  background(255);
  updateEdges();
  
  for(int i = 0; i < nodes.size() ; i++){
    nodes.get(i).run(nodes,edges);
  }
  for(int i = 0; i < edges.size() ; i++){
    edges.get(i).display();
  }
  
}

void updateEdges(){
  
  ArrayList<Edge> newEdges = new ArrayList<Edge>();
  
  for(int a = 0; a < qtyNodes ; a++){
    for(int b = 0; b < qtyNodes ; b++){
      edgeCatalog[a][b]=false;
    }
  }
  
  //the creates initial bonds if none exist
  if(edges.size() == 0){
    for (int i = 0; i < nodes.size() ; i++){
      Node n1 = nodes.get(i);
      for (int j = i; j < nodes.size() ; j++){
        Node n2 = nodes.get(j);
        if ( j != i ){
          if (PVector.dist(n1.location, n2.location) <= make_bond) {
            Edge e = new Edge(n1, n2);
            newEdges.add(e);
          }
        }
      }
    }
    edges=newEdges;
  } else {
    //update existing bonds and add to new_edges, bonds greater than the breaking length are left behind
    for(int k = 0 ; k < edges.size() ; k++){
      Edge e = edges.get(k);
      Node head = nodes.get(e.head_ID);
      Node tail = nodes.get(e.tail_ID);
      if(PVector.dist(head.location, tail.location) < break_bond){
        Edge newEdge = new Edge(head, tail);
        newEdges.add(newEdge);
        edgeCatalog[e.head_ID][e.tail_ID] = true;
        edgeCatalog[e.tail_ID][e.head_ID] = true;      
      }
    }
    //if there's not already an edge for a pair of nodes within the make_bond distance, make one in new_edges
    for (int i = 0; i < nodes.size() ; i++){
      for (int j = i; j < nodes.size() ; j++){
        if ( j != i ){
          if(edgeCatalog[i][j] != true){
            Node n1 = nodes.get(i);
            Node n2 = nodes.get(j);
            if (PVector.dist(n1.location, n2.location) <= make_bond) {
              Edge e = new Edge(n1, n2);
              newEdges.add(e);
            }
          }
        }
      }
    }
    edges=newEdges;
  }
}

