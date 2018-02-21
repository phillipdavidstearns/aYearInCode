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
    
    if (orientations == 8) {
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
    } else if (orientations == 4) {
      switch(orientation) {
      case 0:
        nextY--;
        break;
      case 1:
        nextX++;
        break;
      case 2:
        nextY++;
        break;
      case 3:
        nextX--;
        break;
      }
    }

    //wrap the location to stay within the image bounds
    nextX = (nextX + width) % width;
    nextY = (nextY + height) % height;


    // retrieve the pixels associated with our current and next location
    int eval = evaluate(evalMode, getPixel(_img, x, y), getPixel(_img, nextX, nextY) );

if (eval > -1 && eval < 2){
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

  //boolean isGreater(color _c1, color _c2) {
  //  return _c1 > _c2;
  //}

  //boolean hIsGreater(color _c1, color _c2) {
  //  return hue(_c1) > hue(_c2);
  //}

  //boolean sIsGreater(color _c1, color _c2) {
  //  return saturation(_c1) > saturation(_c2);
  //}

  //boolean vIsGreater(color _c1, color _c2) {
  //  return brightness(_c1) > brightness(_c2);
  //}

  //boolean rIsGreater(color _c1, color _c2) {
  //  return red(_c1) > red(_c2);
  //}

  //boolean gIsGreater(color _c1, color _c2) {
  //  return green(_c1) > green(_c2);
  //}

  //boolean bIsGreater(color _c1, color _c2) {
  //  return blue(_c1) > blue(_c2);
  //}
}