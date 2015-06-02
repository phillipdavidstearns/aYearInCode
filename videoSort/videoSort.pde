PImage frame;
color[][] frames;
int qty_pixels;
int qty_frames;
int frame_index;

void setup(){
  frame = loadImage("frames/aerial-1280/aerial-1280-0000.png");
  size(frame.width, frame.height);
  image(frame, 0, 0);
  qty_pixels = frame.width * frame.height;
  qty_frames = 500;
  frame_index = 0;
  frames = new color[qty_pixels][qty_frames];
  noLoop();
}

void draw(){
  
  //load each frame and store the pixels in frames
  while(frame_index < qty_frames){
    loadFrame();
    storePixels();
    frame_index++;
  }
  
  //sort the pixels in each frame
  for(int i = 0 ; i < frames.length; i++){
    frames[i] = thresholdSort(frames[i], color(135), color(120), 0, 1);
    frames[i] = thresholdSort(frames[i], color(135), color(120), 1, 0);
  }
  
  frame_index = 0;
  
  while(frame_index < qty_frames){
    outputFrame();
    frame_index++;
  }
  
  println("done!");
  exit();
  
     
}

void loadFrame(){
  frame = loadImage("frames/aerial-1280/aerial-1280-"+nf(frame_index,4)+".png");
}

void storePixels(){
  for(int i = 0 ; i < frame.pixels.length; i++){
    frames[i][frame_index] = frame.pixels[i];
  }
}

void outputFrame(){
  for(int i = 0 ; i < frame.pixels.length; i++){
    frame.pixels[i] = frames[i][frame_index];
  }
  frame.save("frames/aerial-1280/processed/aerial-1280-processed-"+nf(frame_index,4)+".png");
}

color[] thresholdSort(color[] _array, int _threshold_pos, int _threshold_neg, int _mode, int _reverse) {

  color[] _buffer;
  boolean section = false;
  int beginning = 0;
  int section_length=0;

  switch(_mode) {

    //sorts above threshold  
  case 0:
    for (int i = 0; i < _array.length; i++) {
      if (_array[i] >= _threshold_pos && !section) {
        section = true;
        section_length=1;
        beginning = i;
      } else if (_array[i] >= _threshold_neg && section) {
        section_length++;
      }
      if (_array[i] < _threshold_neg && section || i >= _array.length-1) {
        _buffer = new color[section_length];
        for (int j = 0; j < _buffer.length; j++) {
          _buffer[j] = _array[beginning+j];
        }
        _buffer = sort(_buffer);
        if(_reverse == 1){
          _buffer=reverse(_buffer);
        }
          
        section = false;
        for (int k = 0; k < _buffer.length; k++) {
          _array[beginning+k] = _buffer[k];
        }
      }
    }
    break;

    //sorts below threshold
  case 1:
    for (int i = 0; i < _array.length; i++) {
      if (_array[i] <= _threshold_neg && !section) {
        section = true;
        section_length=1;
        beginning = i;
      } else if (_array[i] <= _threshold_pos && section) {
        section_length++;
      }
      if (_array[i] > _threshold_pos && section || i >= _array.length-1) {
        _buffer = new color[section_length];
        for (int j = 0; j < _buffer.length; j++) {
          _buffer[j] = _array[beginning+j];
        }
        
          _buffer = sort(_buffer);
          if(_reverse == 1){
          _buffer=reverse(_buffer);
        }
        
        section = false;
        for (int k = 0; k < _buffer.length; k++) {
          _array[beginning+k] = _buffer[k];
        }
      }
    }
    break;
  }
  return _array;
}
