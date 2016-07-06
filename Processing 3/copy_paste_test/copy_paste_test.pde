PImage src, dest;
PVector copy_location, copy_velocity, paste_location, paste_velocity;
boolean play, loaded, save;
int frameIndex;
String outputPath;
int block_size;


void setup() {
  size(720, 720);
  surface.setResizable(true);
  frameRate(30);
  play = false;
  loaded = false;
  save = false;
  frameIndex = 0;
  block_size = 32;
  initVectors();
}


void initVectors(){
  copy_location = new PVector(random(width), random(height));
  copy_velocity = new PVector(random(-2,2),random(-2,2));
  paste_location = new PVector(random(width), random(height));
  paste_velocity = new PVector(random(-2,2),random(-2,2));
}



void draw() {

  if (src!=null && loaded) {
    update();
    copyPaste();
    image(dest, 0, 0);
  }
  
  if(save){
    saveFrame(outputPath+"_"+frameIndex+".png");
    frameIndex++;
  }
}

void update(){
  copy_location.add(copy_velocity);
  paste_location.add(paste_velocity);
  copy_location.x = (width+copy_location.x)%width;
  copy_location.y = (height+copy_location.y)%height;
  paste_location.x = (width+paste_location.x)%width;
  paste_location.y = (height+paste_location.y)%height;
}

void copyPaste(){
  dest.copy(src, int(copy_location.x), int(copy_location.y), block_size, block_size, int(paste_location.x), int(paste_location.y), block_size, block_size);
}

void keyPressed() {
  switch(key) {
    case 'o':
    loaded = false;
    open_file();
    break;
    case 's':
    save_file();
    case 'S':
    save_sequence();
    break;
    case 'x':
    save = false;
    frameIndex=0;
    break;
    case ' ':
    play = !play;
    break;
    
  }
}



public void open_file() {
  selectInput("Select a file to process:", "inputSelection");
}

void inputSelection(File input) {
  if (input == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + input.getAbsolutePath());
    load_image(input.getAbsolutePath());
  }
}

void load_image(String thePath) {
  src = loadImage(thePath);
  dest = src;
  surface.setSize(src.width, src.height);
  initVectors();
  loaded = true;
}


public void save_file() {
  selectOutput("Select a file to process:", "outputSelection");
}

void outputSelection(File output) {
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    save_image(output.getAbsolutePath());
  }
}

public void save_sequence() {
  selectOutput("Select a file to process:", "outputFolderSelection");
}

void outputFolderSelection(File output) {
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    outputPath = output.getAbsolutePath();
    save = true;
  }
  
}



void save_image(String thePath) {
  saveFrame(thePath+".PNG");
}