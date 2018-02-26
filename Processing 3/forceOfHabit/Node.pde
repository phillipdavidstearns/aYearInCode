class Node {
  PVector o;
  PVector p;
  PVector v;
  PVector a;
  PVector f;
  float k = .25; //spring constant
  float m = 10; //mass
  float r = 10; //radius
  int strokeWeight = 1;
  color strokeColor = color(255);
  color fillColor = color(0); 
  boolean stroke = true;
  boolean fill = false;
  PImage image;
  int w = 10;
  int h = 10;

  Node() {
    o = new PVector(random(width), random(height));
    p = o.copy();
    v = new PVector(0, 0);
    a = new PVector(0, 0);
    f = new PVector(0, 0);
  }

  Node(int _x, int _y) {
    o = new PVector(_x, _y);
    p = o.copy();
    v = new PVector(0, 0);
    a = new PVector(0, 0);
    f = new PVector(0, 0);
  }

  Node(int _x, int _y, int _dims) {
    w = _dims;
    h = _dims;
    image = createImage(w, h, RGB);
    o = new PVector(_x, _y);
    p = o.copy();
    v = new PVector(0, 0);
    a = new PVector(0, 0);
    f = new PVector(0, 0);
  }
  
  int[] copyPixels(PImage _image) {
    _image.loadPixels();
    image.loadPixels();
    for (int _x = 0; _x < w; _x++) {
      for (int _y = 0; _y < h ; _y++) {
        int sX = int(o.x + (_x - (float(w)/2)));
        int sY = int(o.y + (_y - (float(h)/2)));
        sX = (sX+_image.width) % _image.width;
        sY = (sY+_image.height) % _image.height;
        image.pixels[_y*image.width+_x] = _image.pixels[sY*_image.width+sX];
      }
    }
    image.updatePixels();
    return image.pixels;
  }
  
  int[] copyPixels(int[] _image) {
    image.loadPixels();
    for (int _x = 0; _x < w; _x++) {
      for (int _y = 0; _y < h ; _y++) {
        int sX = int(o.x + (_x - (float(w)/2)));
        int sY = int(o.y + (_y - (float(h)/2)));
        sX = (sX+width) % width;
        sY = (sY+height) % height;
        image.pixels[_y*image.width+_x] = _image[sY*width+sX];
      }
    }
    image.updatePixels();
    return image.pixels;
  }
  
  int[] pastePixels(PImage _image, PVector _paste) {
    _image.loadPixels();
    _paste.setMag(2);
    for (int _x = 0; _x < w; _x++) {
      for (int _y = 0; _y < h ; _y++) {
        int sX = int((o.x+_paste.x) + (_x - (float(w)/2)));
        int sY = int((o.y+_paste.y) + (_y - (float(h)/2)));
        sX = (sX+_image.width) % _image.width;
        sY = (sY+_image.height) % _image.height;
        _image.pixels[sY*_image.width+sX] = image.pixels[_y*image.width+_x];
      }
    }
    _image.updatePixels();
    return image.pixels;
  }
  
  int[] pastePixels(PImage _image) {
    _image.loadPixels();
    for (int _x = 0; _x < w; _x++) {
      for (int _y = 0; _y < h ; _y++) {
        int sX = int(p.x + (_x - (float(w)/2)));
        int sY = int(p.y + (_y - (float(h)/2)));
        sX = (sX+_image.width) % _image.width;
        sY = (sY+_image.height) % _image.height;
        _image.pixels[sY*_image.width+sX] = image.pixels[_y*image.width+_x];
      }
    }
    _image.updatePixels();
    return image.pixels;
  }
  

  PVector applyForce(PVector _f) {
    _f.div(m);
    return a.add(_f);
  }

  void update() {
    
    applyForce(springForce());
    
    v.mult(.5); //dampening
    v.add(a); // apply acceleration to velocity
    v.limit(1); // speedlimit
    p.add(v); // apply velocity to position
    wrap(); // keep node wraped within frame
    a.mult(0); //clear out acceleration
  }
  
  PVector springForce(){
    PVector s = PVector.sub(o, p); //create vector pointing to origin from current position
    s.setMag(k*PVector.dist(o, p)); // multiply distance by spring constant, k to calculate magnatude of spring force
    return s;
  }

  void wrap() {
    p.x =( p.x+width)%width;
    p.y = (p.y+height)%height;
  }

  void render() {
    stroke(strokeColor);
    strokeWeight(strokeWeight);
    fill(fillColor);
    if (!stroke) noStroke();
    if (!fill) noFill();
    //ellipse(p.x, p.y, 2*r, 2*r);
    PVector dir = f.copy();
    dir.setMag(w);
    line(p.x-dir.x, p.y-dir.y, p.x+dir.x, p.y+dir.y);
  }
}