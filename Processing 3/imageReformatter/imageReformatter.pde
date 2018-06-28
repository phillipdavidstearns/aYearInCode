File folder;
ArrayList<File> images;
ArrayList<PImage> cropped_scaled;
int counter;
int dims; //pixel dimensions to scale cropped images to
boolean ready;

void setup() {
  dims = 256;
  counter = 0;
  images = new ArrayList<File>();
  cropped_scaled = new ArrayList<PImage>();
}

void draw() {

  if (ready) {
    PImage img = cropped_scaled.get(counter);
    surface.setSize(img.width, img.height);
    image(img, 0, 0);
    if (counter<images.size()-1) {
      counter++;
    } else {
      counter = 0;
    }
  }
}

void keyPressed() {
  switch(key) {
  case 'o':
    selectFolder("Select a folder to process:", "folderSelected");
    break;
  case 'p':
    break;
  }
}

void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    folder = selection;
    println("User selected " + selection.getAbsolutePath());
    println("Items in folder: "+ selection.listFiles().length);
    ready=false;
    getImages(folder);
    processImages(images);
    ready=true;
  }
}

void getImages(File _dir) {
  images.clear();
  if (_dir!=null) {
    File[] dir = _dir.listFiles();
    println("Grabbing images from: "+_dir);
    for (int i = 0; i < dir.length; i++) {
      if (dir[i].isHidden()) {
      } else {
        if (dir[i].isDirectory()) {
          getImages(dir[i]);
        } else if (dir[i].isFile()) {
          if (isImage(dir[i])) {
            images.add(dir[i]);
          }
        } else {
          println("error: something went wrong...");
        }
      }
    }
  } else {
    println("Press 'o' to choose a folder...");
  }
  println("Done!");
  println("Images found:"+images.size());
}

void processImages(ArrayList<File> _images) {
  int errors = 0;
  int images = 0;
  cropped_scaled.clear();
  println("Processing Images...");
  for (File f : _images) {
    PImage temp;
    println("Image: "+f.getPath());
    try {
      temp = loadImage(f.getPath());
    } catch (Exception e) {
      e.printStackTrace();
      temp = null;
      errors++;
    }
    if (temp != null && temp.width > 0 && temp.height > 0) {
      temp = cropToSquare(temp);
      temp.resize(dims, dims);
      cropped_scaled.add(temp);
      images++;
    }
  }
  println("Images imported: "+images);
  println("Errors: "+errors);
  println("Done!");
}

PImage cropToSquare(PImage _image) {
  print("cropping...");
  PImage img;
  if (_image.width > _image.height) {
    img = createImage(_image.height, _image.height, RGB);
    img.loadPixels();
    _image.loadPixels();
    for (int y = 0; y < img.height; y++) {
      for (int x = 0; x < img.width; x++) {
        img.pixels[y*img.width+x]=_image.pixels[y*_image.width+(x+int((_image.width-_image.height)/2))];
      }
    }
  } else if (_image.width < _image.height) {
    img = createImage(_image.width, _image.width, RGB);
    img.loadPixels();
    _image.loadPixels();
    for (int y = 0; y < img.height; y++) {
      for (int x = 0; x < img.width; x++) {
        img.pixels[y*img.width+x]=_image.pixels[(y+int((_image.height-_image.width)/2))*_image.width+x];
      }
    }
  } else {
    println("Done!");
    return _image;
  }
  println("Done!");
  return img;
}

boolean isImage(File file) {
  String filename = file.getPath();
  String[] split = split(filename, ".");
  String ext = (split[split.length-1].toString()).toLowerCase();
  return (
    ext.equals("png") ||
    ext.equals("gif") ||
    ext.equals("jpg") ||
    ext.equals("jpeg") ||
    ext.equals("jp2") ||
    ext.equals("bmp") ||
    ext.equals("tif") ||
    ext.equals("tiff")
    );
}
