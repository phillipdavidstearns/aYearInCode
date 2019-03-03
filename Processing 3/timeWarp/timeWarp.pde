// this sketch is a time displacement tool for moving image
// needs documentation

PImage[] sequence, displacement;
int[] displacementMatrix;
PImage frame;
boolean play;
boolean save;
boolean animate;
boolean interpolate;
boolean animateMatrix;
boolean loaded;
File[] files;
int frameIndex, frameNumber;
String outputPath;
int displaySource = 1; //0 = frame, 1 = indexMatrix
int indexMode = 2; // 0 = saw, 1 = tri, 2 = sine
float frequencyScale = .25;
float phaseScale = .05;
float scanRange = 5; //time in seconds
float fps = 30;
float mapDepth = pow(2,8); //8bit or 16bit
float frameDepth = 0;
int mapIndex=0;

void setup() {
  size(720, 720);
  surface.setResizable(true);
  initializeVariables();
}

void initializeVariables(){
  frameDepth = (scanRange*fps)/mapDepth;
  play = false;
  animate = false;
  save = false;
  interpolate=false;
  animateMatrix= false;
  frameIndex = 0;
  frameNumber = 0;
  loaded=false;
  frameRate(fps);
}

void draw() {

  if (sequence!=null && loaded) {
    
    if(animateMatrix){
      updateIndex();
      mapIndex++;
    }
    
    if (play){
    frameIndex++;
    }
    
    mapIndexSequence();
    image(frame, 0, 0);
  }
  
  if(save){
    saveFrame(outputPath+"_"+frameNumber+".png");
    frameNumber++;
  }
}

void keyPressed() {
  switch(key) {
    case 'o':
    open_file();
    break;
    case 'O':
    open_sequence();
    break;
    case 's':
    save_file();
    case 'S':
    save_sequence();
    break;
    case 'x':
    save = false;
    frameNumber=0;
    break;
    case ' ':
    play = !play;
    break;
    case'a':
    animate = !animate;
    break;
    case 'b':
    interpolate=!interpolate;
    break;
  case 'd':
    displaySource = (displaySource+1) % 2;
    break;
      case 'i':
    indexMode = (indexMode+1) % 5;
    break;
    case 'm':
    animateMatrix = !animateMatrix;
    
  }
}

void updateIndex() {
  
  for (int y = 0; y < frame.height; y++) {
    for (int x = 0; x < frame.width; x++) {
      switch(indexMode) {
      case 0:
        displacementMatrix[y*frame.width+x] = int(mapDepth*(float(y)/height)); //linear
        break;
      case 1:
        displacementMatrix[y*frame.width+x] = int(mapDepth*(1-(float(y)/height))); //reverse
        break;
        case 2:
        displacementMatrix[y*frame.width+x] = int(mapDepth*(.5 * sin((frequencyScale*2*PI*float(y)/frame.height + phaseScale*mapIndex))+.5)); //linear
        break;
        case 3:
        displacementMatrix[y*frame.width+x] = int(mapDepth*(.5 * sin((frequencyScale*2*PI*float(x)/frame.height + phaseScale*mapIndex))+.5)); //linear
        break;
        case 4:
        displacementMatrix[y*frame.width+x] = int(mapDepth*(.5 * sin((frequencyScale*2*PI*float(x)/frame.height + phaseScale*mapIndex))+.5)*(.5 * sin((frequencyScale*2*PI*float(y)/frame.height + phaseScale*mapIndex))+.5)); //linear
        break;
      }
    }
  }
}

void mapIndexSequence() {
  frame.loadPixels();
  for (int i = 0; i < displacementMatrix.length; i ++) {
    int theFrame;
    
    theFrame = (frameIndex+int(float(displacementMatrix[i])*frameDepth))%sequence.length;
    
    frame.pixels[i] = sequence[theFrame].pixels[i];
  }
  
  frame.updatePixels();
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

public void open_sequence() {
  selectFolder("Select a file to process:", "seqSelection");
}

void seqSelection(File sequence) {
  loaded=false;
  if (sequence == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + sequence.getAbsolutePath());
    //parsePath();
    load_sequence(sequence.getAbsolutePath());
  }
}

public void open_displacement() {
  selectFolder("Select a file to process:", "displacementSelection");
}

void displacementSelection(File sequence) {
  loaded=false;
  if (sequence == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + sequence.getAbsolutePath());
    //parsePath();
    load_displacement(sequence.getAbsolutePath());
  }
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

File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

void load_image(String thePath) {
}

void load_sequence(String thePath) {
  print("Getting files from folder... ");
  File[] files = listFiles(thePath);
  println("Done!");
  sequence = new PImage[files.length];
  print("Loading image sequence... ");
  for (int i = 0; i < files.length; i++) {
    sequence[i]=loadImage(files[i].getAbsolutePath());
  }
  println("Image sequence loaded!");
  println(sequence.length + " images in folder.");
  surface.setSize(sequence[0].width, sequence[0].height);
  frame = createImage(sequence[0].width, sequence[0].height, RGB);
  displacementMatrix = new int[frame.pixels.length];
  loaded=true;
}

void load_displacement(String thePath) {
  print("Getting files from folder... ");
  File[] files = listFiles(thePath);
  println("Done!");
  displacement = new PImage[files.length];
  print("Loading image sequence... ");
  for (int i = 0; i < files.length; i++) {
    displacement[i]=loadImage(files[i].getAbsolutePath());
  }
  println("Image sequence loaded!");
  println(sequence.length + " images in folder.");
  frame = createImage(sequence[0].width, sequence[0].height, RGB);
  displacementMatrix = new int[frame.pixels.length];
  loaded=true;
}



void save_image(String thePath) {
}
