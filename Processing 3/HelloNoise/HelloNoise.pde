// Hello_Sine.pde

// import the beads library (you must have installed it properly. as of this writing, it is not included with Processing)
import beads.*;

// create our AudioContext, which will oversee audio input/output
AudioContext ac;
Buffer b;
int n;

void setup()
{
  size(400, 300);
  n=Float.floatToIntBits(random(12341324));
  println(n);
  // initialize our AudioContext
  ac = new AudioContext();
  b = new Buffer(4096);
  randomize(b);
  // create a WavePlayer
  
  // WavePlayer objects generate a waveform, in this case, a sine wave at 440 Hz
  WavePlayer wp = new WavePlayer(ac, 30, b);
  
  // connect the WavePlayer to the AudioContext
  ac.out.addInput(wp);
  
  // start audio processing
  ac.start();
}

void draw(){
  if(keyPressed)randomize(b);
  loadPixels();
  for(int i = 0 ; i < pixels.length;i++){
    int pixel = Float.floatToIntBits(b.buf[i%b.buf.length]);
    pixels[i]=color(pixel >> 16 & 0xFF, pixel >> 8 & 0xFF, pixel & 0xFF);
  }
  updatePixels();
}

void randomize(Buffer _b){
  for(int i = 0; i < _b.buf.length; i++){
    n = shiftLeft(n);
    _b.buf[i]= Float.intBitsToFloat(n);
  }
}

int shiftLeft(int val){
  int shift = val >> 1;
  int recirc = (val & 1) << 31;
  return shift | recirc; 
}

void keyPressed(){
  n=Float.floatToIntBits(random(-1,1));
  randomSeed(key);
}
