//Implementation of Langston's Ant
//http://mathworld.wolfram.com/LangtonsAnt.html

Ant ant;
Ant[] ants;
boolean[] ground;

void setup() {
  size(400, 400);
  ant = new Ant(int(width/2), int(height/2), 0);
  ants = new Ant[2];

  for (int i = 0; i < ants.length; i++) {
    ants[i] = new Ant();
  }

  ground = new boolean[width*height];

  loadPixels();
  for (int i = 0; i < width*height; i++) {
    ground[i] = false; //initialize ground to all false
    pixels[i] = color(255); //initialize pixels to all white
  }
  updatePixels();
}

void draw() {
  loadPixels();
  for (int i = 0; i < 100; i++) {
    for (int j = 0; j < ants.length; j++) { 

      int[] positions = new int[ants.length];
      int position = width*ants[j].y + ants[j].x;
      boolean overlap = false;

      positions[j] = position;

      pixels[position] = color(0xFF - 255*int(ants[j].update(ground)));

      for (int k = 0; k < j; k++) {
        if (position == positions[k]) {
          overlap = true;
        }
      }

      if (!overlap) ground[position] = !ground[width*ants[j].y + ants[j].x];
    }
  }
  updatePixels();
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

  Ant () {
    x = int(random(width));
    y = int(random(height));  
    orientation = int(random(4));
  }


  boolean update(boolean[] input) {
    boolean state = input[y*width+x];

    if (!state) {
      orientation++;
    } else {
      orientation--;
    }

    orientation = (orientation + 4) % 4;

    String dir = new String();

    switch(orientation) {
    case 0:
      y--;
      break;
    case 1:
      x++;
      break;
    case 2:
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
} 