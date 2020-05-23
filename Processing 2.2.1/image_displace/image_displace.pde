PImage src;
PImage buffer;

int block_size = 128;

PVector click_location;
PVector displacement;
void setup() {
  size(10, 10);
  src = loadImage("input/david.jpg");
  surface.setSize(src.width, src.height);
  buffer = createImage(src.width, src.height, RGB);
  size(src.width, src.height);
  image(src, 0, 0);
  click_location = new PVector(0, 0);
  displacement = new PVector(0, 0);
}

void draw() {
  loadPixels();
  buffer.pixels=pixels;
  if(mousePressed && mouseButton == LEFT){
    
    displacement.set(mouseX, mouseY);
//    println("x: " + displacement.x + " y: " + displacement.y);
    
    int _width = block_size;
    int _height = block_size;
  
    buffer.loadPixels();
  
    for (int y = 0; y < _width; y++) {
      for (int x = 0; x < _height; x++) {
        int capture_x = (int(click_location.x) + x)%(width);
        if (capture_x < 0 ) capture_x = capture_x + width - 1;
        int capture_y = (int(click_location.y) + y)%(height);
        if (capture_y < 0 ) capture_y = capture_y + height - 1;
  
        int displacment_x = (int(displacement.x) + x)%(width);
        if (displacment_x < 0 ) displacment_x = displacment_x + width - 1;
        int displacement_y = (int(displacement.y) + y)%(height);
        if (displacement_y < 0 ) displacement_y = displacement_y + height - 1;
  
        buffer.pixels[displacment_x+(width*displacement_y)]=pixels[capture_x + (capture_y * width)];
      }
    }
  }
  buffer.updatePixels();
  image(buffer, 0, 0);
}

void mousePressed() {
  if (mouseButton == LEFT) {
  } else if (mouseButton == RIGHT) {
    click_location.set( mouseX, mouseY );
    println("x: " + click_location.x + " y: " + click_location.y);
  }
}

void keyPressed(){
  if(key == 's'){
    saveFrame("output/image_displace_"+ year()+"_"+month()+"_"+day()+"-"+frameCount+".png");
  }
  if(key == 'r'){
    image(src, 0, 0);
  }
}
