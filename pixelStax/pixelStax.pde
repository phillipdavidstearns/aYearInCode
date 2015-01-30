color pixel;
int cycle;

void setup(){
  frameRate(120);
  size(1200,800);
  colorMode(RGB, 255);
  pixel = 0;
  cycle = width*height;
  noLoop();
}

void draw(){
  //pixel = 0;
  loadPixels();
  for(int i = 0 ; i < pixels.length ; i++){ 
    pixels[i] = color(processPixel(i));
  }
  updatePixels();
  //saveFrame("output/pixelStax_static/pixelStax_static_41.PNG");
 
}

int processPixel(int pixel_count){
  pixel+=1;
  pixel *= 1.000005;
  pixel %= 0xFFFFFF;
  return pixel;
}





