

public void open_file() {
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
  print("loading: "+thePath+" ... ");
  src = loadImage(thePath);
  surface.setSize(src.width, src.height);
  buffer = createImage(src.width, src.height, ARGB);

  if (src != null) {
    initializeFlock(block_size);
    println("Done!");
    loaded=true;
  } else {
    println("Image failed to load.");
  }
  
  displaySrc();
}


public void save_file() {
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
  saveFrame(thePath+".png");
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
  frameIndex=0;
}