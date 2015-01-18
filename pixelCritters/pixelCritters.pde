PImage srcImg;
PImage destImg;
String inputPath = "input/";
String outputPath = "output/test/";
String filename = "cheeseburgerpizza";
String inputExtension = ".jpg";
String outputExtension = ".png";

Critter[] critters;

void setup() {
  //srcImg = loadImage(inputPath+filename+inputExtension);
  srcImg = createImage(10,10 ,RGB);
  for(int i = 0 ; i < srcImg.pixels.length ; i++){
    srcImg.pixels[i]=color(random(255));
  }
  size(srcImg.width, srcImg.height);  
  destImg = srcImg;
  critters = new Critter[6];
  for (int i = 0; i < critters.length; i++) {
    critters[i] = new Critter(i,0,i);
  }
  frameRate(60);
  
}

void draw() {
  image(destImg, 0, 0);
  for (int i = 0; i < critters.length; i++) {
    //if (critters[i].isAlive()) {
      destImg.loadPixels();
      critters[i].run(destImg.pixels);
      destImg.pixels[critters[i].y*width + critters[i].x]=critters[i].pixel;
      destImg.updatePixels();
      critters[i].display();
      
    //}
  }
  saveFrame(outputPath+filename+"_####"+outputExtension);
  if(frameCount >= 10000){
    exit();
  }
}

class Critter {
  int x;
  int y;
  int age;
  int lifeSpan;
  boolean alive;
  color pixel;
  int type;
  color strokeColor;
  color nextPixel;
  int nextX;
  int nextY;
  int hunger=25;

  Critter() {
    type = int(random(6));
    x = int(random(width));
    y = int(random(height));
    nextX = x;
    nextY = y;
    //direction = directions[int(random(1))];
    age = 0;
    lifeSpan = 10000;
    
    switch(type) {
    case 0:
      strokeColor=#FF0000;
      break;
    case 1:
      strokeColor=#00FF00;
      break;
    case 2:
      strokeColor=#0000FF;
      break;
    case 3:
      strokeColor=#FFFF00;
      break;
    case 4:
      strokeColor=#FF00FF;
      break; 
    case 5:
      strokeColor=#00FFFF;
      break;
    }
  }
  
  Critter(int _x, int _y, int _type) {
    type = _type;
    x = _x;
    y = _y;
    nextX = x;
    nextY = y;
    //direction = directions[int(random(1))];
    age = 0;
    lifeSpan = 10000;
    
    switch(type) {
    case 0:
      strokeColor=#FF0000;
      break;
    case 1:
      strokeColor=#00FF00;
      break;
    case 2:
      strokeColor=#0000FF;
      break;
    case 3:
      strokeColor=#FFFF00;
      break;
    case 4:
      strokeColor=#FF00FF;
      break; 
    case 5:
      strokeColor=#00FFFF;
      break;
    }
  }

  boolean isAlive() {
    return age < lifeSpan;
  }

  void run(color[] _pixels) {
    int food = 0;
    int foodfood = 0;
    
    x=nextX;
    y=nextY;
    pixel = _pixels[y*width + x];

    int r = (pixel >> 16) & 0xFF;
    int g = (pixel >> 8) & 0xFF;    
    int b = pixel & 0xFF;

    switch(type) {
    case 0:
      if(r<hunger*2){
        food = 0;
      } else{
        r-=hunger*2;
        g+=hunger;
        b+=hunger;
        food = r;
      }
      break;
    case 1:
      if(g<hunger*2){
        food = 0;
      } else{
        r+=hunger;
        g-=hunger*2;
        b+=hunger;
        food = g;
      }
    case 2:
      if(b<hunger*2){
        food = 0;
      } else{
        r+=hunger;
        g+=hunger;
        b-=hunger*2;
        food = b;
      }
      break;
    case 3:
      if(r+g<hunger*2){
        food = 0;
      } else{
        r-=hunger;
        g-=hunger;
        b+=hunger*2;
        food = r+g;
      }
      break;
    case 4:
      if(r+b<hunger*2){
        food = 0;
      } else{
        r-=hunger;
        g+=hunger*2;
        b-=hunger;
        food = r+b;
      }
      break; 
    case 5:
      if(g+b<hunger*2){
        food = 0;
      } else{
        r+=hunger*2;
        g-=hunger;
        b-=hunger;
        food = g+b;
      }
      break;
    }
    
    if (food <= 0){
      lifeSpan = 0;
    }

    pixel = color(r, g, b);

    int xx=x;
    int yy=y;

    int i = int(random(6));
    switch(i) {
    case 0: //left neighbor
      if ( x - 1 < 0) {
        xx = width-1;
      } else {
        xx = x - 1;
      }
      yy = y;
      break;
    case 1: //right neighbor
      if ( x + 1 >= width) {
        xx = 0;
      } else {
        xx = x + 1;
      }
      yy = y;
      break;
    case 2: //top neighbor
      if ( y - 1 < 0) {
        yy = height-1;
      } else {
        yy = y - 1;
      }
      xx = x;
      break;
    case 3: //bottom neighbor
      if ( y + 1 >= height) {
        yy = 0;
      } else {
        yy = y + 1;
      }
      xx = x;
      break;
    }

    color neighborPixel = _pixels[yy*width + xx];
    int rr =  (neighborPixel >> 16) & 0xFF;
    int gg = (neighborPixel >> 8) & 0xFF;
    int bb = neighborPixel & 0xFF;
    
    switch(type) {
      
    case 0:
      foodfood = rr;
      break;
    case 1:
      foodfood = gg;
      break;
    case 2:
      foodfood = bb;
      break;
    case 3:
      foodfood = rr+gg;
      break;
    case 4:
      foodfood = rr+bb;
      break;
    case 5:
      foodfood = bb+gg;
      break;
    }

    if (foodfood > food) {
      nextX = xx;
      nextY = yy;
    }else{
      nextX = x;
      nextY = y;
    }



    age++;
  }

  void display() {
    /*
    stroke(strokeColor);
    fill(pixel);
    ellipse(x, y, 10, 10);
    */
    stroke(255);
    point(x,y);
  }
}

