PImage input;
PImage output;

void setup() {
  size(10, 10);
  surface.setResizable(true);
  println("Convert from 768 x 1000 design file to 768 x 1025.");
  println("Written to create designs for Pure Country Weaver, www.pictureweave.com");
  println("Press 'o' to load an image. Press 's' to save the converted version.");
}

void draw() {
  
  if (insertLines(input) != null) {
    output = insertLines(input); 
    surface.setSize(output.width, output.height);
    image(output, 0, 0);
    loop();
  } else {
    println("Nothing to display. Press 'o' to load an image sized 768 x 1000 px.");
    noLoop();
  }
}

PImage insertLines(PImage image) {
  
  PImage output;
  
  if (image == null) {
    println("image not loaded");
    return null;
  } else if (image.height != 1000 || image.width != 768) {
    println("incompatible image size. must be 768x1000px");
    return null;
  } else if (image.height == 1000 & image.width == 768) {
    
    output = createImage(768, 1025, RGB);
    
    output.loadPixels();
    int row = 0;
    for (int y = 0; y < output.height; y++) {
      if (y%41 == 0) {
        for (int x = 0; x < output.width; x++) {
          output.pixels[y*output.width+x] = input.pixels[row*input.width+x];
        }
      } else {
        
          for (int x = 0; x < output.width; x++) {
          output.pixels[y*output.width+x] = input.pixels[row*input.width+x];
        }
        row++;
      }
    }
    output.updatePixels();
    return output;
  }
  return null; 
}


void keyPressed() {
  switch(key) {
  case 'o':
    selectInput("Select a file to read:", "inputSelected");
    break;
  case 's':
    selectOutput("Select a file to write to:", "outputSelected");
    break;
  }
}



void outputSelected(File selection) {
  String path;
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    path = selection.getAbsolutePath();
    println("User selected " + path);
    saveOutput(path);
  }
}

void saveOutput(String path) {
  saveFrame(path);
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
  input = loadImage(path);
  redraw();
}