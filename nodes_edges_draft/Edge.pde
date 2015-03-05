class Edge {
  
  //float creation_length
  //float dynamic_length
  //float spring_constant
  
  PVector head;
  PVector tail;
  int a;
  int b;
  float distance;
 

  Edge(float _headX, float _headY, float _tailX, float _tailY, int _hnode, int _tnode) {
    head = new PVector(_headX, _headY);
    tail = new PVector(_tailX, _tailY);
    distance = PVector.dist(head, tail);
    a = _hnode;
    b = _tnode;
  }

  void update(float _headX, float _headY, float _tailX, float _tailY) {
    head.set(_headX, _headY);
    tail.set(_tailX, _tailY);
    distance = PVector.dist(head, tail);
  }

  void setHead(float _headX, float _headY) {
    head.set(_headX, _headY);
  }

  void setTail(float _tailX, float _tailY) {
    tail.set(_tailX, _tailY);
  }

  void display() {
    stroke(255 * (distance/break_bond));
    strokeWeight(0);
    line(head.x, head.y, tail.x, tail.y);
  }

}
