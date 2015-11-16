PImage image;
void setup() {
  size(500, 500);
  image = createImage(500, 500, RGB);
}

void draw() {
  loadPixels();
  
  int x = 0;
  int y = 0;
  int index=0;
  
//  starting from 0, height-1 to width-1, 0 ; picks diagonal pixels from bottom right to upper left  
  
  for(int i = 0 ; i < width ; i++){
    index = 0;
    x = i;
    y = height-1;
    while( x >= 0 && y < height){
      pixels[y*width+x]+=i;
      x--;
      y--;
    }
  }
    
  for(int i = 0 ; i < height - 2 ; i++){
    index = 0;
    x = width - 1;
    y = height - 2 - i;
    while(x >= 0 && y >= 0){
      pixels[y*width+x]+=i;
      x--;
      y--;
    }
  }
   
  
//  starting from 0,0 to width,height ; picks diagonal pixels from bottom left to upper right  
//  for(int i = 0 ; i < height ; i++){
//    index=0;
//    x=0;
//    y=i;
//    while(x < width && x <= i && y >= 0 ){
//      pixels[y*width+x]+=i;
//      index++;
//      x++;
//      y--;
//    }
//  }
//  
//  for(int i = 0 ; i < width-1 ; i++){
//    index=0;
//    x=i;
//    y=height-1;
//    while(x < width && y >= 0 ){
//      pixels[y*width+x]+=i;
//      index++;
//      x++;
//      y--;
//    }
//  }
  
  updatePixels();
}

