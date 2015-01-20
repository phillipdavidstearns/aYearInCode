PImage srcImg;
PImage block;
int block_size = 16;
int sample_pos_x;
int sample_pos_y;
PVector block_pos;
PVector block_velocity;

void setup(){
  srcImg = loadImage("input/yungjake.png");
  size(srcImg.width, srcImg.height);
  block = createImage(block_size, block_size, RGB);
  sample_pos_x = int(random(width-block_size-2));
  sample_pos_y = int(random(height-block_size-2));
  block_pos = new PVector(width/2,height/2);
  block_velocity = new PVector(random(.5),random(.5));
  //copy part of the image to the block... can be written as a function later...
  for(int y = 0 ; y < block_size ; y++){
    for(int x = 0 ; x < block_size ; x++){
      block.pixels[block_size*y+x] = srcImg.pixels[(sample_pos_x + x) + ((sample_pos_y + y ) * width)];
    }
  }
  image(srcImg, 0, 0);
}

void draw(){
  
  
  
  
  moveBlock();
  image(block, block_pos.x,  block_pos.y);
  
}

void moveBlock(){
  block_velocity = new PVector(random(4)-2,random(4)-2);

  block_pos.add(block_velocity);
  if(block_pos.x > width-block_size && block_pos.x < 0 ){
    block_pos.x = 0;
  }
  if(block_pos.y > height-block_size && block_pos.y < 0 ){
    block_pos.y = 0;
  }
}
  
void mousePressed() {
    sample_pos_x = int(random(width-(block_size*2)));
    sample_pos_y = int(random(height-(block_size*2)));
  for(int y = 0 ; y < block_size ; y++){
    for(int x = 0 ; x < block_size ; x++){
      block.pixels[block_size*y+x] = srcImg.pixels[(sample_pos_x + x) + ((sample_pos_y + y ) * width)];
    }
  }
    block_pos.x=mouseX;
    block_pos.y=mouseY;
    for(int y = 0 ; y < block_size ; y++){
    for(int x = 0 ; x < block_size ; x++){
      block[block_size*y+x] = srcImg.pixels[(sample_pos_x + x) + ((sample_pos_y + y ) * width)];
    }
  }
  }
