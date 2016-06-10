PImage[] sequence;
boolean play;
File[] files;
int frameIndex;
String outputPath;

void setup() {
  size(100, 100);
  surface.setResizable(true);
  play = false;
  frameIndex = 0;
  frameRate(30);
}

void draw() {

  if (sequence!=null && play) {
    surface.setSize(sequence[frameIndex].width, sequence[frameIndex].height);
    image(sequence[frameIndex],0,0);
    frameIndex = (frameIndex+1) % (sequence.length-1);
  }
}

void keyPressed() {
  switch(key) {
    case('o'):
    open_file();
    break;
    case('O'):
    open_sequence();
    break;
    case('s'):
    save_file();
    break;
    case(' '):
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

public void open_sequence() {
  selectFolder("Select a file to process:", "seqSelection");
}

void seqSelection(File sequence) {
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
  selectFolder("Select a file to process:", "outputFolderSelection");
}

void outputFolderSelection(File output) {
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    outputPath = output.getAbsolutePath();
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
  for(int i = 0; i < files.length ; i++){
    sequence[i]=loadImage(files[i].getAbsolutePath());
  }
  println("Image sequence loaded!");
  println(sequence.length + " images in folder.");
}


void save_image(String thePath) {
  //output.save(thePath + ".PNG");
}