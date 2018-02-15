class Ant {

  int x;
  int y;
  int orientation; // 0 = UP, 1 = RIGHT, 2 = DOWN, 3 = LEFT

  Ant (int _x, int _y, int _orientation) {
    x = _x;
    y = _y;  
    orientation = _orientation;
  }

  Ant () {
    randomize();
  }

  void randomize() {
    x = int(random(width));
    y = int(random(height));  
    orientation = int(random(4));
  }

  void update(PImage _img) {
    _img.loadPixels();
    //store the coordinates of our next location
    int nextX = x; 
    int nextY = y;

    //get the coordinates of our next location
    switch(orientation) {
    case 0:
      nextY--;
      break;
    case 1:
      nextX++;
      nextY--;
      break;
    case 2:
      nextX++;
      break;
    case 3:
      nextX++;
      nextY++;
      break;
    case 4:
      nextY++;
      break;
    case 5:
      nextX--;
      nextY++;
      break;
    case 6:
      nextX--;
      break;
    case 7:
      nextX--;
      nextY--;
      break;
    }

    //wrap the location to stay within the image bounds
    nextX = (nextX + width) % width;
    nextY = (nextY + height) % height;

    // retrieve the pixels associated with our current and next location
    color current = getPixel(_img, x, y); 
    color next = getPixel(_img, nextX, nextY);
   
    int eval;

    if (current == next) {
      eval = 0;
    } else if (current < next) {
      eval = 1;
    } else {
      eval = 2;
    }
    
    if (swap[orientation][eval]) {
      swapPixel(_img, x, y, nextX, nextY);
    }

    // apply the turn direction to our orientation
    switch(turn[orientation][eval]) {
    case 0:
      break;
    case 1:
      orientation--;
      break;
    case 2:
      orientation++;
      break;
    }

    //wrap the orientation
    orientation = (orientation + 8) % 8;

    //apply the new location
    x = nextX;
    y = nextY;

    _img.updatePixels();
  }
}