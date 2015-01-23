PImage srcImg;
Block[] blocks;
int block_size = 32;

void setup(){
  srcImg = loadImage("input/yungjake.png"); //loads source image
  //srcImg = loadImage("input/windows_xp_bliss-wide.jpg"); //loads source image
  size(srcImg.width, srcImg.height); //set window size to source image dimensions 
  image(srcImg, 0, 0); //draw source image
  loadPixels(); //load window pixels into pixels[] array.
  //blocks = new Block[int(width/block_size) * int(height/block_size)]; //temporarily creating a grid of blocks over the entire image
  blocks = new Block[500]; //temporarily creating a grid of blocks over the entire image
  for(int i = 0 ; i < blocks.length ; i++){
    blocks[i] = new Block(block_size, int(random(width-block_size-1)), int(random(height-block_size-1)));
  }
  updatePixels();
//  int index = 0; //for use within for loop below
//  for(int x = 0 ; x < width/block_size  ; x++){
//    for(int y = 0 ; y < height/block_size ; y++){
//      blocks[index] = new Block(block_size, int(x*block_size), int(y*block_size)); //creates new block and passes block_size and location
//      index++;
//    }
//  }
}

void draw(){
  
  //move and display all blocks
  
  for(int i = 0 ; i < blocks.length ; i++){
    loadPixels();
    blocks[i].run();
  }
  updatePixels();
  
  //exports frames 1x1
  //can be commented out to prevent frame export
  saveFrame("output/block_class_drift/block_class_drift_####.PNG");
  if(frameCount > 2000){
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
  PVector origin;
  PVector origin_velocity;
  
  PVector shift;
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
    
    origin = new PVector(_x, _y);
    origin_velocity = new PVector(random(2)-1, random(2)-1);
    //origin_velocity = new PVector(0,0);
    shift = new PVector(_x, _y);
    velocity = new PVector(random(4)-2, random(4)-2);
    acceleration = new PVector(random(2)-1, random(2)-1);
    
    img = createImage(size, size, RGB);
    
    capture();
  }
  
  void run(){
    capture();
    rotateHue();
    move();
    display();
  }
  
  void capture(){
    img.loadPixels();
    for(int y = 0 ; y < size ; y++){
      for(int x = 0 ; x < size ; x++){
        if(origin.x >= 0 && origin.x < width-block_size-1 && origin.y >= 0 && origin.y < height-block_size-1){
          img.pixels[(size*y)+x]=pixels[(int(origin.x) + x) + ((int(origin.y)+y) * width)];
        }
      }
    }
    img.updatePixels();
  }
  
  void move(){
   
    //origin_velocity.add(acceleration);
    //origin.add(origin_velocity); 
    
    //velocity.add(acceleration);
    shift = PVector.add(origin, velocity);
  }
  
  void display(){
    image(img, shift.x, shift.y);
  }
  
  void rotateHue(){
    img.loadPixels();
    for(int i = 0 ; i < img.pixels.length ; i++){
        colorMode(HSB,255);   
        img.pixels[i] += color(1,5,0);
    }
    img.updatePixels();
  }
  
}
