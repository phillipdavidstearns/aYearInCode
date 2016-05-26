PImage input, buffer, output; //don't know that I need so many PImages to pass data around...
int displaySource=1; // index to indicate which PImage is to be displayed. 0 = output, 1 = input, 2 = buffer.
PImage test;
void setup() {
  size(100, 100);
  surface.setResizable(true);


}

void draw() {

  if (input!=null) {
    changeDiagonalPixels(input);
    display(displaySource);
  }
  
  
}

void changeDiagonalPixels(PImage image) {
  image.loadPixels();
  for (int i = 0; i < image.width+image.height-1; i++) {
    drawDiagonal(image, i, stepSort(getDiagonal(image, i)));
  }
  image.updatePixels();
}

int[] stepSort(int[] array){
  for(int i = 0 ; i < array.length-1 ; i++){
    if(array[i] > array[i+1]){
    array = swap(array, i, i+1);
    }
  }
  return array;
}

void drawDiagonal(PImage image, int index, int[] array) {

  if (index >= 0 && index < image.height + image.width - 1) {
    int x=0;
    int y=0;

    if (image.height > image.width) { // portrait images
      if (index < image.width) {
        x=0;
        y = index;
      } else if (index >= image.width && index < image.height) {
        x=0;
        y = index;
      } else if (index >= image.height) {
        x = index - image.height;
        y = image.height-1;
      } else {
        println("drawDiagonal portrait mode: index out of bounds");
      }
    } else if (image.height <= image.width) { // 1:1 and landscape images
      if (index < image.height) {
        x=0;
        y = index;
      } else if (index >= image.height && index < image.width) {
        x = index - (image.height-1);
        y = image.height-1;
      } else if (index >= image.width) {
        x = index - (image.height-1);
        y = image.height-1;
      } else {
        println("drawDiagonal 1:1 and landscape mode: index out of bounds");
      }
    } else {
      println("error: unknown image aspect ratio");
    }

    
    for (int i = 0; i < array.length; i++) {
      image.pixels[y*image.width+x] = array[i];
      y--;
      x++;
    }
  } else {
    println("index out of bounds");
  }
}

int[] getDiagonal(PImage image, int index) {
  if (index >= 0 && index < image.height + image.width - 1) {
    int[] array;
    int x;
    int y;

    if (image.height > image. width) { // portrait images
      if (index < image.width) {
        x=0;
        y = index;
        array = new int[y+1];
      } else if (index >= image.width && index < image.height) {
        x=0;
        y = index;
        array = new int[image.width];
      } else if (index >= image.height) {
        x = index - image.height;
        y = image.height-1;
        array = new int[image.width-x];
      } else {
        println("portrait mode: index out of bounds");
        return null;
      }
    } else if (image.height <= image.width) { // 1:1 and landscape images
      if (index < image.height) {
        x=0;
        y = index;
        array = new int[y+1];
      } else if (index >= image.height && index < image.width) {
        x = index - (image.height-1);
        y = image.height-1;
        array = new int[image.height];
      } else if (index >= image.width) {
        x = index - (image.height-1);
        y = image.height-1;
        array = new int[image.width-x];
      } else {
        println("1:1 and landscape mode: index out of bounds");
        return null;
      }
    } else {
      println("error: unknown image aspect ratio");
      return null;
    }
    //println("index: "+index+", x: "+ x+", y: "+y+", array.length: "+array.length);
    
    for (int i = 0; i < array.length; i++) {
      array[i] = image.pixels[y*image.width+x];
      y--;
      x++;
    }

    return array;
  } else {
    println("index out of bounds");
    return null;
  }
}

void display(int mode) {
  switch(mode) {
  case 0:
    image(output, 0, 0);
    break;
  case 1:
    image(input, 0, 0);
    break;
  case 2:
    image(buffer, 0, 0);
    break;
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
  selectInput("Select a file to process:", "seqSelection");
}

void seqSelection(File sequence) {
  if (input == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + sequence.getAbsolutePath());
    //parsePath();
    //load_sequence(sequence.getAbsolutePath());
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

void load_image(String thePath) {
  input = loadImage(thePath);
  buffer = createImage(input.width, input.height, RGB);
  output = createImage(input.width, input.height, RGB);
  surface.setSize(input.width, input.height);
}

void load_sequence(String thePath, int index) {
}

void save_image(String thePath) {
  output.save(thePath + ".PNG");
}

int[] swap(int[] array, int index1, int index2) {
  int temp = array[index1];
  array[index1] = array[index2];
  array[index2] = temp;
  return array;
}