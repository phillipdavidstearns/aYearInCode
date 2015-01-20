PImage srcImg;
Block[] blocks;

void setup(){
  srcImg = loadImage("input/yungjake.png"); //loads source image
  size(srcImg.width, srcImg.height); //set window size to source image dimensions 
  image(srcImg, 0, 0); //draw source image
  loadPixels(); //load window pixels into pixels[] array.
  int block_size=32; //set size of blocks
  blocks = new Block[int(width/block_size) * int(height/block_size)]; //temporarily creating a grid of blocks over the entire image
  int index = 0; //for use within for loop below
  for(int x = 0 ; x < width/block_size  ; x++){
    for(int y = 0 ; y < height/block_size ; y++){
      blocks[index] = new Block(block_size, int(x*block_size), int(y*block_size)); //creates new block and passes block_size and location
      index++;
    }
  }
}

void draw(){
  
  //move and display all blocks
  for(int i = 0 ; i < blocks.length ; i++){
    blocks[i].move();
    blocks[i].display();
  }
  
  //exports frames 1x1
  //can be commented out to prevent frame export
  saveFrame("output/block_class_test/block_class_test_####.PNG");
  if(frameCount > 20){
    exit();
  }
}

//not currently implemented... something about setting a point of gravity or adding another block when clicked...
//next will be to add arrayList class for Blocks
void mousePressed() {
}
  
class Block {

  int size;
  PImage img;
  
  //physics variables
  PVector location;
  PVector velocity;
  PVector acceleration;
  float dampening;
  
  //for  manipulation of pixels inside the block
  float hue;
  float saturation;
  float brightness;
  
  //constuctor requires args = size, and x, y coordinates
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
