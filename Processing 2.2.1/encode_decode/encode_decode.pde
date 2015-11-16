Register register;
String data;
int tap_1 = 0;
int tap_2 = 0;

void setup(){
  register = new Register(8);
  register.randomize();
  noLoop();
}

void draw(){
  println(register.states());
  println(register.value());
}


void keyPressed() {
  switch(key) {
    case 'd':
    register.invert();
    break;
    case 'f':
    register.reverse();
    break;
  case 'c':
    register.reset();
    break;
  case 'r': 
    register.randomize();
    break;
  case 's':
    register.increment();
    break;
  case 'a':
    register.decrement();
    break;
  case 'q':
    register.shiftLeft(register.data[register.data.length-1]);
    break;
   case 'w':
    register.shiftRight(register.data[0]);
    break;
  }
  redraw();
}

