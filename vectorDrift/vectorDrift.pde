PImage srcImg;
Block[] blocks;

void setup(){
  srcImg = loadImage("input/yungjake.png");
  size(srcImg.width, srcImg.height);
  image(srcImg, 0, 0);
  loadPixels();
  int block_size=32;
  blocks = new Block[int(width/block_size) * int(height/block_size)];
  int index = 0;
  for(int x = 0 ; x < width/block_size  ; x++){
    for(int y = 0 ; y < height/block_size ; y++){
      blocks[index] = new Block(block_size, int(x*block_size), int(y*block_size));
      index++;
    }
  }
}

void draw(){
  
  for(int i = 0 ; i < blocks.length ; i++){
    blocks[i].move();
    blocks[i].display();
  }
  
  saveFrame("output/block_class_test/block_class_test_####.PNG");
  if(frameCount > 20){
    exit();
  }
}


void mousePressed() {
}
  
class Block {
  int size;
  PImage img;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float dampening;
  float hue;
  float saturation;
  float brightness;
  
  Block(int _size, int _x, int _y){
    size=_size;
    location = new PVector(_x, _y);
    velocity = new PVector(random(4)-2, random(4)-2);
    acceleration = new PVector(0,0);
    
    img = createImage(size, size, HSB);
    img.loadPixels();
    for(int y = 0 ; y < size ; y++){
      for(int x = 0 ; x < size ; x++){
        img.pixels[(size*y)+x]=pixels[(int(location.x) + x) + ((int(location.y)+y) * width)];
      }
    }
    img.updatePixels();
  }
  
  void move(){ 
  velocity.add(acceleration);
  location.add(velocity);
}
  void display(){
    image(img, location.x, location.y);
  }
  
}
