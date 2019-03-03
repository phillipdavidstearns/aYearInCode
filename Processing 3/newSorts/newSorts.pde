PImage noise;
boolean pause = false;

void setup() {
  size(640, 640, P2D);
  surface.setResizable(true);
  noise = createImage(width/10, height/10, RGB);
  noise.loadPixels();
  for (int i = 0; i < noise.pixels.length; i++) {
    noise.pixels[i] = int(random(0xFFFFFF));
  }
  noise.updatePixels();
  frameRate(60);
  noSmooth();
}

void draw() {
  image(enlarge(noise,10,10), 0, 0);
  if (!pause) {
    noise.pixels = mySort(noise);
  }
}

// scales the pixels of a PImage by integer multiples
PImage enlarge(PImage image, int multx, int multy) {
  PImage temp = createImage(image.width*multx, image.height*multy, RGB);
  for(int y1 = 0; y1 <  image.height ; y1++){
    for(int x1 = 0; x1 <  image.width ; x1++){
      for(int y2 = 0 ; y2 < multy ; y2++){
        for(int x2 = 0 ; x2 < multx; x2++){
            temp.pixels[(y2+(y1*multy))*temp.width+(x2+(x1*multx))]=image.pixels[y1*image.width+x1];
        }
      }
    }
  }
  return temp;
}

// key bindings
void keyPressed() {

  switch(key) {
  case 'o':
    pause=true;
    selectInput("Select a file to process:", "loadImage");
    break;
  }
  
}

void loadImage(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
  }
  noise = loadImage(selection.getAbsolutePath());
  surface.setSize(noise.width, noise.height);
  pause=false;
}

// sort all of the pixels
int[] mySort(PImage img) {
  img.loadPixels();
  for (int i = 0; i < img.pixels.length-1; i++) {
    if (img.pixels[i] > img.pixels[i+1]) {
      img.pixels = swap(img.pixels, i, i+1);
    }
  }
  img.updatePixels();
  return img.pixels;
}

// swap two values in an array
int[] swap(int[] array, int index1, int index2) {
  int temp = array[index1];
  array[index1] = array[index2];
  array[index2] = temp;
  return array;
}
