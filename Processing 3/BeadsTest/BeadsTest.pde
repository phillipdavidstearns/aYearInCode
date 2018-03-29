import beads.*;
import java.util.Arrays; 

AudioContext ac;
Buffer b;
WavePlayer wp;
int reg1 = 0; //32 

void setup() {
  size(1920, 1080);
  //create new AudioContext for Beads to run
  ac = new AudioContext();
  //create new Buffer for us to store 
  b = new Buffer(128);
  //load the Buffer with a starting value
  reg1=randomInt();
  loadBuffer(b, reg1);
  //create a new WavePlayer to play the gabage we just put in the buffer
  wp = new WavePlayer(ac, 30, b);
  //setup a new Clock to serve are our framrate independent time keeper
  Clock clock = new Clock(ac, 1);
  clock.addMessageListener(
    new Bead() {
    public void messageReceived(Bead message) {
      Clock c = (Clock)message;
      if (c.isBeat()) {
        reg1 = LFSR(reg1, 15, 16);
      }
    }
  }
  );
  ac.out.addDependent(clock);
  ac.out.addInput(wp);
  ac.start();
}

void draw() {
  //println(binary(randomInt()));
  loadBuffer(b, reg1);
  loadPixels();
  for (int y = 0; y < height; y++) {
    for (int i = 0; i < b.buf.length; i++) {
      for (int j = 0; j < 1920/b.buf.length; j++) {
        int x = i*(1920/b.buf.length)+j;
        if (b.buf[i] == 1) {
          pixels[y*width+x]=color(255);
        } else {
          pixels[y*width+x]=color(0);
        }
      }
    }
  }
  updatePixels();
}

int LFSR(int data, int tap1, int tap2) {
  return (data << 1) ^ (data >> tap1 & 1) ^ (data >> tap2 & 1);
}

void keyPressed() {
  reg1 = randomInt();
}

void loadBuffer(Buffer _b, int data) {
  for (int i = 0; i < _b.buf.length; i++) {
    if (boolean((data >> (i % 32)) & 1)) {
      _b.buf[i] = 1;
    } else { 
      _b.buf[i] = -1;
    }
  }
}

int randomInt() {
  int val = 0;
  for (int i = 0; i < 32; i++) {
    val |= randomBit() << i;
  }
  return val;
}

int randomBit() {
  return int(random(2)) & 1;
}