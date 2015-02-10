void setup(){
  size(500, 500);
}

void draw(){
  loadPixels();
  noiseGradient();
  updatePixels();
}

void noiseGradient(){
  for(int i = 0 ; i < pixels.length ; i++){
    if( random(1) < float(i)/pixels.length){
      pixels[i] = color(255);
    } else {
      pixels[i] = color(0);
    }
  }
}
