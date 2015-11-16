PImage satins[];
PGraphics satin_gradient;
PImage noise_gradient;
int color_depth = 9;
float spread = 1.75;
float step = .01;
int mode = 2;
int buffer;
void setup() {
  size(10, 10);
  satins = new PImage[7];
  for (int i = 0; i < satins.length; i++) {
    satins[i] = loadImage("satin_8-"+(7-i)+".png");
  }
  noise_gradient = createImage(1024, 1024, RGB);
  //  satin_gradient = createGraphics(noise_gradient.width*8, noise_gradient.height*8);

  buffer = int(noise_gradient.height * .125);
  size(noise_gradient.width, noise_gradient.height);
  makeGradient(mode);

  noLoop();
}

void draw() {
  makeGradient(mode);
  image(noise_gradient, 0, 0);
}


void keyPressed() {
  switch(key) {
  case 'q':
    mode=0;

    redraw();
    break;
  case 'w':
    mode=1;

    redraw();
    break;
  case 'e':
    mode=2;

    redraw();
    break;
  case '-':
    spread-=step;
    if (spread < 0) spread = 0.01;

    redraw();
    break;
  case '=':
    spread+=step;

    redraw();
    break;
  case '[':
    if (color_depth > 2) color_depth--;

    redraw();
    break;
  case ']':
    color_depth++;

    redraw();
    break;
  case '1':
    step = .01;
    break;
  case '2':
    step = .05;
    break;
  case '3':
    step = .1;
    break;
  case '4':
    step = .125;
    break;
  case '5':
    step = .25;
    break;
  case '6':
    step = .5;
    break;
  case '7':
    step = 1;
    break;
  case '0':
    step = 0;
    break;
  case 'r':
    redraw();
    break;
  case 's':
    saveGradient();
    break;
  }
  println("color depth: " + color_depth);
  println("step: "+step);
  println("spread: "+spread);
}

void saveGradient() {
  String file = "output/"+color_depth+"_"+"gaussian_stepped_gradient_"+noise_gradient.width+"w_"+noise_gradient.height+"h_"+spread+"_spread_"+buffer+"_buffer.png";
  println("saving file: " + file);
  noise_gradient.save(file);
  println("done!");
}


void makeGradient(int _mode) {
  noise_gradient.loadPixels();
  switch(_mode) {
  case 0:
    linearGradient();
    break;
  case 1:
    sinusoidalGradient();
    break;
  case 2:
    gaussianGradient();
    break;
  }
  noise_gradient.updatePixels();
}


void linearGradient() {

  for (int y = 0; y < noise_gradient.height; y++) {
    float[] linear_values = new float[color_depth];
    float linear_sum = 0;
    for (int i = 0; i < color_depth; i++) {
      linear_values[i] = linear(float(y), buffer+(float(i)+.5)*(float(noise_gradient.height-(2*buffer))/float(color_depth)), spread*float(noise_gradient.height)/float(color_depth));
      linear_sum += linear_values[i];
    }
    for (int x = 0; x < noise_gradient.width; x++) {
      noise_gradient.pixels[y*noise_gradient.width+x] = compute_color(linear_values, linear_sum);
    }
  }
}

void sinusoidalGradient() {
  for (int y = 0; y < noise_gradient.height; y++) {
    float[] sine_values = new float[color_depth];
    float sine_sum = 0;
    for (int i = 0; i < color_depth; i++) {
      sine_values[i] = sinusoidal(float(y), buffer+(float(i)+.5)*(float(noise_gradient.height-(2*buffer))/float(color_depth)), spread*float(noise_gradient.height)/float(color_depth), 3);
      sine_sum += sine_values[i];
    }
    for (int x = 0; x < noise_gradient.width; x++) {
      noise_gradient.pixels[y*noise_gradient.width+x] = compute_color(sine_values, sine_sum);
    }
  }
}

void gaussianGradient() {
  for (int y = 0; y < noise_gradient.height; y++) {
    float[] gaussian_values = new float[color_depth];
    float gaussian_sum = 0;
    for (int i = 0; i < color_depth; i++) {
      gaussian_values[i] = gaussian(float(y), buffer+(float(i)+.5)*(float(noise_gradient.height-(2*buffer))/float(color_depth)), .25*spread*float(noise_gradient.height)/float(color_depth));
      gaussian_sum += gaussian_values[i];
    }
    for (int x = 0; x < noise_gradient.width; x++) {
      noise_gradient.pixels[y*noise_gradient.width+x] = compute_color(gaussian_values, gaussian_sum);
    }
  }
}

color compute_color(float[] _values, float _sum) {
  float index = random(_sum);
  color c = color(0);
  float threshold = 0;
  for (int i = 0; i < _values.length; i++) {
    threshold += _values[i];
    if (index <= threshold) {
      c = color((float(i)/float(_values.length-1))*255);
      break;
    }
  }
  return c;
}

float gaussian(float _x, float _b, float _c) {
  return exp(-1 * pow(_x - _b, 2) / (2 * pow(_c, 2)));
}

float sinusoidal(float _x, float _center, float _width, float _power) {
  if (_x >= _center - _width && _x < _center) {
    return  pow(sin(2*PI*(.25*(_x - _center + _width)/_width)), _power);
  } else if ( _x >= _center && _x <= _center + _width) {
    return  pow(sin(2*PI*(.25*(_x - _center)/_width) + (PI/2)), _power);
  } else {
    return 0;
  }
}

float linear(float _position, float _center, float _width) {
  if (_position >= _center - _width && _position < _center) {
    return  (_position - _center + _width)/_width;
  } else if ( _position >= _center && _position <= _center + _width) {
    return  1 - (_position - _center)/_width;
  } else {
    return 0;
  }
}

