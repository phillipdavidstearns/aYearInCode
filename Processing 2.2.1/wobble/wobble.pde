PImage source;
PImage output;
String path;
String file;

void setup(){
  path = "/";
  file = "test.jpg";
  source = loadImage(path+file);
  size(source.width, source.height);
  noLoop();
}

void draw(){
  output = shiftRows(source);
  output = shiftColummns(source);
  image(source, 0, 0);
}

PImage shiftRows(PImage _image){
  int[] _row = new int[_image.width];
  for(int i = 0 ; i < _image.width; i++){
    _row = shift(_row);
  }
  return _image;
}
 
PImage shiftColummns(PImage _image){
  int[] _col = new int[_image.height];
  for(int i = 0 ; i < _image.height; i++){
    _col = shift(_col);
  }
  return _image;
}


int[] shift(int[] _pixels){
  return _pixels;
}


