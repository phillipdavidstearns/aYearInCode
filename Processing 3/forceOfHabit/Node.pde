class Node{
  PVector p;
  PVector v;
  PVector a;
  PVector f;
  float m;
  
  Node(){
    p = new PVector(random(width), random(height));
    v = new PVector(random(-1,1), random(-1,1));
    a = new PVector(0,0);
    f = new PVector(0,0);
    m = 2;
  }
  
  PVector applyForce(PVector _f){
    return a.add(_f);
  }
  
  void update(){
    v.add(a);
    //v.limit();
    p.add(v);
    a.mult(0);
  }
  
}