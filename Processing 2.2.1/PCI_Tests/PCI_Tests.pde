color[] palette;
String path;

void setup() {
  size(768, 1000);
  noLoop();
}

void draw() {
}

void keyPressed() {
  switch(key) {
  case 'o':
    selectInput("Select a file to process:", "fileSelected");
    break;
  case 'p':
    renderPalette(6);
    redraw();
    break;
  case 's':
    save_file();
    break;
  case 'b':
    renderBars(10, 0);
    redraw();
    break;
  }
}

void save_file() {
  selectOutput("Select a file to process:", "outputSelection");
}

void outputSelection(File output) {
  String _thePath;
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    _thePath = output.getAbsolutePath();
    saveData(_thePath);
  }
}

void saveData(String _thePath) {
  saveFrame(_thePath);
  println("Done Saving! " + _thePath);
}

void renderBars(int num_div, int line_div) {
  loadPixels();
  //for (int y = 0; y < height; y++) {
  // for (int div = 0 ; div < num_div; div++) {
  //   for (int x = div * width/num_div; x < (width/num_div) + div * width/num_div; x++) {
  //     if (x <= width) {
  //       pixels[y*width+x] = color(255*(y/(div+1+line_div) % 2));
  //     }
  //   }
  // }
  //}
  
  for (int x = 0; x < width; x++) {
   for (int div = 0 ; div < num_div; div++) {
     for (int y = div * height/num_div; y < (height/num_div) + div * height/num_div; y++) { 
       if(pixels[y*width+x] == color(0) && (x/(div+1+line_div)) % 2 == 0){
         pixels[y*width+x] = color(255); 
       } else if(pixels[y*width+x] == color(255) && (x/(div+1+line_div)) % 2 == 0){
         pixels[y*width+x] = color(0);
       } else {
         pixels[y*width+x] = color(255* ((x/(div+1+line_div)) % 2));
       }
     }
   }
  }
  updatePixels();
}

void renderPalette(int num_div) {
  loadPixels();
  for (int y = 0; y < height; y++) {
    for (int div = 0 ; div < num_div; div++) {
      for (int x = div * width/num_div; x < (width/num_div) + div * width/num_div; x++) {
        if (x <= width) {
          pixels[y*width+x] = palette[y/(div+1) % palette.length];
        }
      }
    }
  }
  updatePixels();
}

color[] loadPalette(String _path) {
  println("loading sequence: " + _path);
  Table _table = loadTable(_path, "tsv");
  color[] _palette = new color[_table.getRowCount()];

  for (int row = 0; row < _table.getRowCount(); row++) {
    _palette[row] = color(_table.getInt(row, 0), _table.getInt(row, 1), _table.getInt(row, 2));
  }
  println("sequence loaded");
  return _palette;
}



void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    path = selection.getAbsolutePath();
    println("User selected " + path);
    palette = loadPalette(path);
  }
}