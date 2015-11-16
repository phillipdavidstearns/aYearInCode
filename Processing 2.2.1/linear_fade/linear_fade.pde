PImage output;
int lines;
int steps;

void setup(){
  lines = 22;
  steps = lines+1;
  output = createImage(506, lines*steps, RGB);
  size(output.width, output.height);
  noLoop();
}

void draw(){
  make();
  image(output, 0 ,0);
  println(height);
  output.save("output/linear_fade_reverse-"+lines+"_lines_" + output.width + "w_x_" + output.height + "h.PNG");
  
}

void make(){
  output.loadPixels();
  
  //set output to white
  for(int p = 0 ; p < output.pixels.length ; p++){
    output.pixels[p] = color(255);
  }
  
  
  for(int i = 0 ; i < steps ; i++){
    int start = lines * i;
    for(int j = 0 ; j < lines ; j++){
      int y = j + start;
      for(int x = 0 ; x < output.width ; x++){
        if(j >= i){
          output.pixels[y*output.width+x] = color(0);
        } else {
          output.pixels[y*output.width+x] = color(255);
        }
      }
    }
  }
  output.updatePixels();
}
