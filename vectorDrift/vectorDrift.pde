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

PImage src;
PImage buffer;
Flock input_flock;
Flock output_flock;

int block_size = 128;
ArrayList<int[]> images = new ArrayList<int[]>();
int mode = 1;
PVector[] rando;
void setup(){
 
  src = loadImage("input/nude.jpg"); //loads source image
  src.resize(1280, 720);
  size(src.width, src.height); //set window size to source image dimensions 
  image(src, 0, 0); //draw source image
  loadPixels();
  input_flock = new Flock();
  output_flock = new Flock();
  // Add an initial set of boids into the system
//  for (int i = 0; i < 50; i++) {
//    input_flock.addBlock(new Block(int(random(width)), int(random(height))));
//    output_flock.addBlock(new Block(int(random(width)), int(random(height))));
//  }
//  
  makeGrid(block_size);
  makeRando();
  
  
}

void draw(){
  background(255);
  input_flock.run(); 
  output_flock.run();  
  displacePixels(input_flock, output_flock);
  updatePixels();
//  saveFrame("output/2015_02_22/001/Meat-####.PNG");
//  if(frameCount >= 9000){
//    exit();
//  }
}

void mouseReleased() {
  
}

void makeRando(){
  rando = new PVector[input_flock.blocks.size()];
  for(int p = 0 ; p < input_flock.blocks.size(); p++){
    rando[p] = new PVector(random(-1,1),random(-1,1));
    rando[p].mult(2);
  }
}

void keyPressed(){
  char k = key;
  switch(k){
    case'q':
      mode = 0;
    break;
    case'w':
      mode = 1;
    break;
    case'e':
      mode = 2;
    break;
    case'r':
      mode = 3;
    break;
    case 't':
      image(srcImg, 0, 0);
      loadPixels();
    break;
    case '1':
      makeGrid(16);
    break;
    case '2':   
      makeGrid(32);
    break;
    case '3':   
      makeGrid(64);
    break;
    case '4':   
      makeGrid(128);
    break;
    case '5':
      makeGrid(256);
    break;
    case '6':   
      makeGrid(512);
    break;
    case '7':   
      makeGrid(1024);
    break;
    case '8':   
      makeGrid(2048);
    break;
  }
}

void makeGrid(int _block_size){
  input_flock = new Flock();
  output_flock = new Flock();
  block_size=_block_size;
  for(int x = 0 ; x < int(width/block_size+1); x++){
    for(int y = 0 ; y < int(height/block_size+1); y++){
    input_flock.addBlock(new Block(block_size * x, block_size * y));
    output_flock.addBlock(new Block(block_size * x, block_size * y));
    }
  }
  makeRando();
}



void displacePixels(Flock _input, Flock _output){
  
  
  
  
//  images.clear();
  
//  for(int i = 0 ; i < _input.blocks.size() ; i++){
//    images.add(i, capture(pixels, _input.blocks.get(i).location));
//  }
  
//  for(int i = 0 ; i < _input.blocks.size() ; i++){
//    int[] _image = images.get(i);
//    for(int k = 0 ; k < block_size ; k++){
//      for(int j = 0 ; j < block_size ; j++){
//       int _x=0;
//       int _y=0;
//        switch(mode){
//          case 0:
//          _x = int(_output.blocks.get(i).location.x + k)%width;
//          _y = int(_output.blocks.get(i).location.y + j)%height;
//          break;
//           
//          case 1: 
//          _x = int(_input.blocks.get(i).location.x+_output.blocks.get(i).velocity.x + k)%width;
//          _y = int(_input.blocks.get(i).location.y+_output.blocks.get(i).velocity.y + j)%height;
//          break;
//        
//          case 2:
//          _x = int(_input.blocks.get(i).location.x+_input.blocks.get(i).velocity.x + k)%width;
//          _y = int(_input.blocks.get(i).location.y+_input.blocks.get(i).velocity.y + j)%height;
//          break;
//        
//          case 3:  
//          _x = int(_input.blocks.get(i).location.x+rando[i].x + k)%width;
//          _y = int(_input.blocks.get(i).location.y+rando[i].y + j)%height;
//          break;
//        }
//        
//        if(_x < 0){
//          _x += width - 1;
//        }
//        if(_y < 0){
//          _y += height - 1;
//        }
//        pixels[_x + (_y*width)]=_image[k+(j*block_size)];
//      }
//    }
//  }
}




  // capture pixels at the input location
  // pulled out of the Block class for reworking of code
  //inprogress: reworking for function to pull location info from a Block object and create a PImage

int[] capture(int[] _pixels, PVector _location){
  int _width = block_size;
  int _height = block_size;
  int[] img = new int[_width * _height];
  for(int y = 0 ; y < _width ; y++){
    for(int x = 0 ; x < _height ; x++){
      int capture_x = (int(_location.x) + x)%(width);
      if(x < 0 ) capture_x = capture_x + width - 1;
      int capture_y = (int(_location.y) + y)%(height);
      if(y < 0 ) capture_y = capture_y + height - 1;
        img[(block_size*y)+x]=_pixels[capture_x + (capture_y * width)];
    }
  }
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
