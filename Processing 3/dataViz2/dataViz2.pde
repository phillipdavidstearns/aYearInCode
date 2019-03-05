/* dataViz by Phillip Stearns 2015 for aYearInCode();
 * http://ayearincode.tumblr.com
 * revised 2019
 */

import controlP5.*;

// ControlFrame for GUI
ControlFrame gui;

int GUIWidth = 500;
int GUIHeight = 225;
int GUILocationX = 0;
int GUILocationY = 10;

int WindowLocationX = GUIWidth;
int WindowLocationY = 10;

// store bytes from selected file
byte[] raw_bytes;
boolean[] raw_bits;

// 
int mode=0; // 0 = RGB interleaved, 1 = Greyscale, 2 = RGB planar (TBD)  
int bit_offset = 0; // skips bits 
int pixel_offset = 0; // skips pixels

// sets number of bits to be packed into color channel values
int bw_depth, chan1_depth, chan2_depth, chan3_depth, pixel_depth, swap_mode;
int line_multiplier = 1;

boolean red_invert=false;
boolean green_invert=false;
boolean blue_invert=false;
boolean bw_invert=false;

boolean red_invert_pre=false;
boolean green_invert_pre=false;
boolean blue_invert_pre=false;

int screen_width = 768;
int screen_height = 1000;

void setup() {
  size(10, 10);

  surface.setLocation(WindowLocationX, WindowLocationY);
  surface.setResizable(true);
  setScreenSize(screen_width, screen_height);
  
  initVariables();
  setDepth(5, 6, 5);
  
  gui = new ControlFrame(this, GUILocationX, GUILocationY, GUIWidth, GUIHeight, "Controls");

  background(0);
  
  noLoop();
}

void draw() {
  background(0);
  if (raw_bytes != null && raw_bits != null) {
    bits_to_pixels();
  }
}

void setDepth(int depth1, int depth2, int depth3) {
  chan1_depth=depth1;
  chan2_depth=depth2;
  chan3_depth=depth3;
  pixel_depth = chan1_depth + chan2_depth + chan3_depth;
}

void initVariables() {

  raw_bytes = new byte[0];
  raw_bits = new boolean[0];

  mode=0; // 0 = RGB , 1 = Greyscale
  bit_offset = 0; // skips bits 
  pixel_offset = 0; // skips pixels

  line_multiplier = 1;

  red_invert=false;
  green_invert=false;
  blue_invert=false;
  bw_invert=false;

  bw_depth=1;
  swap_mode=0;

  red_invert_pre=false;
  green_invert_pre=false;
  blue_invert_pre=false;
}

void loadData(String thePath) {

  raw_bytes = loadBytes(thePath);
  raw_bits = bytes_to_bits(raw_bytes);

  bit_offset = 0; // skips bits 
  pixel_offset = 0; // skips pixels

  redraw();
}

void saveData(String thePath) {
  saveFrame(thePath+".PNG");
}

void setScreenSize(int _width, int _height) {
  surface.setSize(_width, _height);
  println("Screen size = "+width+" x "+height);
}

boolean[] bytes_to_bits(byte[] _bytes) {
  boolean[] bits = new boolean[raw_bytes.length*8];
  for (int i = 0; i < _bytes.length; i++) {    
    for (int j = 0; j < 8; j++) {    
      bits[(i*8)+j] = boolean((_bytes[i] >> j) & 1);
    }
  }
  return bits;
}

void bits_to_pixels() {
  switch(mode) {
  case 0:
    renderRGB();
    break;
  case 1:
    renderGreyscale();
    break;
  }
}

void renderRGB() {
  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    int chan1 = 0;
    int chan2 = 0; 
    int chan3 = 0; 

    int red = 0;
    int green = 0; 
    int blue = 0; 

    //using some bit shifting voodoo to pack bits into channel values  

    if ((i+pixel_offset)*pixel_depth+pixel_depth+bit_offset < raw_bits.length) {

      for (int x = 0; x < chan1_depth; x++) {
        chan1 |=  int(raw_bits[((i+pixel_offset)*pixel_depth)+x+bit_offset]) << x;
      }
      chan1*=(255/(pow(2, (chan1_depth))-1)); //scale to 0-255

      for (int y = 0; y < chan2_depth; y++) {
        chan2 |=  int(raw_bits[((i+pixel_offset)*pixel_depth)+chan1_depth+y+bit_offset]) << y;
      }
      chan2*=(255/(pow(2, (chan2_depth))-1)); //scale to 0-255

      for (int z = 0; z < chan3_depth; z++) {
        chan3 |=  int(raw_bits[((i+pixel_offset)*pixel_depth)+chan1_depth+chan2_depth+z+bit_offset]) << z;
      }
      chan3*=(255/(pow(2, (chan3_depth))-1)); //scale to 0-255

      if (red_invert_pre)chan1^=0xFF;
      if (green_invert_pre)chan2^=0xFF;
      if (blue_invert_pre)chan3^=0xFF;

      //channel swap
      switch(swap_mode) {
      case 0:
        red = chan1;
        green = chan2;
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
      if (red_invert == true && red_invert_pre == false) red^=0xFF;
      if (green_invert == true && green_invert_pre == false) green^=0xFF;
      if (blue_invert == true && blue_invert_pre == false) blue^=0xFF;

      pixels[i] = 255 <<24 |red << 16 | green << 8 | blue;
    } else {
      pixels[i] = color(0);
    }
  }
  updatePixels();
}

void renderGreyscale() {
  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    int pixel = 0;
    if ((i+pixel_offset)*bw_depth+bw_depth+bit_offset < raw_bits.length) {

      for (int x = 0; x < bw_depth; x++) {
        pixel |=  int(raw_bits[((i+pixel_offset)*bw_depth)+x+bit_offset]) << x;
      }

      pixel*=(255/(pow(2, (bw_depth))-1)); //scale to 0-255

      if (bw_invert)pixel^=0xFF;

      pixels[i] = color(pixel);
    } else {
      pixels[i] = color(0);
    }
  }
  updatePixels();
}
