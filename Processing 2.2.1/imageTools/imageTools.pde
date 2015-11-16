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

LFO[] lfos;


String thePath;
boolean diagonal_a = false;
boolean diagonal_b = false;

boolean sort_issued = false;
boolean play = false;
boolean record = false;
boolean sort_x=false;
boolean sort_y=false;
boolean color_mode_x = false;
boolean color_mode_y = false;
boolean pre = true;
boolean realtime = false;
boolean shift_left = false;
boolean shift_right = false;
boolean quick = false;
boolean preview_mode = false;
boolean rand = false;
boolean automate = false;

PImage src;
PImage buffer;
PImage preview;
PImage output;

int screen_width = 384;
int screen_height = 512;

color positive_threshold = color(0);
color negative_threshold = color(0);

int r_pos=0;
int g_pos=0;
int b_pos=0;

int r_neg=0;
int g_neg=0;
int b_neg=0;

int sort_mode = 0;
int sort_by = 0;

int thresh_1 = 0;
int thresh_2 = 0;
int thresh_3 = 0;

int direction_y_r = 0;
int direction_y_g = 0;
int direction_y_b = 0;

int direction_x_r = 0;
int direction_x_g = 0;
int direction_x_b = 0;

int order_y_r = 0;
int order_y_g = 0;
int order_y_b = 0;

int order_x_r = 0;
int order_x_g = 0;
int order_x_b = 0;

int start = 0;
int end = 0;
int threshold_mode = 0;

int shift_amt_x;
int shift_amt_y;

int display_mode = 2; //0 = source, 1 = buffer, 2 = preview, 3 = output;
int capture_count = 0;
int iterations=0;

float[] inc = new float[6];
float[] phase = new float[6];

void setup() {
  setScreenSize(screen_width, screen_height);
  if (frame != null) {
    frame.setResizable(true);
  }

  cp5 = new ControlP5(this);
  frameRate(30);
  // by calling function addControlFrame() a
  // new frame is created and an instance of class
  // ControlFrame is instanziated.
  cf = addControlFrame("GUI", 1200, 800);

  // add Controllers to the 'extra' Frame inside 
  // the ControlFrame class setup() method below.

  src = createImage(screen_width, screen_height, RGB);
  buffer = createImage(screen_width, screen_height, RGB);
  output = createImage(screen_width, screen_height, RGB);
  preview = createImage(screen_width, screen_height, RGB);
  loadData("utah.jpg");
  lfos = new LFO[6];
  for(int i = 0 ; i < lfos.length ; i++){
  lfos[i] = new LFO();
  }
}

void draw() {


  //begin process
  if (play) {

    //    sortSlope();

    //y(t) = A\sin(2 \pi f t + \varphi) = A\sin(\omega t + \varphi)
    //red automation math
    if (automate) {    
      
//        println(int(256*((lfo_01.update()/2)+0.5)));
        r_pos = int(255*((lfos[0].update(inc[0], PI*(phase[0])-PI/2)/2)+0.5));
        r_neg = int(255*((lfos[1].update(inc[1], PI*(phase[1])-PI/2)/2)+0.5));
        g_pos = int(255*((lfos[2].update(inc[2], PI*(phase[2])-PI/2)/2)+0.5));
        g_neg = int(255*((lfos[3].update(inc[3], PI*(phase[3])-PI/2)/2)+0.5));
        b_pos = int(255*((lfos[4].update(inc[4], PI*(phase[4])-PI/2)/2)+0.5));
        b_neg = int(255*((lfos[5].update(inc[5], PI*(phase[5])-PI/2)/2)+0.5));
        
      if (rand) {
        r_pos = int(random(256));
        r_neg = int(random(256));
        g_pos = int(random(256));
        g_neg = int(random(256));
        b_pos = int(random(256));
        b_neg = int(random(256));
      }
    }

    makeParameters();

    if (quick) {
      loadPreview(buffer);
      //    thresholdSort(preview.pixels, positive_threshold, negative_threshold, sort_mode, threshold_mode);
      sortPixels(preview, positive_threshold, negative_threshold, sort_mode, threshold_mode);
    } else {
      for(int i = 0 ; i < iterations ; i++){
        sortPixels(preview, positive_threshold, negative_threshold, sort_mode, threshold_mode);
      }
    }
    if (shift_left) {
      shift(preview, 0);
    }
    if (shift_right) {
      shift(preview, 1);
    }
    if (record) {
      capture_count++;
      if (thePath != null) {
        preview.save(thePath+"-"+nfs(capture_count, 4)+".png");
      }
    }
  }
  //end process


  switch(display_mode) {
  case 0:
    displaySource();
    break;
  case 1:
    displayBuffer();
    break;
  case 2:
    displayPreview();
    break;
  case 3:
    displayOutput();
    break;
  }
}



void keyPressed() {
  switch(keyCode) {
  case 49:
    display_mode = 0;
    break;
  case 50:
    display_mode = 1;
    break;
  case 51:
    display_mode = 2;
    break;
  case 52:
    display_mode = 3;
    break;
  }
}

//pixel shifting

void shift(PImage _image, int _direction) {
  int[] temp;
  int start;
  int end;
  int index;

  int _random;
  switch(_direction) {
  case 0:
    index = 0;
    while (index < _image.height) {
      temp = new int[_image.width];
      start = index;
      end = start + int(random(500));
      if (end > _image.height) end = _image.height;
      index = end;
      _random = int(random(-50, 50));
      for (int y = start; y < end; y++) {
        for (int x = 0; x < _image.width; x++) {
          temp[x] = _image.pixels[y*_image.width+x];
        }
        temp = shiftPixels(temp, -int((y%45)*10>>3+3<<2)%temp.length);
        for (int x = 0; x < _image.width; x++) {
          _image.pixels[y*_image.width+x] = temp[x];
        }
      }
    }
    break;

  case 1:
    index=0;

    while (index < _image.width) {
      temp = new int[_image.height];
      start = index;
      end = start + int(random(500));
      if (end > _image.height) end = _image.height;
      index = end;
      _random = int(random(-50, 50));
      for (int x = start; x < end; x++) {
        for (int y = 0; y < _image.height; y++) {
          temp[y] = _image.pixels[y*_image.width+x];
        }
        temp = shiftPixels(temp, x);
        for (int y = 0; y < _image.height; y++) {
          _image.pixels[y*_image.width+x] = temp[y];
        }
      }
    }
    break;
  }
}

int[] shiftPixels(int[] _pixelArray, int _spaces) {
  int[] temp = new int[_pixelArray.length];
  for (int i = temp.length - 1; i >= 0; i-- ) {
    temp[(i - _spaces + temp.length) % temp.length] = _pixelArray[i];
  }
  return temp;
}


//pixelsorting

PImage sortPixels (PImage _image, color _pos, color _neg, int _sort_mode, int _threshold_mode) { 

  color[] px_buffer;
  color[] r_buffer;
  color[] g_buffer;
  color[] b_buffer;

  int index = 0;
  int x = 0;
  int y = 0; 

  if (diagonal_a) {
    if (!color_mode_x) {
      for (int i = 0; i < _image.height; i++) {
        index = 0;
        x = 0;
        y = i;
        if(i < _image.width){
          px_buffer = new color[i+1];
        } else {
          px_buffer = new color[_image.width];
        }
        while (x < _image.width && x <= i && y >= 0 && index < px_buffer.length) {
          px_buffer[index] = _image.pixels[y*_image.width+x];
          _image.pixels[y*_image.width+x]=0;
          index++;
          x++;
          y--;
        }
        px_buffer = thresholdSort(px_buffer, _pos, _neg, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);
        index=0;
        x=0;
        y=i;
        while (x < _image.width && x <= i && y >= 0 && index < px_buffer.length) {
          _image.pixels[y*_image.width+x]=px_buffer[index];
          index++;
          x++;
          y--;
        }
      }

      for (int i = 1; i < _image.width; i++) {
        index=0;
        x=i;
        y=_image.height-1;
        if(_image.width > _image.height && i < _image.width - _image.height){
          px_buffer = new color[height];
        } else {
          px_buffer = new color[width - (x)];
        }
        while (x < _image.width && y >= 0  && index < px_buffer.length) {
          px_buffer[index] = _image.pixels[y*_image.width+x];
          index++;
          x++;
          y--;
        }

        px_buffer = thresholdSort(px_buffer, _pos, _neg, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);

        index=0;
        x=i;
        y=_image.height-1;
        while (x < _image.width && y >= 0 && index < px_buffer.length) {
          _image.pixels[y*_image.width+x] = px_buffer[index];
          index++;
          x++;
          y--;
        }
      }
    }

    //RGB mode diagonal sorting
    if (color_mode_x) {
      for (int i = 0; i < _image.height; i++) {
        index = 0;
        x = 0;
        y = i;

        if(i < _image.width){
          r_buffer = new color[i+1];
          g_buffer = new color[i+1];
          b_buffer = new color[i+1];
        } else {
          r_buffer = new color[_image.width];
          g_buffer = new color[_image.width];
          b_buffer = new color[_image.width];
        }

        while (x < _image.width && x <= i && y >= 0 && index < r_buffer.length) {

          r_buffer[index] = _image.pixels[y*_image.width+x] >> 16 & 0xFF;
          g_buffer[index] = _image.pixels[y*_image.width+x] >> 8 & 0xFF;
          b_buffer[index] = _image.pixels[y*_image.width+x] & 0xFF;
          index++;
          x++;
          y--;
        }

        r_buffer = thresholdSort(r_buffer, _pos >> 16 & 0xFF, _neg >> 16 & 0xFF, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);
        g_buffer = thresholdSort(g_buffer, _pos >> 8 & 0xFF, _neg >> 8 & 0xFF, _sort_mode >> 8 & 3, _threshold_mode >> 1 & 1);
        b_buffer = thresholdSort(b_buffer, _pos & 0xFF, _neg & 0xFF, _sort_mode >> 6 & 3, _threshold_mode & 1);

        index=0;
        x=0;
        y=i;
        while (x < _image.width && x <= i && y >= 0 && index < r_buffer.length) {

          _image.pixels[y*_image.width+x]= 255 << 24 | r_buffer[index] << 16 | g_buffer[index] << 8 | b_buffer[index];

          index++;
          x++;
          y--;
        }
      }

      for (int i = 1; i < _image.width; i++) {
        index=0;
        x=i;
        y=_image.height-1;
        
        if(_image.width > _image.height && i < _image.width - _image.height){
          r_buffer = new color[height];
          g_buffer = new color[height];
          b_buffer = new color[height];
        } else {
          r_buffer = new color[width - (x)];
          g_buffer = new color[width - (x)];
          b_buffer = new color[width - (x)];
        }
        
        while (x < _image.width && y >= 0 && index < r_buffer.length) {
          r_buffer[index] = _image.pixels[y*_image.width+x] >> 16 & 0xFF;
          g_buffer[index] = _image.pixels[y*_image.width+x] >> 8 & 0xFF;
          b_buffer[index] = _image.pixels[y*_image.width+x] & 0xFF;
          index++;
          x++;
          y--;
        }

        r_buffer = thresholdSort(r_buffer, _pos >> 16 & 0xFF, _neg >> 16 & 0xFF, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);
        g_buffer = thresholdSort(g_buffer, _pos >> 8 & 0xFF, _neg >> 8 & 0xFF, _sort_mode >> 8 & 3, _threshold_mode >> 1 & 1);
        b_buffer = thresholdSort(b_buffer, _pos & 0xFF, _neg & 0xFF, _sort_mode >> 6 & 3, _threshold_mode & 1);

        index=0;
        x=i;
        y=_image.height-1;
        while (x < _image.width && y >= 0 && index < r_buffer.length) {
          _image.pixels[y*_image.width+x]= 255 << 24 | r_buffer[index] << 16 | g_buffer[index] << 8 | b_buffer[index];
          index++;
          x++;
          y--;
        }
      }
    }
  }

  if (diagonal_b) {//  starting from 0, height-1 to width-1, 0 ; picks diagonal pixels from bottom right to upper left  
    
    for (int i = 0; i < _image.width; i++) {
      index = 0;
      x = i;
      y = _image.height-1;
      
      if(_image.width > _image.height && i >= _image.height){
        px_buffer = new color[_image.height];
      } else {
        px_buffer= new color[i+1];
      }
      
      while ( x >= 0 && y >=0 && index < px_buffer.length) {
        px_buffer[index]=_image.pixels[y*_image.width+x];
        _image.pixels[y*_image.width+x]=0;
        x--;
        y--;
        index++;
      }

      px_buffer = thresholdSort(px_buffer, _pos, _neg, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);

      index = 0;
      x = i;
      y = _image.height-1;
      while ( x >=0 && y >=0 && index < px_buffer.length) {
        _image.pixels[y*_image.width+x]=px_buffer[index];
        x--;
        y--;
        index++;
      }
    }

    for (int i = 1; i < _image.height; i++) {
      index = 0;
      
      x = _image.width - 1;
      y = _image.height - 1 - i;
      if(_image.height > _image.width && i < _image.width -1 ){
        px_buffer = new color[_image.width];
      } else {
        px_buffer = new color[_image.height - i];
      }
      
      while (x >= 0 && y >= 0 && index < px_buffer.length) {
        px_buffer[index]=_image.pixels[y*_image.width+x];
        x--;
        y--;
        index++;
      }

      px_buffer = thresholdSort(px_buffer, _pos, _neg, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);


      index = 0;
      x = _image.width - 1;
      y = _image.height - 1 - i;

      while (x >= 0 && y >= 0 && index < px_buffer.length) {
        _image.pixels[y*_image.width+x]=px_buffer[index];
        x--;
        y--;
        index++;
      }
    }
  }



  if (sort_x) {
    if (!color_mode_x) {
      px_buffer = new int[_image.width];    
      for (int a = 0; a < _image.height; a++) {
        for (int b = 0; b < px_buffer.length; b++) {
          px_buffer[b] = _image.pixels[a*_image.width+b];
        }
        px_buffer = thresholdSort(px_buffer, _pos, _neg, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);
        for (int b = 0; b < px_buffer.length; b++) {
          _image.pixels[a*_image.width+b] = px_buffer[b];
        }
      }
    }
    if (color_mode_x) {
      r_buffer = new int[_image.width];
      g_buffer = new int[_image.width];
      b_buffer = new int[_image.width];

      for (int a = 0; a < _image.height; a++) {
        for (int b = 0; b < r_buffer.length; b++) {
          r_buffer[b] = _image.pixels[a*_image.width+b] >> 16 & 0xFF;
          g_buffer[b] = _image.pixels[a*_image.width+b] >> 8 & 0xFF;
          b_buffer[b] = _image.pixels[a*_image.width+b] & 0xFF;
        }

        r_buffer = thresholdSort(r_buffer, _pos >> 16 & 0xFF, _neg >> 16 & 0xFF, _sort_mode >> 10 & 3, _threshold_mode >> 2 & 1);
        g_buffer = thresholdSort(g_buffer, _pos >> 8 & 0xFF, _neg >> 8 & 0xFF, _sort_mode >> 8 & 3, _threshold_mode >> 1 & 1);
        b_buffer = thresholdSort(b_buffer, _pos & 0xFF, _neg & 0xFF, _sort_mode >> 6 & 3, _threshold_mode & 1);

        for (int b = 0; b < r_buffer.length; b++) {
          _image.pixels[a*_image.width+b]= 255 << 24 | r_buffer[b] << 16 | g_buffer[b] << 8 | b_buffer[b];
        }
      }
    }
  }

  if (sort_y) {
    if (!color_mode_y) {
      px_buffer = new color[_image.height];   
      for (int a = 0; a < _image.width; a++) {
        for (int b = 0; b < px_buffer.length; b++) {
          px_buffer[b] = _image.pixels[b*_image.width+a];
        }
        px_buffer = thresholdSort(px_buffer, _pos, _neg, _sort_mode >> 4 & 3, _threshold_mode >> 2  & 1);
        for (int b = 0; b < px_buffer.length; b++) {
          _image.pixels[b*_image.width+a] = px_buffer[b];
        }
      }
    }
    if (color_mode_y) {
      r_buffer = new color[_image.height];
      g_buffer = new color[_image.height];
      b_buffer = new color[_image.height];

      for (int a = 0; a < _image.width; a++) {
        for (int b = 0; b < r_buffer.length; b++) {
          r_buffer[b] = _image.pixels[b*_image.width+a] >> 16 & 0xFF;
          g_buffer[b] = _image.pixels[b*_image.width+a] >> 8 & 0xFF;
          b_buffer[b] = _image.pixels[b*_image.width+a] & 0xFF;
        }
        r_buffer = thresholdSort(r_buffer, _pos >> 16 & 0xFF, _neg >> 16 & 0xFF, _sort_mode >> 4 & 3, _threshold_mode >> 2 & 1);
        g_buffer = thresholdSort(g_buffer, _pos >> 8 & 0xFF, _neg >> 8 & 0xFF, _sort_mode >> 2 & 3, _threshold_mode >> 1 & 1);
        b_buffer = thresholdSort(b_buffer, _pos & 0xFF, _neg & 0xFF, _sort_mode & 3, _threshold_mode & 1);

        for (int b = 0; b < r_buffer.length; b++) {
          _image.pixels[b*_image.width+a]= 255 << 24 | r_buffer[b] << 16 | g_buffer[b] << 8 | b_buffer[b];
        }
      }
    }
  }


  return _image;
}

color[] thresholdSort(color[] _array, int _threshold_pos, int _threshold_neg, int _sort_mode, int _mode) {

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
        if (!quick) {
          _buffer = pixelSort(_buffer, _sort_mode);
        } else {
          _buffer = sort(_buffer);
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
        if (!quick) {
          _buffer = pixelSort(_buffer, _sort_mode);
        } else {
          _buffer = sort(_buffer);
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

color[] pixelSort(color[] _pixelArray, int _sort_mode) {

  if (sort_by == 0) {
    switch(_sort_mode) { 
    case 0:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (_pixelArray[i] < _pixelArray[i+1]) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    case 1:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (_pixelArray[i] > _pixelArray[i+1]) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 2:
      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (_pixelArray[i] < _pixelArray[i+1]) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 3:
      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (_pixelArray[i] > _pixelArray[i+1]) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    }
  } else if (sort_by == 1) {

    switch(_sort_mode) { 
    case 0:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (hue(_pixelArray[i]) < hue(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    case 1:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (hue(_pixelArray[i]) > hue(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 2:
      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (hue(_pixelArray[i]) < hue(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 3:

      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (hue(_pixelArray[i]) > hue(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    }
  } else if (sort_by == 2) {

    switch(_sort_mode) { 
    case 0:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (brightness(_pixelArray[i]) < brightness(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    case 1:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (brightness(_pixelArray[i]) > brightness(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 2:
      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (brightness(_pixelArray[i]) < brightness(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 3:

      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (brightness(_pixelArray[i]) > brightness(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    }
  } else if (sort_by == 3) {

    switch(_sort_mode) { 
    case 0:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (saturation(_pixelArray[i]) < saturation(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    case 1:
      for (int i = 0; i < _pixelArray.length-1; i++) {
        if (saturation(_pixelArray[i]) > saturation(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 2:
      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (saturation(_pixelArray[i]) < saturation(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }

      break;
    case 3:

      for (int i = _pixelArray.length-2; i >= 0; i--) {
        if (saturation(_pixelArray[i]) > saturation(_pixelArray[i+1])) {
          _pixelArray = swapPixels(_pixelArray, i+1, i);
        }
      }
      break;
    }
  }

  return _pixelArray;
}


//end pixel sorting

int[] movePixel(int[] _pixelArray, int _index, int _spaces, int _direction) {
  int index1;
  int index2;

  switch(_direction) {
  case 0:
    for (int i = 0; i < _spaces; i++) {
      index1 = (_index+i) % (_pixelArray.length);
      if (index1 < 0) index1 +=  _pixelArray.length;
      index2 =(_index+i+1) % (_pixelArray.length);
      if (index2 < 0) index2 +=  _pixelArray.length;
      _pixelArray = swapPixels(_pixelArray, index1, index2);
    }
    break;
  case 1:
    for (int i = _spaces+_index; i > _index; i--) {
      index1 = (_index+i) % _pixelArray.length;
      if (index1 < 0) index1 +=  _pixelArray.length;
      index2 =(_index+i+1) % _pixelArray.length;
      if (index2 < 0) index2 +=  _pixelArray.length;
      _pixelArray = swapPixels(_pixelArray, index1, index2);
    }
    break;
  }

  return _pixelArray;
}

int[] swapPixels(int[] _pixelArray, int _index1, int _index2) {
  int buffer = _pixelArray[_index1];
  _pixelArray[_index1] = _pixelArray[_index2];
  _pixelArray[_index2] = buffer;
  return _pixelArray;
}

void makeParameters() {
  sort_mode = direction_x_r << 11 | order_x_r << 10 | direction_x_g << 9 | order_x_g << 8 | direction_x_b <<7 | order_x_b << 6 | direction_y_r << 5 | order_y_r << 4 | direction_y_g << 3 | order_y_g << 2 | direction_y_b << 1 | order_y_b;
  threshold_mode = thresh_1 << 2 | thresh_2 << 1| thresh_3 ;
  positive_threshold = 255 << 24 | r_pos << 16 | g_pos << 8 | b_pos;
  negative_threshold = 255 << 24 | r_neg << 16 | g_neg << 8 | b_neg;
}


void loadBuffer(PImage _image) {
  for (int i = 0; i < buffer.pixels.length; i++) {
    buffer.pixels[i]=_image.pixels[i];
  }
}

void loadPreview(PImage _image) {
  for (int i = 0; i < preview.pixels.length; i++) {
    preview.pixels[i]=_image.pixels[i];
  }
}

void loadOutput(PImage _image) {
  for (int i = 0; i < output.pixels.length; i++) {
    output.pixels[i]=_image.pixels[i];
  }
}

void displayPreview() {
  preview.updatePixels();
  image(preview, 0, 0);
}

void displayOutput() {  
  output.updatePixels();
  image(output, 0, 0);
}

void displayBuffer() {  
  buffer.updatePixels();
  image(buffer, 0, 0);
}

void displaySource() {
  src.updatePixels();
  image(src, 0, 0);
}


void loadData(String thePath) {
  src = loadImage(thePath);
  buffer = new PImage(src.width, src.height);
  output = new PImage(src.width, src.height);
  preview = new PImage(src.width, src.height);
  loadBuffer(src);
  loadPreview(buffer);
  loadOutput(buffer);
  setScreenSize(src.width, src.height);
}

void saveData(String thePath) {
  buffer.save(thePath+".TIF");
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

