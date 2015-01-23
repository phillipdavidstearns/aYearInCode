color pixel;
int cycle;

void setup(){
  frameRate(120);
  size(384, 512);
  colorMode(RGB, 255);
  pixel = 0;
  cycle = width*height;
}

void draw(){
  //pixel = 0;
  loadPixels();
  for(int i = 0 ; i < pixels.length ; i++){ 
    pixels[i] = color(processPixel(i));
  }
  updatePixels();
  //saveFrame("output/pixelStax_test/pixelStax_test_####.PNG");
  if(frameCount == 10){
     saveFrame("output/pixelStax_static/pixelStax_static_33.PNG");
  }
}

int processPixel(int pixel_count){
  
   
  pixel = (pixel << 3) % 0xFFFFFF;
  //pixel &= pixel_count % 0xFFFFFF;
  pixel *= pixel_count % 9;
  pixel |= ((pixel << 1) | (((pixel >> (pixel_count % 6)) & 1) ^ ((pixel >> (pixel_count % 4)) & 1) ^ ((pixel >> (pixel_count % 2)) & 1)));
  pixel -= pixel_count % 0xFFFFFF;
  pixel += (pixel >> 2) % 0xFFFFFF;
  pixel += (pixel_count % (width)) % 0xFFFFFF;
  pixel = pixel >> (pixel_count % 7) % 0xFFFFFF;
  //pixel*=(frameCount+pixel_count) % 15;
  
  pixel++;
  //pixel+=pixel_count/(frameCount+1) % 0xFFFFFF;
  //pixel/=2;
  
  
  pixel = pixel % 0xFFFFFF;
  pixel ^= 0xFFFFFF;
  pixel &= 0xFFFFFF;
  
  return pixel;
}





