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

boolean run = false;
boolean save = false;

String outputPath;

int frameNumber=0;

int block_size = 32;
int mode = 1;


void setup() {
  size(4000, 2000, P2D);
  src = loadImage("environment.png");
  image(src, 0, 0); //draw source image
  loadPixels();
  buffer = createImage(width, height, RGB);
  makeGrid(block_size);
  input_flock = new Flock();
  output_flock = new Flock();
  frameRate(30);
}

void draw() {
  if (run) {
    input_flock.run(); 
    //output_flock.run();  
    displacePixels(input_flock, input_flock);
    image(buffer, 0, 0);
    if (save) {
      saveFrame(outputPath+nfs(frameNumber, 4)+".PNG");
      frameNumber++;
    }
  }
}


void keyPressed() {


  switch(key) {
  case ' ':
    run = !run;
    break;
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
  case 't': //reset
    image(src, 0, 0);
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
  case 's':
    selectOutput("Select a file to process:", "outputSelection");
    break;
  case 'x':
    save = false;
    break;
  }
}


void outputSelection(File output) {
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    outputPath = output.getAbsolutePath();
  }
  frameNumber = 0;
  save = true;
}

void saveData(String thePath) {
  saveFrame(thePath+".PNG");
}  

void makeGrid(int _block_size) {
  input_flock = new Flock();
  output_flock = new Flock();
  block_size=_block_size;
  for (int x = 0; x < int (width/_block_size+1); x++) {
    for (int y = 0; y < int (height/_block_size+1); y++) {
      input_flock.addBlock(new Block(_block_size * x, _block_size * y));
      output_flock.addBlock(new Block(_block_size * x, _block_size * y));
    }
  }
}



void displacePixels(Flock _input, Flock _output) {

  PVector copy = new PVector(0, 0);
  PVector paste = new PVector(0, 0);

  //for every block in the flock
  loadPixels();

  for (int i = 0; i < pixels.length; i++) {
    buffer.pixels[i]=pixels[i];
  }


  for (int i = _input.blocks.size() - 1; i >= 0; i-- ) {

    Block input_block = _input.blocks.get(i);
    Block output_block = _output.blocks.get(i);



    copy.set(input_block.origin);
    paste.set(PVector.add(copy, input_block.velocity));

    int _width = block_size;
    int _height = block_size;

    for (int _y = 0; _y < _width; _y++) {
      for (int _x = 0; _x < _height; _x++) {
        int capture_x = (width + int(copy.x) + _x)%(width);
        int capture_y = (height + int(copy.y) + _y)%(height);
        int displacement_x = (width + int(paste.x) +_x)%(width);
        int displacement_y = (height + int(paste.y) +_y)%(height);

        buffer.pixels[displacement_x+(width*displacement_y)]=pixels[capture_x + (capture_y * width)];
        //buffer.pixels[capture_x+(width*capture_y)] = pixels[displacement_x + (displacement_y * width)];
      }
    }
    buffer.updatePixels();
  }

  updatePixels();
}