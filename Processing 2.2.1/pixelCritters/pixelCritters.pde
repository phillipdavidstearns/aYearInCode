PImage srcImg;
PImage destImg;
String inputPath = "input/";
String outputPath = "output/test_eatup/";
String filename = "noise";
String inputExtension = ".jpg";
String outputExtension = ".png";

Critter[] critters1;
Critter[] critters2;
Critter[] critters3;
Critter[] critters4;
void setup() {
  //srcImg = loadImage(inputPath+filename+inputExtension);
  srcImg = createImage(50,50,RGB);
  for(int i = 0 ; i < srcImg.pixels.length ; i++){
    srcImg.pixels[i] = color(int(random(255)));
  }
  size(srcImg.width, srcImg.height);  
  destImg = srcImg;
  critters1 = new Critter[width];
  critters2 = new Critter[width];
  critters3 = new Critter[height];
  critters4 = new Critter[height];
  for (int i = 0; i < critters1.length; i++) {
    critters1[i] = new Critter(i,height-1,int(random(6)), 2);
    critters2[i] = new Critter(i,0,int(random(6)), 3);
  }
  for (int i = 0; i < critters3.length; i++) {
    critters3[i] = new Critter(width-1,i,int(random(6)), 0);
    critters4[i] = new Critter(0,i,int(random(6)), 1);
  }
  frameRate(60);
  
}

void draw() {
  image(destImg, 0, 0);
  for (int i = 0; i < critters1.length; i++) {
    //if (critters[i].isAlive()) {
      destImg.loadPixels();
      critters1[i].run(destImg.pixels);
      destImg.pixels[critters1[i].y*width + critters1[i].x]=critters1[i].pixel;
      destImg.updatePixels();
      critters1[i].display(1);
      
    //}
  }
  for (int i = 0; i < critters2.length; i++) {
    //if (critters[i].isAlive()) {
      destImg.loadPixels();
      critters2[i].run(destImg.pixels);
      destImg.pixels[critters2[i].y*width + critters2[i].x]=critters2[i].pixel;
      destImg.updatePixels();
      critters2[i].display(1);
      
    //}
  }
  for (int i = 0; i < critters3.length; i++) {
    //if (critters[i].isAlive()) {
      destImg.loadPixels();
      critters3[i].run(destImg.pixels);
      destImg.pixels[critters3[i].y*width + critters3[i].x]=critters3[i].pixel;
      destImg.updatePixels();
      critters3[i].display(1);
      
    //}
  }
  for (int i = 0; i < critters4.length; i++) {
    //if (critters[i].isAlive()) {
      destImg.loadPixels();
      critters4[i].run(destImg.pixels);
      destImg.pixels[critters4[i].y*width + critters4[i].x]=critters4[i].pixel;
      destImg.updatePixels();
      critters4[i].display(1);
      
    //}
  }
  
  destImg.save(outputPath+filename+"_"+nf(frameCount,6)+outputExtension);
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
  int direction;

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
  
  Critter(int _x, int _y, int _type, int _direction) {
    type = _type;
    x = _x;
    y = _y;
    nextX = x;
    nextY = y;
    //direction = directions[int(random(1))];
    age = 0;
    lifeSpan = 10000;
    direction = _direction;
    
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

    int i = direction;
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

  void display(int _mode) {
    switch(_mode){
      case 0:
        stroke(strokeColor);
        fill(pixel);
        ellipse(x, y, 10, 10);
        break;
      case 1:
        stroke(255);
        point(x,y);
        break;
    }
  }
}

