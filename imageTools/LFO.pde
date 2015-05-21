class LFO {
  float theta;
  float phi;
  float freq;
  float inc;
  
  LFO(float _inc, float _theta, float _phi){
    inc = _inc;
    theta = _theta;
    phi = _phi;
    freq = 1;
  }
  
  LFO(float _inc, float _phi){
    inc = _inc;
    theta = 0;
    phi = _phi;
    freq = 1;
  }
  
  LFO(float _inc){
    freq = 1;
    phi = 0;
    theta = 0;
    inc = _inc;
  }
  
  LFO(){
    theta = 0;
    phi = 0;
    freq = 1;
    inc = random(1);
  }
  
  float update(float _inc, float _phase){
    inc = _inc;
    phi = _phase;
    float output = sin(2*PI*freq*(theta/255)+phi);
    theta+=inc;
    theta%=256;
    return output;
  }
  
  float update(float _inc){
    inc = _inc;
    float output = sin(2*PI*freq*(theta/255)+phi);
    theta+=inc;
    theta%=256;
    return output;
  }
  
  float update(){
    float output = sin(2*PI*freq*(theta/255)+phi);
    theta+=inc;
    theta%=256;
    return output;
  }
  
 void reset(){
    inc = 0;
    theta = 0;
    phi = 0;
    freq = 1;
  }
  
}
