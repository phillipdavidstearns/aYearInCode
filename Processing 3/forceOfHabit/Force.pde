class Force{
  
  PVector p;
  PVector f;
  
  Force(){
    p = new PVector(random(width),random(height));
    f = new PVector(0,0);
  }
  
  Force(float _x, float _y){
    p = new PVector(_x,_y);
    f = new PVector(0,0);
  }
  
  Force(float _x, float _y, PVector _f){
    p = new PVector(_x,_y);
    f = _f.copy();
  }
  
  PVector setForce(PVector _f){
    f = _f.copy();
    return f;
  }
  
  PVector get(){
    return f;
  }
  
  PVector pos(){
    return p;
  }
  
  float pos(char _axis){
    if(_axis == 'x' || _axis == 'X') return p.x;
    else if(_axis == 'y' || _axis == 'Y') return p.y;
    else return 0;
  }
  
  void render(){
    stroke(255);
    strokeWeight(1);
    PVector dir = f.copy();
    dir.mult(5);
    line(p.x-dir.x, p.y-dir.y, p.x+dir.x, p.y+dir.y);
  }
}