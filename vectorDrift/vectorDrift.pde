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
void mousePressed() {
}

/*------------------------------------------------------------------------------------------------
  // capture pixels at the input location
  // pulled out of the Block class for reworking of code
  //inprogress: reworking for function to pull location info from a Block object and create a PImage

PImage capture(int[] _pixels){
  int _width = block_size;
  int _height = block_size;
  PImage img = createImage( _width, _height, RGB);
  for(int y = 0 ; y < _width ; y++){
    for(int x = 0 ; x < _height ; x++){
      int capture_x = (int(location.x) + x)%(width);
      if(x < 0 ) capture_x = capture_x + width - 1;
      int capture_y = (int(location.y) + y)%(height);
      if(y < 0 ) capture_y = capture_y + height - 1;
        img.pixels[(size*y)+x]=_pixels[capture_x + (capture_y * width)];
    }
  }
  return img;
}

void display(){
  stroke(0);
  noFill();
  rect(location.x, location.y, size, size);
  
  stroke(#FFFFFF);
  strokeWeight(0);
  noFill();
  rect(shift_location.x, shift_location.y, size, size);
  image(img, shift_location.x, shift_location.y);
  image(img, displacement.x, displacement.y);
}

void rotateHue(float _hShift, float _sShift, float _bShift){
  img.loadPixels();
  for(int i = 0 ; i < img.pixels.length ; i++){
    colorMode(HSB,360,255,255);
    hue = hue(img.pixels[i]);
    saturation = saturation(img.pixels[i]);
    brightness = brightness(img.pixels[i]);
    
    hue+=_hShift;
    if(hue < 0){
      hue += 360;
    }
    hue %= 360; 
    
    saturation+=_sShift;
    if(saturation < 0){
      saturation += 255;
    }
    saturation %= 256; 
    
    brightness+=_bShift;
    if(brightness < 0){
      brightness += 255;
    }
    brightness %= 256; 
    
    img.pixels[i] = color(hue, saturation, brightness);
  }
  img.updatePixels();
}
  
*/
