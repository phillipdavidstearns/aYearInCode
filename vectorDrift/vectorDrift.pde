PImage srcImg;
Flock flock;
int block_size =  128;

void setup(){
  //srcImg = loadImage("input/yungjake.png"); //loads source image
  //size(250, 250); //set window size to source image dimensions 
  srcImg = loadImage("input/windows_xp_bliss-wide.jpg"); //loads source image
  size(1280, 720); //set window size to source image dimensions 
  srcImg.resize(1280,720);
  image(srcImg, 0, 0); //draw source image
  loadPixels();
  updatePixels();
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 256; i++) {
    
    flock.addBlock(new Block(block_size, int(random(width-block_size-1)), int(random(height-block_size-1))));
  }
}

void draw(){
  
 //saveFrame("output/pixelFLocking_27_jan_2015/27_Jan_2015-####.PNG");
  if(frameCount > 3600){
    exit();
  }  
  
  flock.run(); 
  
}

//not currently implemented... something about setting a point of gravity or adding another block when clicked...
//next will be to add arrayList class for Blocks
void mousePressed() {
}
  

