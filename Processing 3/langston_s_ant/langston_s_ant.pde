//Implementation of Langston's Ant
//http://mathworld.wolfram.com/LangtonsAnt.html

Ant ant;
boolean[] ground;

void setup(){
  size(100, 100);
  ant = new Ant(int(width/2),int(height/2));
  ground = new boolean[width*height];
  
  loadPixels();
  for(int i = 0; i < width*height ; i++){
    ground[i] = false; //initialize ground to all false
    pixels[i] = color(255); //initialize pixels to all white
  }
  updatePixels();
  
  
  
}

void draw(){
  ant.evaluate(ground);
}


class Ant { 
  int x;
  int y;
  int orientation; // 0 = UP, 1 = RIGHT, 2 = DOWN, 3 = LEFT
  
  Ant (int _x, int _y, int _orientation) {
    x = _x;
    y = _y;  
    orientation = _orientation;
  }
  
  
  boolean update(boolean[] input){
    boolean state = input[y*width+x];
    
    if(state){
      orientation++;
    } else {
      orientation--;
    }
    
    orientation = (orientation + 4) % 4;
    
    
    switch(orientation){
      case 0:
      y--;
      break;
      case 1:
      x++;
      break;
      case 2;
      y++;
      break;
      case 3:
      x--;
      break;
    }
    
    x = (x + width) % width;
    y = (y + width) % width;
    
    return !state;
  
} 