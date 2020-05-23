boolean[] row;
int page;
boolean changeRule = true;
boolean scroll = false;
boolean save = false;
boolean colorMode = true;
int shift = 0; // factor for shifting the subsequent row when drawn
int qty_neighbors = 6  ; // how many cells from the previous row are considered
int qty_colors = 2; // colordepth
int counter_shift = 0 ;
int tap_1 = 27;
int tap_2 = 231;
int tap_3 = 127;
int tap_4 = 31;

int designWidth = 5100;
int designHeight = 5100;

int scale = 1; // magnification factor
int xoffset = 0; //shifts magnified view
int yoffset = 0; //shifts magnified view

boolean tap_1_en = true;
boolean tap_2_en = true;
boolean tap_3_en = true;
boolean tap_4_en = true;

boolean jam = false; //force an input

String thePath;
String initial_rule = new String("0100000000000000000000000000001000000000000001000000000001000001");
PImage design;

color[] colors;


int qty_neighbor_combinations = int(pow(qty_colors, qty_neighbors));


ShiftRegister register;
ShiftRegister rules;

void setup() {
  size(1280, 720);
  design = createImage(designWidth, designHeight, RGB);

  rules = new ShiftRegister(qty_neighbor_combinations);
  
  for (int i = 0; i < rules.data.length; i++) {
    if (initial_rule.charAt(rules.data.length-1-i) == '0') {
      rules.data[i] = false;
    } else if (initial_rule.charAt(rules.data.length-1-i) == '1') {
      rules.data[i] = true;
    }
  }

  row = new boolean[design.width];
  register = new ShiftRegister(design.width);
  register.randomize();
  generatePalette(1);
  register.reset();
  shiftRegisterToRow();
  updateDesign();

  noSmooth();
  noLoop();
}

void draw() {
  updateDesign();
  background(0);
  image(design, 0+(xoffset*scale), 0+(yoffset*scale), design.width*scale, design.height*scale);
}

void generatePalette(int mode) {
  colors = new color[qty_neighbor_combinations];
  switch(mode) {
  case 0:
    color colorA = color(random(256), random(256), random(256));
    color colorB = color(random(256), random(256), random(256));
    for (int i = 0; i < colors.length; i++) {
      colors[i] = lerpColor(colorA, colorB, float(i)/float(colors.length-1));
    }
    break;
  case 1:
    for (int i = 0; i < colors.length; i++) {
      colors[i] = color(random(256), random(256), random(256));
    }

    break;
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

void updateDesign() {

  design.loadPixels();
  shiftRegisterToRow();
  for (int i = 0; i < design.height; i++) {
    drawRow(i);
    applyRules(countNeighbors());
  }
  design.updatePixels();
  println(rule());
}



void keyPressed() {
  switch(key) {
  case 'n':
    colorMode=!colorMode;
    break;
  case 'v':
    generatePalette(0);
    break;
  case 'b':
    generatePalette(1);
    break;
  case 'd':
    invertRules();
    break;
  case 'f':
    reverseRules();
    break;
  case 'x':
    register.reset();
    shiftRegisterToRow();
    break;
  case 'c':
    register.reset();
    register.data[int(register.data.length/2)] = true;
    shiftRegisterToRow();
    break;
  case 'j':
    jam = true;
    break;
  case '1':
    tap_1_en = !tap_1_en;
    break;
  case '2':
    tap_2_en = !tap_2_en;
    break;
  case '3':
    tap_3_en = !tap_3_en;
    break;
  case '4':
    tap_4_en = !tap_4_en;
    break;
  case 'r': 
    register.randomize();
    shiftRegisterToRow();
    break;
  case 's':
    incrementRule();
    println("shift: " + shift);
    break;
  case 'a':
    decrementRule();
    println("shift: " + shift);
    break;
  case 'q':
    register.shiftLeft(register.data[register.data.length-1]);
    break;
  case 'w':
    register.shiftRight(register.data[0]);
    break;
  case'-':
    shift--;
    println("shift: " + shift);
    break;
  case'=':
    shift++;
    println("shift: " + shift);
    break;
  case 'p':
    rules.randomize();
    println("shift: " + shift);
    break;
  case 'o':
    save_file();
    break;
  case',':
    rules.shiftLeft(rules.data[rules.data.length-1]);
    break;
  case'.':
    rules.shiftRight(rules.data[0]);
    break;
  case 'z':
    rules.reset();
    break;
  case'[':
    rules.shiftLeft(rules.data[15]^rules.data[16]);
    break;
  case']':
    rules.shiftRight(rules.data[1]^rules.data[0]);
    break;
  case'_':
    if (scale > 1) scale--;
    break;
  case'+':
    scale++;
    break;
  }
  switch(keyCode) {
  case 37: //left
    xoffset+=50;
    break;
  case 38: //up
    yoffset+=50;
    break; 
  case 39: //right
    xoffset-=50;
    break; 
  case 40: //down
    yoffset-=50;
    break;
  }
  redraw();
}

void save_file() {
  selectOutput("Select a file to process:", "outputSelection");
}

void outputSelection(File output) {
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    thePath = output.getAbsolutePath();
    saveData(thePath);
  }
}

void saveData(String _thePath) {
  design.save(_thePath + "_" + rule() + "_" + shift +".PNG");
  println("Done Saving! " + _thePath);
  save = false;
}

void randomizeLine() {
  for (int i = 0; i < design.width; i++) {
    if (random(1) < random(1)) {
      row[i]=true;
    } else {
      row[i]=false;
    }
  }
}

void shiftRegisterToRow() {
  for (int i = 0; i < design.width; i++) { 
    row[i]=register.data[i];
  }
}

void drawRow(int _y) {
  int[] states = countNeighbors();
  for (int x = 0; x < design.width; x++) {
    if (colorMode) {
      design.pixels[_y * design.width+x] = color(255*int(row[x]));
    } else {
      design.pixels[_y * design.width+x] = colors[states[x]];
    }
  }
}



void shiftUp() {
  for (int i = 0; i < design.pixels.length-design.width; i++) {
    design.pixels[i] = design.pixels[i+design.width];
  }
}

int[] countNeighbors() { 
  int[] state = new int[design.width];
  for (int i = 0; i < design.width; i++) {
    for (int n = 0; n < qty_neighbors; n++) {
      int coord = ((i + shift) + design.width + (n - int(qty_neighbors/2))) % design.width;
      state[i] |= int(row[coord]) << ((qty_neighbors-1) - n);
    }
  }
  return state;
}

void applyRules(int[] _states) {
  for (int i = 0; i < design.width; i++) {
    row[i] = rules.data[_states[i]];
  }
}

/*********begin class definitions********/

//Counter is a class of objects that have n number of stages.
//The counter operates like a binary ripple counter similar to the CD4040.
//Creation arguments: int size
//Methods:
//clock() - increments the counter
//clock(boolean clockInput) - allows an external clock to increment the counter. triggered on "falling edge" transistion from true to false.
//reset() - sets all stages to false
//display() - prints the counter's internal state from Least significant bit to Most significant bit from left to right (reverse binary)
//display(int Q, int x, int y) - changes the pixel at the coordinates x, y to match the output state of stage Q
//length() returns int - number of stages in the current counter
//getState(int Q) - returns boolean - the value of stage Q



class ShiftRegister {

  boolean[] data;

  ShiftRegister(int _length) {
    this.data = new boolean[_length];
    this.init();
  }
  
  void init(){
    for (int i = 0; i < this.data.length; i++) {
      if (i == 0) { 
        this.data[0] = true ;
      } else {
        this.data[i] = false;
      }
    }
  }

  void load(boolean[] _input) {
    for (int i = 0; i < this.data.length; i++) {
      this.data[i] = _input[i];
    }
  }

  void shiftLeft(boolean _input) {
    for (int i = this.data.length-1; i > 0; i--) {
      this.data[i] = this.data[i-1];
    }
    this.data[0] = _input;
  }

  void shiftLeft() {
    for (int i = this.data.length-1; i > 0; i--) {
      this.data[i] = this.data[i-1];
    }
    this.data[0] = false;
  }

  void shiftRight(boolean _input) {
    for (int i = 0; i < this.data.length-1; i++) {
      this.data[i] = this.data[i+1];
    }
    this.data[this.data.length-1] = _input;
  }

  void shiftRight() {
    for (int i = 0; i < this.data.length-1; i++) {
      this.data[i] = this.data[i+1];
    }
    this.data[this.data.length-1] = false;
  }

  void reset() {
      this.init();
  }
  
  void clear(){
    for (int i = 0; i < this.data.length; i++) {
        this.data[i] = false;
    }
  }

  void randomize() {
    for (int i = 0; i < this.data.length; i++) {
      if (random(1) < 0.5) {
        this.data[i]=true;
      } else {
        this.data[i]=false;
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

  //FlipFlop is a clas of objects that behave like flipflop logic circuits.
  //Creation arguments: boolean init - sets initial state (optional)
  //Methods:
  //flip(boolean clock) - causes the flipflop to change states. triggered by "falling edge", true to false, logic transistion.
  //setState(boolean set) - sets register to set
  //reset() - resets register state to false
  //getState() - returns boolean - the value of the state

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
