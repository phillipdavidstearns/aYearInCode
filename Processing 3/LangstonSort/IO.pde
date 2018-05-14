// Opening an Image
void openImage() {
  selectInput("Select an image to open:", "inputSelected");
}
//--------------------------------------------------------------------------------------------
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
//--------------------------------------------------------------------------------------------
void loadInput(String path) {
  input = loadImage(path);
  output=input.copy();
  surface.setSize(input.width, input.height);
  randomizeAnts();
}
//--------------------------------------------------------------------------------------------
//Saving an Image
void saveImage() {
  selectOutput("Save to file:", "outputSelected");
}
//--------------------------------------------------------------------------------------------
void outputSelected(File selection) {
 
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String[] temp = split(selection.getAbsolutePath(),'.');
    String path = temp[0]+".png";
    println("User selected " + path);
    saveOutput(path);
  }
}
//--------------------------------------------------------------------------------------------
void saveOutput(String path) {
  saveFrame(path);
}
//--------------------------------------------------------------------------------------------
// Setting up a record path
void selectRecordPath(){
  selectOutput("Save to file:", "recordPathSelected");
}
//--------------------------------------------------------------------------------------------
void recordPathSelected(File selection) {
  if (selection == null) {
    controls.cp5.getController("recordToggle").setValue(0);
    println("Window was closed or the user hit cancel.");
  } else {
    String[] temp = split(selection.getAbsolutePath(),'.');
    String path = temp[0];
    println("User selected " + path);
    recordPath=path;
  }
}
