/* dataViz by Phillip Stearns 2015 for aYearInCode();
 * http://ayearincode.tumblr.com
 *
 * USES code from the ControlP5 Controlframe Example by Andreas Schlegel, 2012
 *
 * Requires controlP5 library available at www.sojamo.de/libraries/controlp5
 *
 */

import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;

private ControlP5 cp5;

//for the GUI window
ControlFrame cf;

byte[] raw_bytes, raw_bits;

int mode=0;

//you will have to specify your own path for files you want to render
String input_path = "";
String input_filename = "dataViz";
String input_ext = ".pde";

String output_path = "output/test/";
String output_filename = "test";
String output_ext = ".PNG";

int bit_offset=0; // skips bits 
int pixel_offset=0; // skips pixels

// sets number of bits to be packed into color channel values
int depth, chan1_depth, chan2_depth, chan3_depth, pixel_depth, swap_mode;
int line_multiplier = 1;

boolean red_invert=false;
boolean green_invert=false;
boolean blue_invert=false;
boolean invert=false;

boolean red_invert_pre=false;
boolean green_invert_pre=false;
boolean blue_invert_pre=false;

int screen_width = 384;
int screen_height = 512;

void setup(){
  setScreenSize(screen_width, screen_height);
  if (frame != null) {
    frame.setResizable(true);
  }
  
  loadData(input_path + input_filename + input_ext);
  
  cp5 = new ControlP5(this); 
  
  // by calling function addControlFrame() a
  // new frame is created and an instance of class
  // ControlFrame is instanziated.
  cf = addControlFrame("GUI", 500 ,300);
  
  // add Controllers to the 'extra' Frame inside 
  // the ControlFrame class setup() method below.
}

void initializeDepth(int depth1, int depth2, int depth3){
    chan1_depth=depth1;
    chan2_depth=depth2;
    chan3_depth=depth3;
    pixel_depth = chan1_depth + chan2_depth + chan3_depth;
}

void draw(){
  bits_to_pixels();
}

void loadData(String thePath){
  raw_bytes = loadBytes(thePath);
  raw_bits = new byte[raw_bytes.length*8];
  bytes_to_bits();
}

void saveData(String thePath){
  saveFrame(thePath+".TIF");
//  PImage output = createImage(width, height, RGB);
//  for(int i = 0 ; i < output.pixels.length ; i++){
//    output.pixels[i] = pixels[i];
//  }
//  output.save(thePath+".TIF");
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

void setScreenSize(int _width, int _height){
  frame.setSize(_width, _height+22);
}

void bytes_to_bits(){ 
  for(int i = 0 ; i < raw_bytes.length ; i++){    
    for(int j = 0 ; j < 8 ; j++){    
      raw_bits[(i*8)+j] = byte((raw_bytes[i] >> j) & 1); 
    }  
  }
}

void bits_to_pixels(){
  loadPixels();

  for(int i = 0 ; i < pixels.length ; i++){
    switch(mode){
      case 0:
        int chan1 = 0;
        int chan2 = 0; 
        int chan3 = 0; 
        
        int red = 0;
        int green = 0; 
        int blue = 0; 
        
        //using some bit shifting voodoo to pack bits into channel values  
        
        if((i+pixel_offset)*pixel_depth+pixel_depth+bit_offset < raw_bits.length){
        
          for(int x = 0 ; x < chan1_depth ; x++){
            chan1 |=  (raw_bits[((i+pixel_offset)*pixel_depth)+x+bit_offset] << x);
          }
          chan1*=(255/(pow(2,(chan1_depth))-1)); //scale to 0-255
        
          for(int y = 0 ; y < chan2_depth ; y++){
            chan2 |=  (raw_bits[((i+pixel_offset)*pixel_depth)+chan1_depth+y+bit_offset] << y);
          }
          chan2*=(255/(pow(2,(chan2_depth))-1)); //scale to 0-255
        
          for(int z = 0 ; z < chan3_depth ; z++){
            chan3 |=  (raw_bits[((i+pixel_offset)*pixel_depth)+chan1_depth+chan2_depth+z+bit_offset] << z);       
          }
          chan3*=(255/(pow(2,(chan3_depth))-1)); //scale to 0-255
          
          if(red_invert_pre == true){
            chan1^=0xFF;
          }
          if(green_invert_pre == true){
            chan2^=0xFF;
          }
          if(blue_invert_pre == true){
            chan3^=0xFF;
          }
          
          
          //channel swap
          switch(swap_mode){
            case 0:
              red = chan1;
              green = chan2 ;
              blue = chan3;
              break;
            case 1:
              red = chan3;
              green = chan1;
              blue = chan2;
              break;
            case 2:
              red = chan2;
              green = chan3;
              blue = chan1;
              break;
            case 3:
              red = chan3;
              green = chan2;
              blue = chan1;
              break;
            case 4:
              red = chan1;
              green = chan3;
              blue = chan2;
              break;
            case 5:
              red = chan2;
              green = chan1;
              blue = chan3;
              break;
          }
      
          //channel invert
          if(red_invert == true && red_invert_pre == false){
            red^=0xFF;
          }
          if(green_invert == true && green_invert_pre == false){
            green^=0xFF;
          }
          if(blue_invert == true && blue_invert_pre == false){
            blue^=0xFF;
          }
          
          pixels[i] = 255 <<24 |red << 16 | green << 8 | blue;
          
        } else {
          pixels[i] = 0x00000000;
        }
        break;
      
      case 1:
        int pixel = 0;
        if((i+pixel_offset)*depth+depth+bit_offset < raw_bits.length){
        
          for(int x = 0 ; x < depth ; x++){
            pixel |=  (raw_bits[((i+pixel_offset)*depth)+x+bit_offset] << x);
          }
          pixel*=(255/(pow(2,(depth))-1)); //scale to 0-255
          
          if(invert == true){
            pixel^=0xFF;
          }
          
          pixels[i] = color(pixel);
        } else {
          pixels[i] = 0x00000000;
        }
      break;
    }
      
    
  }
  updatePixels();
}
 





  
