/**
 * ControlP5 Controlframe
 * with controlP5 2.0 all java.awt dependencies have been removed
 * as a consequence the option to display controllers in a separate
 * window had to be removed as well. 
 * this example shows you how to create a java.awt.frame and use controlP5
 *
 * by Andreas Schlegel, 2012
 * www.sojamo.de/libraries/controlp5
 *
 */

import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;

private ControlP5 cp5;

ControlFrame cf;

boolean sort_issued = false;

PImage src;
PImage buffer;
PImage display;

int screen_width = 384;
int screen_height = 512;

void setup() {
  setScreenSize(screen_width, screen_height);
  if (frame != null) {
    frame.setResizable(true);
  }

  src = createImage(screen_width, screen_height, RGB);
  buffer = createImage(screen_width, screen_height, RGB);
  display = createImage(screen_width, screen_height, RGB);

  loadData("utah.jpg");

  cp5 = new ControlP5(this);
  frameRate(30);
  // by calling function addControlFrame() a
  // new frame is created and an instance of class
  // ControlFrame is instanziated.
  cf = addControlFrame("GUI", 500, 200);

  // add Controllers to the 'extra' Frame inside 
  // the ControlFrame class setup() method below.
  image(src, 0, 0);
}

void draw() {
  loadBuffer(src);
  pixel_sort(0);
  loadPixels();
  if (frameCount < 120) {
    saveFrame("output/landscape/landscape_test-####.png");
  }
}

void loadBuffer(PImage _image) {
  _image.loadPixels();
  buffer.loadPixels();
  for (int i = 0; i < _image.pixels.length; i++) {
    buffer.pixels[i]=_image.pixels[i];
  }
  buffer.updatePixels();
}

void loadData(String thePath) {
  src = loadImage(thePath);
  buffer = new PImage(src.width, src.height);
  display = new PImage(src.width, src.height);
  loadBuffer(src);
  setScreenSize(src.width, src.height);
}

void saveData(String thePath) {
  src.save(thePath+".TIF");
  //  saveFrame(thePath+".TIF");
  //  PImage output = createImage(width, height, RGB);
  //  for(int i = 0 ; i < output.pixels.length ; i++){
  //    output.pixels[i] = pixels[i];
  //  }
  //  output.save(thePath+".TIF");
}

void pixel_sort(int _mode) {
  buffer.loadPixels();
  src.loadPixels();

  int pos = frameCount%255;
  int neg = frameCount%255;
  //  int pos = 0;
  //  int neg = 0;

  int pos_color = color(int(random(255)), int(random(255)), int(random(255)));
  int neg_color = color(int(random(255)), int(random(255)), int(random(255)));

  switch(int(random(2))) {

  case 0:
    int _thedir = 0;
    int _theend;
    
    if(_thedir == 0){
      _theend = buffer.height;
    } else {
      _theend = buffer.width;
    }
    buffer = sortPixels (buffer, 0, _theend, pos_color, neg_color, _thedir, prob(10), int(random(2)));
    break;

  case 1:
    int[] _pos = {int(random(255)),int(random(255)),int(random(255))};
    int[] _neg = {int(random(255)),int(random(255)),int(random(255))};
    boolean r = prob(50);
    boolean g = prob(50);
    boolean b = prob(50);
    boolean[] _reverse = {r,g,b};
    int[] mode = {int(random(2)),int(random(2)),int(random(2))};
    int _dir = int(random(2));
    int end;
    if(_dir == 0){
      end = buffer.height;
    } else {
      end = buffer.width;
    }
    
    buffer = sortPixelsRGB (buffer, 0, end,  _pos, _neg, _dir , _reverse, mode);
    
    break;
  }
  buffer.updatePixels();  
  image(buffer, 0, 0);
}

boolean prob(float _prob){
  if(_prob >= random(100)){
    return true;
  } else {
    return false;
  }
}

PImage sortPixelsRGB (PImage _image, int _start, int _end,  int[] _pos, int[] _neg, int _dir, boolean[] _reverse, int[] _mode){
 
  int[] r_buffer;
  int[] g_buffer;
  int[] b_buffer;
  
  if(_dir == 0){
    r_buffer = new int[_image.width];
    g_buffer = new int[_image.width];
    b_buffer = new int[_image.width];
  } else {  
    r_buffer = new int[_image.height];
    g_buffer = new int[_image.height];
    b_buffer = new int[_image.height];
  }
  
  for (int a = _start; a < _end; a++) {
    for (int b = 0; b < r_buffer.length; b++) {
      
      if(_dir == 0){
        r_buffer[b] = _image.pixels[a*_image.width+b] >> 16 & 0xFF;
        g_buffer[b] = _image.pixels[a*_image.width+b] >> 8 & 0xFF;
        b_buffer[b] = _image.pixels[a*_image.width+b] & 0xFF;
      } else {
        r_buffer[b] = _image.pixels[b*_image.width+a] >> 16 & 0xFF;
        g_buffer[b] = _image.pixels[b*_image.width+a] >> 8 & 0xFF;
        b_buffer[b] = _image.pixels[b*_image.width+a] & 0xFF;
      }
      
    }

    r_buffer = thresholdSort(r_buffer, _pos[0], _neg[0], _reverse[0], _mode[0]);
    g_buffer = thresholdSort(g_buffer, _pos[1], _neg[1], _reverse[1], _mode[1]);
    b_buffer = thresholdSort(b_buffer, _pos[2], _neg[2], _reverse[2], _mode[2]); 

    for (int b = 0; b < r_buffer.length; b++) {
      
      if(_dir == 0){
        _image.pixels[a*_image.width+b]= 255 << 24 | r_buffer[b] << 16 | g_buffer[b] << 8 | b_buffer[b];
      } else {
        _image.pixels[b*_image.width+a]= 255 << 24 | r_buffer[b] << 16 | g_buffer[b] << 8 | b_buffer[b];
      }
    }
  }
  return _image;
}

PImage sortPixels (PImage _image, int _start, int _end, int _pos, int _neg, int _dir, boolean _reverse, int _threshold_mode) { 

  int buffer_index = 0;
  int[] px_buffer;

  if (_dir == 0) {
    px_buffer = new int[_image.width];
  } else {
    px_buffer = new int[_image.height];
  }

  for (int a = _start; a < _end; a++) {
    for (int b = 0; b < px_buffer.length; b++) {
      if (_dir == 0) {
        px_buffer[b] = _image.pixels[a*_image.width+b];
      } else if (_dir == 1) {
        px_buffer[b] = _image.pixels[b*_image.width+a];
      }
    }

    px_buffer = thresholdSort(px_buffer, _pos, _neg, _reverse, _threshold_mode);
    
    for (int b = 0; b < px_buffer.length; b++) {
      if (_dir == 0) {
        _image.pixels[a*_image.width+b] = px_buffer[b];
      } else if (_dir == 1) {
        _image.pixels[b*_image.width+a] = px_buffer[b];
      }
    }
  }
  return _image;
}

int[] thresholdSort(int[] _array, int _threshold_pos, int _threshold_neg, boolean _reverse, int _mode) {
  int[] _buffer;
  boolean section = false;
  int beginning = 0;
  int section_length=0;

  switch(_mode) {
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
        _buffer = new int[section_length];
        for (int j = 0; j < _buffer.length; j++) {
          _buffer[j] = _array[beginning+j];
        }
        _buffer = sort(_buffer);

        if (_reverse) {
          _buffer = reverse(_buffer);
        }

        section = false;
        for (int k = 0; k < _buffer.length; k++) {
          _array[beginning+k] = _buffer[k];
        }
      }
    }
    break;

  case 1:
    for (int i = 0; i < _array.length; i++) {
      if (_array[i] < _threshold_neg && !section) {
        section = true;
        section_length=1;
        beginning = i;
      } else if (_array[i] <= _threshold_pos && section) {
        section_length++;
      }
      if (_array[i] > _threshold_pos && section || i >= _array.length-1) {
        _buffer = new int[section_length];
        for (int j = 0; j < _buffer.length; j++) {
          _buffer[j] = _array[beginning+j];
        }
        _buffer = sort(_buffer);

        if (_reverse) {
          _buffer = reverse(_buffer);
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


public int sketchWidth() {
  return displayWidth;
}

public int sketchHeight() {
  return displayHeight;
}

public String sketchRenderer() {
  return P2D;
}

void setScreenSize(int _width, int _height) {
  frame.setSize(_width, _height+22);
}

