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
      if( i != 0 ) register[i].previousClock = _input[i-1];
    }
  }
  
  void load(boolean[] _input){
    for(int i = 0 ; i < _input.length ; i++){
      register[i].state = _input[i];
    }
  }

  void reset() {
    for (int i = 0; i < register.length; i++) {
      register[i].reset();
    }
  }

  void increment(){
    this.clock();
  }
  
  void decrement(){
    for (int i = 0; i < register.length; i++) {
      register[i].state = !register[i].state;
      if( i != 0 ) register[i].previousClock = register[i-1].state;
    }
    this.clock();
    for (int i = 0; i < register.length; i++) {
      register[i].state = !register[i].state;
      if( i != 0 ) register[i].previousClock = register[i-1].state;
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
}
