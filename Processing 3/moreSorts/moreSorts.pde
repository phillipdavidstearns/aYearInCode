PImage image;
boolean pause = false;
boolean done = false;
int lowerLimit = 0xFF000000;
int upperLimit = 0xFFFFFFFF;


void setup() {
  size(640, 640, P2D);
  surface.setResizable(true);
  image = createImage(width, height, RGB);
  image.loadPixels();
  for (int i = 0; i < image.pixels.length; i++) {
    image.pixels[i] = int(random(0xFFFFFF))|0xFF000000;
  }
  image.updatePixels();
  frameRate(30);
  noSmooth();
}

void draw() {
  if (image != null) {
    if (!pause) {
      image(image, 0, 0);
      image.loadPixels();
      sortPImage(image);
      image.updatePixels();
      //saveFrame("output/002/sort_test_002_######.png");
      //if (done) {
      //  println(frameCount);
      //  exit();
      //}
    }
  }
}



void keyPressed() {

  switch(key) {
  case 'o':
    pause=true;
    selectInput("Select a file to process:", "loadImage");
    break;
  }
}

PImage sortPImage(PImage img) {
  for (int y = 0; y < img.height; y++) {
    int[] temp = mySort(row(img, y), 1);
    for (int x = 0; x < img.width; x++) {
      img.pixels[y*img.width+x]=temp[x];
    }
  }

  for (int x = 0; x < img.width; x++) {
   int[] temp = mySort(col(img, x), 1);
   for (int y = 0; y < img.height; y++) {
     img.pixels[y*img.width+x]=temp[y];
   }
  }

  return image;
}

int[] row(PImage img, int row) {
  int[] temp = new int[img.width];
  if (row >= img.height && row >= 0) {
    println("Invalid row #");
  } else {
    for (int x = 0; x < img.width; x++) {
      temp[x] = img.pixels[row*img.width+x];
    }
  }
  return temp;
}

int[] col(PImage img, int col) {
  int[] temp = new int[img.height];
  if (col >= img.width && col >= 0) {
    println("Invalid col #");
  } else {
    for (int y = 0; y < img.height; y++) {
      temp[y] = img.pixels[y*img.width+col];
    }
  }
  return temp;
}

int[] mySort(int[] array, int dir) {
  done = true;
  for (int i = 0; i < array.length-1; i++) {
    int a = array[i];
    int b = array[i+1];
    if (a >= lowerLimit && a <= upperLimit && b >= lowerLimit && b <= upperLimit) {
      switch(dir) {
        case 0:
        if (a > b) {
          array = swap(array, i, i+1);
          done = false;
        }
        break;
        case 1:
        if (a < b) {
          array = swap(array, i, i+1);
          done = false;
        }
        break;
      }
    }
  }

  return array;
}

int[] swap(int[] array, int index1, int index2) {
  int temp = array[index1];
  array[index1] = array[index2];
  array[index2] = temp;
  return array;
}


void loadImage(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
  }
  image = loadImage(selection.getAbsolutePath());
  surface.setSize(image.width, image.height);
  pause=false;
  redraw();
}