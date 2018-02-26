void openImage() {
  play=false;
  selectInput("Select an image to open:", "inputSelected");
}

void inputSelected(File selection) {
  String path;
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    path = selection.getAbsolutePath();
    println("User selected " + path);
    loadInput(path);
  }
}

void loadInput(String path) {
  output = null;
  input = loadImage(path);
  surface.setSize(input.width, input.height);
  generateGrid();
  output=input.copy();
  image(output, 0, 0);
}

void saveImage() {
  selectOutput("Save to file:", "outputSelected");
}

void outputSelected(File selection) {
  String path;
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    path = selection.getAbsolutePath()+".png";
    println("User selected " + path);
    saveOutput(path);
  }
}

void saveOutput(String path) {
  saveFrame(path);
}


void selectRecordPath(){
  selectOutput("Save to file:", "recordPathSelected");
}

void recordPathSelected(File selection) {
  String path;
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    path = selection.getAbsolutePath();
    println("User selected " + path);
    recordPath=path;
  }
}