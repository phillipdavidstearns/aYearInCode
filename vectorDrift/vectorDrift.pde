//vectorDrift - working sketch
//written in Processing
//By Phillip David Stearns
//Part of aYearInCode(); 356 project for 2015 - http://ayearincode.tumblr.com
//Uses code written by Daniel Shiffman for the flocking example in Processing
//Description: A utility which reproduces artifacts created by the glitch art technique datamoshing.
//Current implementation uses Block class to describe input source and output destinations for pixel data in the main window.
//Input and output displacement is controlled using PVectors, Input is currently set to static or random drift. Output is controlled by the flocking algorithm.
//At present, it's becoming clear that it would be nice to switch i/o vector controls between different modes (flocking and static or gravitational, etc),
//which may mean creating two array lists, one for inputs and another for outputs, then a method which grabs pixels from one, and maps to the other.
//will be paring down the Block class to make this a reality...
//WOOT!

PImage srcImg;

Flock input_flock;
Flock output_flock;

int block_size =  64;

void setup(){
  //srcImg = loadImage("input/yungjake.png"); //loads source image
  //size(250, 250); //set window size to source image dimensions 
  srcImg = loadImage("input/windows_xp_bliss-wide.jpg"); //loads source image
  size(1280, 720); //set window size to source image dimensions 
  srcImg.resize(1280,720);
  image(srcImg, 0, 0); //draw source image
  loadPixels();
  updatePixels();
  input_flock = new Flock();
  output_flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 512; i++) {
    input_flock.addBlock(new Block(int(random(width-block_size-1)), int(random(height-block_size-1))));
    output_flock.addBlock(new Block(int(random(width-block_size-1)), int(random(height-block_size-1))));
  }
}

void draw(){
  
//image(srcImg, 0, 0); //draw source image
  loadPixels();
  input_flock.run(); 
  output_flock.run();
  displacePixels(input_flock, output_flock);
  //displacePixels(input_flock, input_flock);
  //displacePixels(output_flock, output_flock);
  if(frameCount > 3600){
    exit();
  }
  saveFrame("output/pixelFlock_v2_test_001-####.PNG");
}

//not currently implemented... something about setting a point of gravity or adding another block when clicked...
void mousePressed() {
}


void displacePixels(Flock _input, Flock _output){
  Block input_block;
  Block output_block;
  PImage[] block_images = new PImage[_input.blocks.size()];
  for(int i = 0 ; i < _input.blocks.size() ; i++){
    input_block = _input.blocks.get(i);
    block_images[i] = new PImage(block_size, block_size, RGB);
    block_images[i] = capture(pixels, input_block.location);
  }
  for(int i = 0 ; i < _input.blocks.size() ; i++){
    input_block = _input.blocks.get(i);
    output_block = _output.blocks.get(i);
    //image(block_images[i], output_block.location.x, output_block.location.y);
      
//    image(block_images[i], output_block.location.x+input_block.velocity.x, output_block.location.y+input_block.velocity.y);
    image(block_images[i], input_block.location.x+output_block.velocity.x, input_block.location.y+output_block.velocity.y);
  }
}

  // capture pixels at the input location
  // pulled out of the Block class for reworking of code
  //inprogress: reworking for function to pull location info from a Block object and create a PImage

PImage capture(int[] _pixels, PVector _location){
  int _width = block_size;
  int _height = block_size;
  PImage img = createImage( _width, _height, RGB);
  //img.loadPixels();
  for(int y = 0 ; y < _width ; y++){
    for(int x = 0 ; x < _height ; x++){
      int capture_x = (int(_location.x) + x)%(width);
      if(x < 0 ) capture_x = capture_x + width - 1;
      int capture_y = (int(_location.y) + y)%(height);
      if(y < 0 ) capture_y = capture_y + height - 1;
        img.pixels[(block_size*y)+x]=_pixels[capture_x + (capture_y * width)];
    }
  }
  //img.updatePixels();
  return img;
}

//void display(){
//  stroke(0);
//  noFill();
//  rect(location.x, location.y, size, size);
//  
//  stroke(#FFFFFF);
//  strokeWeight(0);
//  noFill();
//  rect(shift_location.x, shift_location.y, size, size);
//  image(img, shift_location.x, shift_location.y);
//  image(img, displacement.x, displacement.y);
//}

//void rotateHue(float _hShift, float _sShift, float _bShift){
//  img.loadPixels();
//  for(int i = 0 ; i < img.pixels.length ; i++){
//    colorMode(HSB,360,255,255);
//    hue = hue(img.pixels[i]);
//    saturation = saturation(img.pixels[i]);
//    brightness = brightness(img.pixels[i]);
//    
//    hue+=_hShift;
//    if(hue < 0){
//      hue += 360;
//    }
//    hue %= 360; 
//    
//    saturation+=_sShift;
//    if(saturation < 0){
//      saturation += 255;
//    }
//    saturation %= 256; 
//    
//    brightness+=_bShift;
//    if(brightness < 0){
//      brightness += 255;
//    }
//    brightness %= 256; 
//    
//    img.pixels[i] = color(hue, saturation, brightness);
//  }
//  img.updatePixels();
//}
