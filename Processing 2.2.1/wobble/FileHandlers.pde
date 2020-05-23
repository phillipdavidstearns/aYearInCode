String outputPath;
int frameIndex;

boolean run = true;
boolean save = false;
boolean loaded = false;


void open_file() {
  noLoop();
  run=false;
  loaded = false;
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
  println("loading: "+thePath+" ... ");
  src = loadImage(thePath);
  if (src != null) {
    surface.setLocation(constrain(displayWidth-src.width, 0, displayWidth-10), 0);
    surface.setSize(src.width, src.height);
    buffer = src.copy();
    loaded=true;
  } else {
    println("Image failed to load.");
  }
  
}


public void save_file() {
  noLoop();
  run=false;
  selectOutput("Select a file to process:", "outputSelection");
}

void outputSelection(File output) {
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    save_still(output.getAbsolutePath());
  }
}

void save_still(String thePath) {
  saveFrame(thePath);
}

public void save_sequence() {
  noLoop();
  run=false;
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
  frameIndex=0;
}
