float spread1;
float spread2;
float scale;
float center;
float power1, power2;

void setup() {
  size(500, 500);
  scale = 200;
  spread1 = 500;
  spread2 = 200;
  center = 500;
  power1 = 2;
  power2 = 1;
}

void draw() {
  
  for(int i = 0 ; i < width ; i++){
    noSmooth();
//    stroke(color(255*probabilitySine(i, center, spread1, power1, spread2, power2)));
    stroke(color(255*probabilitySine(i, width, width, 2)));

    line(i,0,i,height);
  }
  makeGraph();
  //  center++;
  //  println(offset);
  stroke(255);
  //  line(0,height/2,width,height/2);
  line(width/2, 0, width/2, height);
  
}

void keyPressed(){
  switch(key){
   
    case '-':
      power1 -= .1;
      if (power1 < 0 ) power1 = 0;
      println("power1: " + power1);
    break;
    case '=':
      power1+=.1;
    break;
    case '[':
      power2 -= .1;
      if (power2 < 0 ) power2 = 0;
      println("power2: " + power2);
    break;
    case ']':
      power2+=.1;
    break;
  }
}

float probabilitySine(float _x, float _center, float _width1, float _power1, float _width2, float _power2){
  if (_x >= _center - _width1 && _x < _center) {
    return  pow(sin(2*PI*(.25*(_x - _center + _width1)/_width1)), _power1);
    } else if ( _x >= _center && _x <= _center + _width2) {
    return  pow(sin(2*PI*(.25*(_x - _center)/_width2) + (PI/2)), _power2);
    } else {
      return 0;
    }
}

float probabilitySine(float _x, float _center, float _width, float _power){
  if (_x >= _center - _width && _x < _center) {
    return  pow(sin(2*PI*(.25*(_x - _center + _width)/_width)), _power);
    } else if ( _x >= _center && _x <= _center + _width) {
    return  pow(sin(2*PI*(.25*(_x - _center)/_width) + (PI/2)), _power);
    } else {
      return 0;
    }
}

void makeGraph() {
  loadPixels();
  int y;
  int x = 0;
  int sin_val = 0 ;
  int p_sin;
  for (int i = 0; i < width; i++) {
    if (i >= center - spread1 && i < center) {
      sin_val = int(scale * pow(sin(2*PI*(.25*(i - center + spread1)/spread1)), power1));
    } else if ( i >= center && i <= center + spread2) {
      sin_val = int(scale * pow(sin(2*PI*(.25*(i - center)/spread2) + (PI/2)), power2));
    }
    x=i;

    if (sin_val <= 0) {
      y = (height/2);
    } else {
      y = ((height/2)-sin_val);
    }

    pixels[y*width+x] = color(255);
  }
  updatePixels();
}

