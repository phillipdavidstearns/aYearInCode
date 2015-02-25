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

int block_size = 32;
ArrayList<int[]> images = new ArrayList<int[]>();

void setup(){
 
  srcImg = loadImage("input/4718Beef.jpg"); //loads source image
  srcImg.resize(256, 192);
  size(srcImg.width, srcImg.height); //set window size to source image dimensions 
  image(srcImg, 0, 0); //draw source image
  loadPixels();
  input_flock = new Flock();
  output_flock = new Flock();
  // Add an initial set of boids into the system
//  for (int i = 0; i < 1024; i++) {
//    input_flock.addBlock(new Block(int(random(width)), int(random(height))));
//    output_flock.addBlock(new Block(int(random(width)), int(random(height))));
//  }
  
  for(int x = 0 ; x < int(width/block_size + 1); x++){
    for(int y = 0 ; y < int(height/block_size + 1); y++){
      input_flock.addBlock(new Block(block_size * x, block_size * y));
      output_flock.addBlock(new Block(block_size * x, block_size * y));

    }
  }
}

void draw(){
//  input_flock.run(); 
  output_flock.run();  
  displacePixels(input_flock, output_flock);
//  saveFrame("output/2015_02_22/001/Meat-####.PNG");
  if(frameCount >= 9000){
    exit();
  }
}

//not currently implemented... something about setting a point of gravity or adding another block when clicked...
void mousePressed() {
}


void displacePixels(Flock _input, Flock _output){
  Block input_block;
  Block output_block;
  images.clear();
  for(int i = 0 ; i < _input.blocks.size() ; i++){
    input_block = _input.blocks.get(i);
    images.add(i, capture(pixels, input_block.location));
  }
  for(int i = 0 ; i < _input.blocks.size() ; i++){
    input_block = _input.blocks.get(i);
    output_block = _output.blocks.get(i);
    int[] _image = images.get(i);
    for(int k = 0 ; k < block_size ; k++){
      for(int j = 0 ; j < block_size ; j++){
       int _x=0;
       int _y=0;
        switch(1){
          case 0:
          _x = int(output_block.location.x + k)%width;
          _y = int(output_block.location.y + j)%height;
          break;
           
          case 1: 
          _x = int(input_block.location.x+output_block.velocity.x + k)%width;
          _y = int(input_block.location.y+output_block.velocity.y + j)%height;
          break;
        
          case 2:
          _x = int(input_block.location.x+input_block.velocity.x + k)%width;
          _y = int(input_block.location.y+input_block.velocity.y + j)%height;
          break;
        }
        
        if(_x < 0){
          _x += width - 1;
        }
        if(_y < 0){
          _y += height - 1;
        }
        pixels[_x + (_y*width)]=_image[k+(j*block_size)];
      }
    }
    updatePixels();  
  }
}




  // capture pixels at the input location
  // pulled out of the Block class for reworking of code
  //inprogress: reworking for function to pull location info from a Block object and create a PImage

int[] capture(int[] _pixels, PVector _location){
  int _width = block_size;
  int _height = block_size;
  int[] img = new int[_width * _height];
  //img.loadPixels();
  for(int y = 0 ; y < _width ; y++){
    for(int x = 0 ; x < _height ; x++){
      int capture_x = (int(_location.x) + x)%(width);
      if(x < 0 ) capture_x = capture_x + width - 1;
      int capture_y = (int(_location.y) + y)%(height);
      if(y < 0 ) capture_y = capture_y + height - 1;
        img[(block_size*y)+x]=_pixels[capture_x + (capture_y * width)];
    }
  }
  //img.updatePixels();
  return img;
}

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
