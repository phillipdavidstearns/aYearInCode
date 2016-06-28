PImage[] sequence;
PImage indexMatrix;
int[] displacementMatrix;
PImage frame;
boolean play;
boolean save;
boolean animate;
boolean interpolate;
boolean animateMatrix;
boolean loaded;
File[] files;
int frameIndex;
String outputPath;
int displaySource = 1; //0 = frame, 1 = indexMatrix
int indexMode = 2; // 0 = saw, 1 = tri, 2 = sine
float frequencyScale = .25;
float phaseScale = .05;
float scanRange = 255;

void setup() {
  size(720, 720);
  surface.setResizable(true);
  
  play = false;
  animate = false;
  save = false;
  interpolate=false;
  animateMatrix= false;
  frameIndex = 0;
  loaded=false;
  
  frameRate(30);
  
}

void draw() {

  if (sequence!=null && loaded) {
    
    if(animateMatrix){
      updateIndex();
    }
    
    mapIndexSequence();
    
    switch(displaySource) {
    case 0:
      image(frame, 0, 0);
      break;
    case 1:
      image(indexMatrix, 0, 0);
      break;
    }
  }
  
  if(save){
    saveFrame(outputPath+"_"+frameIndex+".png");
    frameIndex++;
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
    frameIndex=0;
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
        displacementMatrix[y*indexMatrix.width+x] = int(pow(2,16)*(float(y)/height)); //linear
        break;
      case 1:
        displacementMatrix[y*indexMatrix.width+x] = int(pow(2,16)*(1-(float(y)/height))); //reverse
        break;
        case 2:
        displacementMatrix[y*indexMatrix.width+x] = int(pow(2,16)*(.5 * sin((frequencyScale*2*PI*float(y)/indexMatrix.height + phaseScale*frameCount))+.5)); //linear
        break;
        case 3:
        displacementMatrix[y*indexMatrix.width+x] = int(pow(2,16)*(.5 * sin((frequencyScale*2*PI*float(x)/indexMatrix.height + phaseScale*frameCount))+.5)); //linear
        break;
        case 4:
        displacementMatrix[y*indexMatrix.width+x] = int(pow(2,16)*(.5 * sin((frequencyScale*2*PI*float(x)/indexMatrix.height + phaseScale*frameCount))+.5)*(.5 * sin((frequencyScale*2*PI*float(y)/indexMatrix.height + phaseScale*frameCount))+.5)); //linear
        break;
      }
    }
  }
  
  //indexMatrix.loadPixels();

  //for (int y = 0; y < indexMatrix.height; y++) {
  //  for (int x = 0; x < indexMatrix.width; x++) {
  //        indexMatrix.pixels[y*indexMatrix.width+x] = color(255*float(displacementMatrix[y*indexMatrix.width+x])/pow(2,16));
  //  }
  //}
  //indexMatrix.updatePixels();
}

void mapIndexSequence() {
  frame.loadPixels();
  for (int i = 0; i < indexMatrix.pixels.length; i ++) {
    int theFrame;
    
    if(!animate){
    theFrame = int((float(displacementMatrix[i])/pow(2,16) * scanRange))%sequence.length;
    } else{
    theFrame = (frameCount+int((float(displacementMatrix[i])/pow(2,16)) * scanRange))%sequence.length;
    }
    
    if(!interpolate){  
    frame.pixels[i] = sequence[theFrame].pixels[i];
    } else {
    frame.pixels[i] = lerpColor(sequence[theFrame].pixels[i], sequence[(theFrame+1)%sequence.length].pixels[i], .5);
    }
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
    load_sequence(sequence.getAbsolutePath(), 0);
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

void load_sequence(String thePath, int index) {
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
  indexMatrix = createImage(sequence[0].width, sequence[0].height, GRAY);
  frame = createImage(sequence[0].width, sequence[0].height, RGB);
  displacementMatrix = new int[frame.pixels.length];
  loaded=true;
}


void save_image(String thePath) {
}