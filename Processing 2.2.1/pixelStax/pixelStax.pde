int p;

void setup(){
  frameRate(120);
  size(192,256);
  colorMode(RGB, 255);
  p=0;
  // prevents looping
  //noLoop();
}

void draw(){
  loadPixels();
  for(int i = 0 ; i < pixels.length ; i++){ 
    pixels[i] = color(processPixel(i, pixels[i]));
  }
  updatePixels();
//  saveFrame("output/pixelStax_dynamic_02/2015_02_12_pixelStax_dynamic_02-####.PNG");
 
}

int processPixel(int i, int px){
  p=px;
  p+=i;
  if(p==0) p = int(random(pow(2,24)));
  if(i > width * 80 & i < width * 200 ){
    p = p << 1 | ((p >> i % 2 ^ px >> i % 3) & 1);
  } else {
    p = p << 1 | ((p >> i % 5 ^ px >> i % 12) & 1);
  }
  return p;
}





