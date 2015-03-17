PImage src;
PImage buffer;

int block_size;

PVector click_location;
PVector displacement;
void setup() {
  src = loadImage("input/random-dog.jpg");
  buffer = createImage(src.width, src.height, RGB);
  size(src.width, src.height);
  image(src, 0, 0);
  click_location = new PVector(0, 0);
  displacement = new PVector(0, 0);
}

void draw() {
  loadPixels();

  buffer.pixels=pixels;


  displacement.set(mouseX, mouseY);


  int _width = block_size;
  int _height = block_size;

  buffer.loadPixels();

  for (int y = 0; y < _width; y++) {
    for (int x = 0; x < _height; x++) {
      int capture_x = (int(click_location.x) + x)%(width);
      if (x < 0 ) capture_x = capture_x + width - 1;
      int capture_y = (int(click_location.y) + y)%(height);
      if (y < 0 ) capture_y = capture_y + height - 1;

      int displacment_x = (int(displacement.x) + x)%(width);
      if (x < 0 ) displacment_x = displacment_x + width - 1;
      int displacement_y = (int(displacement.y) + y)%(height);
      if (y < 0 ) displacement_y = displacement_y + height - 1;

      buffer.pixels[displacment_x+(width*displacement_y)]=pixels[capture_x + (capture_y * width)];
    }
  }
  buffer.updatePixels();
  fill(255);
  stroke(255);
  point(mouseX, mouseY);
  image(buffer, 0, 0);
}

void mousePressed() {
  if (mouseButton == LEFT) {
  } else if (mouseButton == RIGHT) {
    click_location.set( mouseX, mouseY );
    println("x: " + click_location.x + " y: " + click_location.y);
  }
}

