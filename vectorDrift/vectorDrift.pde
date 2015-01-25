PImage srcImg;
Block[] blocks;
int block_size = 64;

void setup(){
  srcImg = loadImage("input/yungjake.png"); //loads source image
  //srcImg = loadImage("input/windows_xp_bliss-wide.jpg"); //loads source image
  size(256, 256); //set window size to source image dimensions 
  image(srcImg, -225, 0); //draw source image
  loadPixels(); //load window pixels into pixels[] array.

  blocks = new Block[128]; //temporarily creating a grid of blocks over the entire image
  for(int i = 0 ; i < blocks.length ; i++){
    blocks[i] = new Block(block_size, int(random(width-block_size-1)), int(random(height-block_size-1)));
  }
//  blocks = new Block[int(width/block_size) * int(height/block_size)]; //temporarily creating a grid of blocks over the entire image
//  int index = 0; //for use within for loop below
//  for(int x = 0 ; x < width/block_size  ; x++){
//    for(int y = 0 ; y < height/block_size ; y++){
//      blocks[index] = new Block(block_size, int(x*block_size), int(y*block_size)); //creates new block and passes block_size and location
//      index++;
//    }
//  }
updatePixels();
}

void draw(){
  
  saveFrame("output/hue_rotation/23_Jan_2015-####.PNG");
  if(frameCount > 60){
    exit();
  }
  
  //move and display all blocks
  
  for(int i = 0 ; i < blocks.length ; i++){
    loadPixels();
    blocks[i].run();
  }
  updatePixels();
  
  
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
  
  PVector shift_location;
  PVector shift_velocity;
  PVector shift_acceleration;
  
  float dampening;
  
  float velocity_scalar = 0;
  float acceleration_scalar = 0;
  
  float shift_velocity_scalar = 1;
  float shift_acceleration_scalar = 0;
  
  //for  manipulation of pixels inside the block
  float hue;
  float saturation;
  float brightness;
  
  //constuctor requires args = size, and x, y coordinates
  Block(int _size, int _x, int _y){
    
    size=_size;
    
    location = new PVector(_x, _y);
    velocity = new PVector(random(2)-1, random(2)-1);
    velocity.mult(velocity_scalar);
    acceleration = new PVector(random(2)-1, random(2)-1);
    acceleration.mult(acceleration_scalar);
    
    shift_velocity = new PVector(_x, _y);
    shift_velocity = new PVector(random(3)-1, random(3)-1);
    shift_velocity.mult(shift_velocity_scalar);
    shift_acceleration = new PVector(random(2)-1, random(2)-1);
    shift_acceleration.mult(shift_acceleration_scalar);
    
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
    for(int y = 0 ; y < size ; y++){
      for(int x = 0 ; x < size ; x++){
        
        int capture_x = (int(location.x) + x)%(width-1);
        if(x < 0 ) capture_x = capture_x + height - 1;
        int capture_y = (int(location.y) + y)%(height-1);
        if(y < 0 ) capture_y = capture_y + height - 1;
        //if(location.x >= 0 && location.x < width-block_size-1 && location.y >= 0 && location.y < height-block_size-1){
        //  img.pixels[(size*y)+x]=pixels[(int(location.x) + x) + ((int(location.y)+y) * width)];
        //} 
          img.pixels[(size*y)+x]=pixels[capture_x + (capture_y * width)];

      }
    }
    img.updatePixels();
  }
  
  void move(){
   
    velocity.add(acceleration);
    location.add(velocity); 
    
    shift_velocity.add(shift_acceleration);
    shift_location = PVector.add(location, shift_velocity);
    
    location.x %= width-1;
    if(location.x < 0 ) location.x += height - 1;
    location.y %= width-1;
    if(location.y < 0 ) location.y += height - 1;
  }
  
  void display(){
    image(img, shift_location.x, shift_location.y);
  }
  
  void rotateHue(){
    img.loadPixels();
    for(int i = 0 ; i < img.pixels.length ; i++){
      colorMode(HSB,360,255,255);
      hue = hue(img.pixels[i]);
      saturation = saturation(img.pixels[i]);
      brightness = brightness(img.pixels[i]);
      
      hue+=-1;
      if(hue < 0){
        hue += 360;
      }
      hue %= 360; 
      
      saturation+=0;
      if(saturation < 0){
        saturation += 255;
      }
      saturation %= 256; 
      
      brightness+=0;
      if(brightness < 0){
        brightness += 255;
      }
      brightness %= 256; 
      
      img.pixels[i] = color(hue, saturation, brightness);
    }
    img.updatePixels();
  }
  
}
