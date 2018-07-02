ArrayList<File> image_list;
int dims; //pixel dimensions to scale cropped images to
int folder_depth;
String dir_name;

void setup() {
  dir_name="converted"; // name of the directory to save coverted images in (located in same path as image)
  dims = 256; // final square dimensions to output
  folder_depth = 1; //how many sub directories to process
  image_list = new ArrayList<File>();
  println("Type 'o' to select a folder to process images from.");
  noLoop();
}

void draw() {
}

//------------------------------------------------------------------
//keybindings
//------------------------------------------------------------------

void keyPressed() {
  switch(key) {
  case 'o':
    selectFolder("Select a folder to process, or press 'esc' to cancel...", "folderSelected");
    break;
  }
}

//------------------------------------------------------------------
//handler for opening a folder
//------------------------------------------------------------------

void folderSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    image_list.clear();
    getImages(selection, folder_depth);
    processImages(image_list);
  }
}

//------------------------------------------------------------------
//recursively goes through folders to find images. Paths are added to an ArrayList<File>
//------------------------------------------------------------------

void getImages(File _dir, int depth) {
  if (_dir!=null) {
    File[] dir = _dir.listFiles();
    println("Grabbing images from: "+_dir);
    println("Depth: "+depth);
    for (int i = 0; i < dir.length; i++) {
      if (dir[i].isHidden()) {
      } else if (dir[i].isDirectory() && depth > 0) {
        depth--;
        getImages(dir[i], depth);
        depth++;
      } else if (dir[i].isFile() && isImage(dir[i])) {
        image_list.add(dir[i]);
      }
    }
  } else {
    println("Press 'o' to choose a folder...");
  }  
  println("Done!");
  println("Images found:"+image_list.size());
}

//------------------------------------------------------------------
//goes through an ArrayList<File> and loads each image, crops, scales, and saves
//------------------------------------------------------------------

void processImages(ArrayList<File> _images) {
  int errors = 0;
  int images = 0;
  println("Processing Images...");
  for (File f : _images) {
    String path = f.getPath();
    String[] path_parsed = path.split("/");
    String filename = path_parsed[path_parsed.length-1];
    String save_path = new String();
    for (int p = 0; p < path_parsed.length-1; p++) {
      save_path+=path_parsed[p]+"/";
      if (p == path_parsed.length-2) save_path+=dir_name+"/";
    }
    PImage temp;
    try {
      temp = loadImage(path);
    } 
    catch (Exception e) {
      e.printStackTrace();
      temp = null;
      errors++;
    }
    if (temp != null && temp.width > 0 && temp.height > 0) {
      temp = cropToSquare(temp);
      temp.resize(dims, dims);
      println("Saving image at: "+save_path+filename);
      temp.save(save_path+filename);
      images++;
    }
  }
  println("Images imported: "+images);
  println("Errors: "+errors);
  println("Done!");
}

//------------------------------------------------------------------
//crops an image to a square around its center
//------------------------------------------------------------------

PImage cropToSquare(PImage _image) {  
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
  } else if (_image.width == _image.height){
    return _image;
  } else if (_image.width == -1 || _image.height == -1){
    println("Error: Image width or height = -1");
    return null;
  } else {
    println("Error: Something went seriously wrong");
    return null;
  }
  return img;
}

//------------------------------------------------------------------
//quick check to see if the file extension is a common image format
//------------------------------------------------------------------

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
