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

    //get and store and wrap the coordinates of our next location
    int nextX = (getNextX(x) + width) % width; 
    int nextY = (getNextY(y) + height) % height;

    // retrieve the pixels associated with our current and next location
    int eval = evaluate(evalMode, getPixel(_img, x, y), getPixel(_img, nextX, nextY) );

    if (eval > -1 && eval < 2) {
      if (swap[orientation][eval]) swapPixel(_img, x, y, nextX, nextY);
      // apply the turn direction to our orientation
      switch(turn[orientation][eval]) {
      case 0:
        orientation--;
        break;
      case 1:
        orientation++;
        break;
      default:
        break;
      }

      //wrap the orientation
      orientation = (orientation + orientations) % orientations;

      //apply the new location
      x = nextX;
      y = nextY;
    }

    _img.updatePixels();
  }

  int evaluate(String _mode, color _c1, color _c2) {
    switch(_mode) {
    case "RGB":
      return evaluate(_c1, _c2);
    case "HUE":
      return evaluate(hue(_c1), hue(_c2));
    case "SAT":
      return evaluate(saturation(_c1), saturation(_c2));
    case "RED":
      return evaluate(red(_c1), red(_c2));
    case "GREEN":
      return evaluate(green(_c1), green(_c2));
    case "BLUE":
      return evaluate(blue(_c1), blue(_c2));
    default:
      return -1;
    }
  }

  int evaluate(color _c1, color _c2) {
    if (_c1 < _c2) {
      return 0;
    } else if (_c1 > _c2) {
      return 1;
    } else if (_c1 == _c2) {
      return 2;
    } else {
      return -1;
    }
  }

  int evaluate(float _f1, float _f2) {
    if (_f1 < _f2) {
      return 0;
    } else if (_f1 > _f2) {
      return 1;
    } else if (_f1 == _f2) {
      return 2;
    } else {
      return -1;
    }
  }

  int getNextX(int _x) {
    if (orientations == 8) {
      switch(orientation) {
        //0 = UP  
      case 1: //1 = UP+RIGHT
        return _x+1;
      case 2: //2 = RIGHT
        return _x+1;
      case 3: //3 = RIGHT+DOWN
        return _x+1;
        //4= DOWN
      case 5: //5 = DOWN + LEFT
        return _x-1;
      case 6: //6 = LEFT
        return _x-1;
      case 7: //7 = LEFT + UP
        return _x-1;
      default:
        return _x;
      }
    } else if (orientations == 4) {
      switch(orientation) {
        //0 = UP
      case 1: //1 =  RIGHT
        return _x+1;
        //2 =  DOWN
      case 3: //3 =  LEFT
        return _x-1;
      default:
        return _x;
      }
    } else {
      return _x;
    }
  }


  int getNextY(int _y) {
    if (orientations == 8) {
      switch(orientation) {
      case 0: // UP
        return _y-1;
      case 1: // UP+RIGHT
        return _y-1;
        // 2 = // RIGHT
      case 3: // DOWN + RIGHT
        return _y+1;
      case 4: // DOWN
        return _y+1;
      case 5: // DOWN + LEFT
        return _y+1;
        // 6 = LEFT
      case 7: // UP + LEFT
        return _y-1;
      default:
        return _y;
      }
    } else if (orientations == 4) {
      switch(orientation) {
      case 0: // UP
        return _y-1;
        //1 = RIGHT
      case 2:// DOWN
        return _y+1;
        //3 = LEFT
      default:
        return _y;
      }
    } else {
      return _y;
    }
  }
}