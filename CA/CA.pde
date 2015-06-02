boolean[] row;
boolean[][] rules;
int set;
int page;
boolean changeRule = false;

void setup(){
  size(500, 500);
  
  rules = new boolean[256][8];
  
  //generates rules for CA
  for(int i = 0 ; i < 256 ; i++){ 
    for(int j = 0 ; j < 8 ; j++){    
    rules[i][j] = boolean(i >> j & 1);
    }
  }  
 
  row = new boolean[width];
  row[width/2] = true;
  
  //index for choosing a rule set
  set = 0;
  
  for(int i = 0 ; i < width ; i++){
      if(random(1) < random(1)){
        row[i]=true;
      } else {
        row[i]=false;
      }
    }
}

void draw(){
  loadPixels();
  if(changeRule){
    randomizeLine();  
    for(int i = 0 ; i < height; i++){
      
      shiftUp();
      drawRow();
      applyRules(countNeighbors());
      changeRule = false;
    }
  }
  updatePixels();
 
  // randomizer  
    
  
}

void keyPressed(){
  switch(key){
    case 'r':
      randomizeLine();
      break;
      case 's':
      set++;
      changeRule = true;
      println(set);
      break;
      case 'a':
      set--;
      changeRule = true;
      println(set);
      break;
  }
}


void randomizeLine(){
  for(int i = 0 ; i < width ; i++){
      if(random(1) < random(1)){
        row[i]=true;
      } else {
        row[i]=false;
      }
    }
}


void drawRow(){
  for(int i = 0 ; i < width ; i++){
    pixels[i+((height-1) * width)] = color(255*int(row[i]));
  }
}

void shiftUp(){
  for(int i = 0 ; i < pixels.length-width ; i++){
    pixels[i] = pixels[i+width];
  }
}

int[] countNeighbors(){ 
  int[] state = new int[width];
  for(int n = 0 ; n < width ; n++){
    
    int nL; // left neighbor
    int nR; // right neighbor
    int origin; // original cell
    
    if(n - 1 < 0){
      nL = width - 1; // wrap around
    } else {
      nL = n - 1;
    }
    
    origin = n;
    
    if(n + 1 >= width){
      nR = 0; // wrap around
    } else {
      nR = n + 1;
    }
   
    //bit shifting to convert the three states into an integer unique to that state
    state[n] = int(row[nL]) << 2 | int(row[origin]) << 1 | int(row[nR]);
  }
  return state;
}

void applyRules(int[] _states){
  for(int i = 0 ; i < width ; i++){
    switch(_states[i]){
      //0 0 0
      case 0:
        row[i] = rules[set][0];
      break;
      //0 0 1
      case 1:
        row[i] = rules[set][1];
      break;
      //0 1 0
      case 2:
        row[i] = rules[set][2];
      break;
      //0 1 1
      case 3:
        row[i] = rules[set][3];
      break;
      //1 0 0
      case 4:
        row[i] = rules[set][4];
      break;
      //1 0 1
      case 5:
        row[i] = rules[set][5];
      break;
      //1 1 0
      case 6:
        row[i] = rules[set][6];
      break;
      //1 1 1
      case 7:
        row[i] = rules[set][7];
      break;
    }  
  }
}
