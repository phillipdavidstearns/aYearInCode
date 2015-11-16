PImage frame;
boolean[] cells;
//boolean[] rules;
int w = 250;
int h = 250;
int neighborhood_w = 3;
int neighborhood_h = 3;
int shift_x = 0;
int shift_y = 0;
int qty_neighborhood_states = int(pow(2, neighborhood_w*neighborhood_h));
color[] colors;
int scale = 4;

ShiftRegister register;
ShiftRegister rules;

void setup() {
  size(scale*w, scale*h);
  //init cells
  cells = new boolean[w*h];
  randomizeCells();
  frameRate(30);

  rules = new ShiftRegister(qty_neighborhood_states);
  rules.randomize();

  //init frame
  frame = createImage(w, h, RGB);
  generatePalette(0);
}

void draw() {
  drawCells();
  updateCells();
}

void generatePalette(int mode){
  switch(mode){
    case 0:
  colors = new color[qty_neighborhood_states];
  color colorA = color(random(256), random(256), random(256));
  color colorB = color(random(256), random(256), random(256));
  for(int i = 0 ; i < colors.length ; i++){
    colors[i] = lerpColor(colorA, colorB, float(i)/float(colors.length-1));
  }
  break;
  case 1:
  for(int i = 0 ; i < colors.length ; i++){
    colors[i] = color(random(256), random(256), random(256));
  }
  
  break;
  }
}

void randomizeCells() {
  for (int i = 0; i < cells.length; i++ ) {
    if (random(1) > .00015) {
      cells[i] = false;
    } else {
      cells[i] = true;
    }
  }
}


void incrementRule() {
  Counter rules_copy = new Counter(rules.data.length, rules.data);
  rules_copy.inc();
  for (int i = 0; i < rules.data.length; i++) {
    rules.data[i] = rules_copy.register[i].state;
  }
}

void decrementRule() {
  Counter rules_copy = new Counter(rules.data.length, rules.data);
  rules_copy.dec();
  for (int i = 0; i < rules.data.length; i++) {
    rules.data[i] = rules_copy.register[i].state;
  }
}

void invertRules() {
  for (int i = 0; i < rules.data.length; i++) {
    rules.data[i] = !rules.data[i];
  }
}

void reverseRules() {
  boolean[] buffer = new boolean[rules.data.length];
  for (int i = 0; i < rules.data.length; i++) {
    buffer[i] = rules.data[i];
  }
  for (int i = 0; i < rules.data.length; i++) {
    rules.data[i] = buffer[rules.data.length - 1 - i];
  }
}

String rule() {
  String _theRule = new String();
  for (int i = rules.data.length-1; i >= 0; i--) {
    _theRule += int(rules.data[i]);
  }
  return _theRule;
}

void keyPressed() {
  switch(key) {
  case 'v':
    generatePalette(0);
    break;
  case 'b':
    generatePalette(1);
    break;
  case 'r':
    rules.randomize();
    println(rule());
    break;
  case 't':
    rules.reset();
    println(rule());
    break;
  case 'c':
    randomizeCells();
    break;
  case 'q':
    noLoop();
    break;
  case 'w':
    loop();
    break;
  case 's':
    incrementRule();
    println(rule());
    break;
  case 'a':
    decrementRule();
    println(rule());
    break;
    case 'd':
    invertRules();
    println(rule());
    break;
    case 'f':
    reverseRules();
    println(rule());
    break;
    case',':
    rules.shiftLeft(rules.data[rules.data.length-1]);
    println(rule());
    break;
    case'.':
    rules.shiftRight(rules.data[0]);
    println(rule());
    break;
    case'[':
    rules.shiftLeft(rules.data[15]^rules.data[16]);
    println(rule());
    break;
    case']':
    rules.shiftRight(rules.data[1]^rules.data[0]);
    println(rule());
    break;
  }
  randomizeCells();
}


void updateCells() {
  applyRules(evaluateNeighbors());
}

int[] evaluateNeighbors() {
  int[] states = new int[cells.length];
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      for (int ny = 0; ny < neighborhood_h; ny++) {
        for (int nx = 0; nx < neighborhood_w; nx++) {
          int x_coord = (w + (x) + (nx - 1)) % w;
          int y_coord = (h + (y) + (ny - 1)) % h;
          states[y*w+x] |= int(cells[y_coord * w + x_coord]) << (ny*neighborhood_w+nx);
        }
      }
    }
  }
  return states;
}

void applyRules(int[] _states) {
  for (int i = 0; i < cells.length; i++) {
    cells[i] = rules.data[_states[i]];
  }
}

void drawCells() {
  int[] states = evaluateNeighbors();
  frame.loadPixels();
  for (int i = 0; i < frame.pixels.length; i++) {
//    frame.pixels[i] = color(255* int(cells[i]));
    frame.pixels[i] = colors[states[i]];
  }
  noSmooth();
  frame.updatePixels();
  image(frame, 0, 0,width,height);
}

class ShiftRegister {

  boolean[] data;

  ShiftRegister(int _length) {
    data = new boolean[_length];
    for (int i = 0; i < data.length; i++) {
      if (i == 0) { 
        data[0] = true ;
      } else {
        data[i] = false;
      }
    }
  }

  void load(boolean[] _input) {
    for (int i = 0; i < data.length; i++) {
      data[i] = _input[i];
    }
  }

  void shiftLeft(boolean _input) {
    for (int i = data.length-1; i > 0; i--) {
      data[i] = data[i-1];
    }
    data[0] = _input;
  }

  void shiftLeft() {
    for (int i = data.length-1; i > 0; i--) {
      data[i] = data[i-1];
    }
    data[0] = false;
  }

  void shiftRight(boolean _input) {
    for (int i = 0; i < data.length-1; i++) {
      data[i] = data[i+1];
    }
    data[data.length-1] = _input;
  }

  void shiftRight() {
    for (int i = 0; i < data.length-1; i++) {
      data[i] = data[i+1];
    }
    data[data.length-1] = false;
  }

  void reset() {
    for (int i = 0; i < data.length; i++) {
      data[i] = false;
    }
  }

  void randomize() {
    for (int i = 0; i < data.length; i++) {
      if (random(1) < random(1)) {
        data[i]=true;
      } else {
        data[i]=false;
      }
    }
  }
}


class Counter {
  FlipFlop[] register;
  int length;

  Counter(int size) {
    length = size;
    register = new FlipFlop[size];
    for (int i = 0; i < register.length; i++) {
      register[i] = new FlipFlop();
    }
  }

  Counter(int size, boolean[] _input) {
    length = size;
    register = new FlipFlop[size];
    for (int i = 0; i < register.length; i++) {
      register[i] = new FlipFlop(_input[i]);
      if ( i != 0 ) register[i].previousClock = _input[i-1];
    }
  }

  void load(boolean[] _input) {
    for (int i = 0; i < _input.length; i++) {
      register[i].state = _input[i];
    }
  }

  void reset() {
    for (int i = 0; i < register.length; i++) {
      register[i].reset();
    }
  }

  void inc() {
    this.clock();
  }

  void dec() {
    for (int i = 0; i < register.length; i++) {
      register[i].state = !register[i].state;
      if ( i != 0 ) register[i].previousClock = register[i-1].state;
    }
    this.clock();
    for (int i = 0; i < register.length; i++) {
      register[i].state = !register[i].state;
      if ( i != 0 ) register[i].previousClock = register[i-1].state;
    }
  }

  void clock() {
    for (int i = 0; i < register.length; i++) {
      if (i == 0) {
        register[0].state = !register[0].state;
      } else {
        register[i].flip(register[i-1].state);
      }
    }
  }

  void clock(boolean clockInput) {
    for (int i = 0; i < register.length; i++) {
      if (i == 0) {
        register[0].flip(clockInput);
      } else {
        register[i].flip(register[i-1].state);
      }
    }
  }

  void display() {
    for (int i = 0; i < register.length; i++) {
      print(int(register[i].state));
    }
    println();
  }

  void display(int Q, int x, int y) {
    loadPixels();
    pixels[y*width + x]=color(int(register[Q].state)*255);
    updatePixels();
  }

  class FlipFlop {  
    boolean state;
    boolean currentClock;
    boolean previousClock;

    FlipFlop() {
      state=false;
    }

    FlipFlop(boolean init) {
      state=init;
    }

    void flip(boolean clock) {
      currentClock = clock;
      if (!currentClock && previousClock) {
        state = !state;
      }
      previousClock = currentClock;
    }

    void reset() {
      state = false;
      currentClock = false;
      previousClock = false;
    }
  }
}

