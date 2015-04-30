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
  
  loadData("Gizmos.jpg");
  
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
    if(frameCount < 30){
      saveFrame("output/Gizmo-####.png");
    }
}

void loadBuffer(PImage _image){
  _image.loadPixels();
  buffer.loadPixels();
  for(int i = 0 ; i < _image.pixels.length ; i++){
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
  
  
  boolean reverse = true;
//  if(random(100) >= 0){
//    reverse = true;
//  } else {
//    reverse = false;
//  }
  
  int row_start = 0;
  int row_end = src.height;

  int col_start = 0;
  int col_end = src.width;

  int[] px_buffer;
  int[] r_buffer;
  int[] g_buffer;
  int[] b_buffer;
  
  int pos = frameCount%255;
  int neg = frameCount%255;
  
  int threshold_pos = color(pos,pos,pos);
  int threshold_neg = color(neg,neg,neg);
  
  int ib = 0;
  int buffer_length = 0;
  boolean section= false;
     
  switch(0) {
    
    
   
    case 0: //pixel_sort pixel value row by row 
      px_buffer = new int[src.width];
      
      ib = 0;
      buffer_length = 0;
      section= false;
      
      
      for(int y = row_start; y < row_end; y++){
        if(random(100) >= 50){
          reverse = true;
        } else {
          reverse = false;
        }
        for (int x = 0; x < src.width; x++) {
          if(buffer.pixels[y*src.width+x] >= threshold_pos && !section){
            section = true;
            buffer_length=1;
            ib = x;
          } else if (buffer.pixels[y*buffer.width+x] >= threshold_pos && section){
            buffer_length++;
          }
          if (section && buffer.pixels[y*buffer.width+x] < threshold_neg || x >= src.width-1){
            px_buffer = new int[buffer_length];
            for(int i = 0 ; i < px_buffer.length ; i++){
              px_buffer[i] = buffer.pixels[(y*buffer.width)+(ib+i)];
            }
            px_buffer = sort(px_buffer);
            if(reverse){
              px_buffer = reverse(px_buffer);
            }
            section = false;
            for(int i = 0 ; i < px_buffer.length ; i++){
              buffer.pixels[(y*src.width)+(ib+i)] = px_buffer[i];
            }
          }
        }
      }
      break;
      
    case 1:
      
      px_buffer = new int[src.height];
      ib = 0;
      buffer_length = 0;
      section= false;
      
      
      for(int x = col_start; x < col_end; x++){
        for (int y = 0; y < src.height; y++) {
          if(buffer.pixels[y*src.width+x] >= threshold_pos && !section){
            section = true;
            buffer_length=1;
            ib = y;
          } else if (buffer.pixels[y*buffer.width+x] >= threshold_pos && section){
            buffer_length++;
          } else if (buffer.pixels[y*buffer.width+x] < threshold_neg && section){
            px_buffer = new int[buffer_length];
            for(int i = 0 ; i < px_buffer.length ; i++){
              px_buffer[i] = src.pixels[((ib+i)*buffer.width)+(x)];
            }
            px_buffer = sort(px_buffer);
            if(reverse){
              px_buffer = reverse(px_buffer);
            }
            section = false;
            for(int i = 0 ; i < px_buffer.length ; i++){
              buffer.pixels[((ib+i)*src.width)+(x)] = px_buffer[i];
            }
          }
        }
      }
      
//      px_buffer = new int[src.height];
//      for (int x = col_start; x < col_end; x++) {
//        for (int y = 0; y < src.height; y++) {
//          px_buffer[y] = src.pixels[y*src.width+x];
//        }
//        px_buffer = sort(px_buffer);
//        if(reverse){
//          px_buffer = reverse(px_buffer);
//        }
//        for (int y = 0; y < src.height; y++) {
//          buffer.pixels[y*src.width+x]=px_buffer[y];
//        }
//      }
      break;
      
    case 2:
      // RGB channel sort on rows
      r_buffer = new int[src.width];
      g_buffer = new int[src.width];
      b_buffer = new int[src.width];
      for (int y = row_start; y < row_end; y++) {
        for (int x = 0; x < src.width; x++) {
          r_buffer[x] = src.pixels[y*src.width+x] >> 16 & 0xFF;
          g_buffer[x] = src.pixels[y*src.width+x] >> 8 & 0xFF;
          b_buffer[x] = src.pixels[y*src.width+x] & 0xFF;
        }
        
        r_buffer = thresholdSort(r_buffer, pos, neg);
        g_buffer = thresholdSort(g_buffer, pos, neg);
        b_buffer = thresholdSort(b_buffer, pos, neg);
        
        if(reverse){
          r_buffer = reverse(r_buffer);
          g_buffer = reverse(g_buffer);
          b_buffer = reverse(b_buffer);
        }
        
        for (int x = 0; x < src.width; x++) {
          buffer.pixels[y*src.width+x]= 255 << 24 | r_buffer[x] << 16 | g_buffer[x] << 8 | b_buffer[x];
        }
        
      }

      break;
      
    case 3:
      // RGB channel sort on rows
      r_buffer = new int[src.height];
      g_buffer = new int[src.height];
      b_buffer = new int[src.height];
      for (int x = col_start; x < col_end; x++) {
        for (int y = 0; y < src.height; y++) {
          r_buffer[y] = src.pixels[y*src.width+x] >> 16 & 0xFF;
          g_buffer[y] = src.pixels[y*src.width+x] >> 8 & 0xFF;
          b_buffer[y] = src.pixels[y*src.width+x] & 0xFF;
        }
        
        r_buffer = thresholdSort(r_buffer, pos, neg);
        g_buffer = thresholdSort(g_buffer, pos, neg);
        b_buffer = thresholdSort(b_buffer, pos, neg);
        
        if(reverse){
          r_buffer = reverse(r_buffer);
          g_buffer = reverse(g_buffer);
          b_buffer = reverse(b_buffer);
        }
        
        for (int y = 0; y < src.height; y++) {
          buffer.pixels[y*src.width+x]= 255 << 24 | r_buffer[y] << 16 | g_buffer[y] << 8 | b_buffer[y];
        }
        
      }
      break;
  }
  buffer.updatePixels();  
  image(buffer, 0, 0);
}

int[] thresholdSort(int[] _array, int _threshold_pos, int _threshold_neg){
  int[] temp = _array;
  int[] _buffer;
  boolean section = false;
  int beginning = 0;
  int section_length=1;
  
//  for(int i = 0 ; i < _array.length ; i++){
//    println(_array[i]);
//  }
  
  for(int i = 0 ; i < temp.length ; i++){
    if(temp[i] >= _threshold_pos && !section){
      section = true;
      section_length=1;
      beginning = i;
    } else if (temp[i] >= _threshold_pos && section){
      section_length++;
    } else if (temp[i] < _threshold_neg && section){
      _buffer = new int[section_length];
      for(int j = 0 ; j < _buffer.length ; j++){
        _buffer[j] = temp[beginning+j];
      }
      _buffer = sort(_buffer);
//      if(reverse){
//        _buffer = reverse(_buffer);
//      }
      section = false;
      for(int j = 0 ; j < _buffer.length ; j++){
        temp[beginning+j] = _buffer[j];
      }
    }
  }
  return temp;
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

