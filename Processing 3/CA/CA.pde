int reg = 1;
byte rules = 0;
int bitDepth = 16;

void setup(){
  size(10,10);
  frameRate(5);
  randomizeRules();

}

void keyPressed(){
    randomizeRules();
}

void randomizeRules(){
  reg = int(random(pow(2,bitDepth)));
  rules = byte(int(random(pow(2,8))));
  println(binary(rules,8));
}

void draw(){
 println(binary(reg,16));

reg = applyRules();

}

int applyRules(){
  int result = 0;
  for(int i = 0 ; i < bitDepth; i++){
    int state = 0;
    for(int n = 0; n < 3; n++){
      int coord = ((i + bitDepth + (n-1)) % bitDepth);
      state |= (reg >> coord & 1) << (2-n);
    }  
    result |= ((rules >> state) & 1) << i;
  }
  return result;
}