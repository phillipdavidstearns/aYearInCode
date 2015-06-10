PImage frame;
PImage preview;
color[][] frames;
int qty_pixels;
int qty_frames;
int frame_index;
String path="frames/swift/";
String file="swift-";
String extension=".png";
int sigfigs = 3;
int threshold_1_hi = 125;
int threshold_1_lo = 125;
int threshold_2_hi = 225;
int threshold_2_lo = 225;

void setup() {
  frame = loadImage(path+file+nf(0, sigfigs)+extension);
  preview = frame.get();
  size(frame.width, frame.height);
  image(frame, 0, 0);
  qty_pixels = frame.width * frame.height;
  qty_frames = 360;
  frame_index = 0;
  frames = new color[qty_pixels][qty_frames];
}

void draw() {
  image(preview, 0, 0);
}


void keyPressed() {
  switch(keyCode) {

  case 76:
    loadFrames();
    break;
  case 83:
    sortFrames();
    break;
  case 79:
    writeOutput();
    break;
  case 91: // [ decreases frame_index for preview
    if (frame_index > 0) {
      frame_index--;
      println("frame_index decresed to: " + frame_index);
    } else {
      frame_index = 0;
      println("frame_index minimum reached: " + frame_index);
    }
    previewFrame(frame_index);
    break;
  case 93: // ] increases frame_index for preview
    if (frame_index < qty_frames-1) {
      frame_index++;
      println("frame_index increased to: " + frame_index);
    } else {
      frame_index = qty_frames-1;
      println("frame_index maximum reached: " + frame_index);
    }
    previewFrame(frame_index);
    break;
  case 38: // UPARROW increases threshold_1_hi
    if (threshold_1_hi < 255) {
      threshold_1_hi++;
      println("threshold_1_hi: " + threshold_1_hi);
    }
    break;
  case 40: // DOWNARROW decreases threshold_1_hi
    if (threshold_1_hi > 0) {
      threshold_1_hi--;
      println("threshold_1_hi: " + threshold_1_hi);
    }
    break;
  case 37: // LEFTARROW decreases threshold_1_lo
    if (threshold_1_lo < 255) {
      threshold_1_lo--;
      println("threshold_1_lo: " + threshold_1_lo);
    }
    break;
  case 39: // RIGHTARROW increases threshold_1_lo
    if (threshold_1_lo > 0) {
      threshold_1_lo++;
      println("threshold_1_lo: " + threshold_1_lo);
    }
    break;

  case 46: // > increases threshold_2_hi
    if (threshold_2_hi < 255) {
      threshold_2_hi++;
      println("threshold_2_hi: " + threshold_2_hi);
    }
    break;
  case 44: // < decreases threshold_2_hi
    if (threshold_2_hi > 0) {
      threshold_2_hi--;
      println("threshold_2_hi: " + threshold_2_hi);
    }
    break;
  case 45: // - decreases threshold_2_lo
    if (threshold_2_lo < 255) {
      threshold_2_lo--;
      println("threshold_2_lo: " + threshold_2_lo);
    }
    break;
  case 61: // + increases threshold_2_lo
    if (threshold_2_lo > 0) {
      threshold_2_lo++;
      println("threshold_1_lo: " + threshold_2_lo);
    }
    break;
  }
}


PImage previewFrame(int _frame_index) {
  println("previewing frame: " + _frame_index);
  preview.loadPixels();
  for (int i = 0; i < frame.pixels.length; i++) {
    preview.pixels[i] = frames[i][frame_index];
  }
  preview.updatePixels();
  return preview;
}

void loadFrames() {
  frame_index = 0 ;
  println("loading frames...");
  while (frame_index < qty_frames) {
    frame = loadImage(path+file+nf(frame_index, sigfigs)+extension);
    frame.loadPixels();
    for (int i = 0; i < frame.pixels.length; i++) {
      frames[i][frame_index] = frame.pixels[i];
    }
    frame_index++;
  }
  println("finished loading frames");
  frame_index = 0;
}

void sortFrames() {
  println("sorting frame data...");
  for (int i = 0; i < frames.length; i++) {
    frames[i] = thresholdSort(frames[i], color(threshold_1_hi), color(threshold_1_lo), 0, 1);
    frames[i] = thresholdSort(frames[i], color(threshold_2_hi), color(threshold_2_lo), 1, 0);
  }
  println("finished sorting frame data.");
  previewFrame(frame_index);
}

void writeOutput() {
  println("saving output.");
  frame_index = 0;
  while (frame_index < qty_frames) {
    for (int i = 0; i < frame.pixels.length; i++) {
      frame.pixels[i] = frames[i][frame_index];
    }
    frame.save(path+"processed/"+file+"processed-"+nf(frame_index, sigfigs)+extension);
    frame_index++;
  }
  println("done!");
  frame_index = 0;
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
        if (_reverse == 1) {
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
        if (_reverse == 1) {
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

