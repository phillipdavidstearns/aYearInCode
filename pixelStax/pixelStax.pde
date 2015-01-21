color pixel;
int cycle;

void setup(){
  frameRate(120);
  size(125, 125);
  colorMode(RGB, 255);
  pixel = 0;
  cycle = width*height;
}

void draw(){
  loadPixels();
  for(int i = 0 ; i < pixels.length ; i++){
    processPixel(i);
    pixels[i] = color(pixel);
  }
  updatePixels();
  saveFrame("output/pixelStax_test/pixelStax_test_####.PNG");
  if(frameCount > 1000){
    exit();
  }
}

void processPixel(int pixel_count){
  
  //this bit actas like a linear feedback shift register
  int pixel_bit_1 = pixel >> frameCount % 15;
  int pixel_bit_2 = pixel >> frameCount % 13;
  int pixel_bit_3 = pixel >> frameCount % 14;
  int pixel_reg_input = (pixel_bit_1 ^ pixel_bit_2 ^ pixel_bit_3) & 1;

  pixel = ((pixel << 1) | pixel_reg_input);
  
  //conditional processing creates breaks in different sections of the image
  //basically am inserting arbitrary conditions and operations
  //the output is completely "rational" but beyond my ability to predict what it will look like
  
  if(pixel_count % int(width*height) > 100*width){
    pixel=pixel<<7;
    pixel-=25;
    pixel*=3;
    pixel=pixel>>6;
  }
  
  if(pixel_count % width > 25){
    pixel= pixel<<7;
    pixel-=5;
    pixel*=3;
    pixel=pixel>>6;
  }
  
  if(pixel_count % ((frameCount%width)+1) > 25){
    pixel+=9;
    pixel/=2;
    pixel|=pixel>>3;
  }
  
  if(pixel_count % ((frameCount%width)+1) < 35){
    pixel= pixel<<5;
    pixel-=5;
    pixel/=2;
    pixel|=pixel<<3;
    pixel=pixel>>4;
  }

  pixel = pixel << frameCount % 15;
  pixel/= frameCount % 13 + 1;
  pixel*= frameCount % 25 + 1;
  pixel = pixel >>(frameCount % 3);
  
  pixel = pixel % 0xFFFFFF;
  pixel &= 0xFFFFFF;
  pixel ^= 0xFFFFFF;
}




