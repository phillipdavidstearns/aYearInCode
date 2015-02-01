Tile[] tiles;

float tile_size = 80;
int tiles_wide=4;
int tiles_high=8;
int qty_tiles;
int column = 0;

Table table;

boolean sketchFullScreen() {
  return true;
}

void setup() {
  size(displayWidth, displayHeight, P2D);
  frameRate(1);
  if (frame != null) {
    frame.setResizable(true);
  }
  
  table = loadTable("input/pindex.csv");


  qty_tiles = tiles_wide * tiles_high;
  tiles = new Tile[qty_tiles];

  println(tiles_wide);
  println(tiles_high);
  println(qty_tiles);
  
  float r = tile_size;
  float x = r / 2;
  float y = r / 2 * sqrt(3);
  float y_offset = 200;
  float x_offset = 100;
  
  for(int _y = 0 ; _y < tiles_high ; _y++){
    for(int _x = 0 ; _x < tiles_wide ; _x++){
      int index=_x+(tiles_wide*_y);
      if(_y%2 == 0){
      tiles[index] = new Tile(_x*(3*tile_size)+3*tile_size+x_offset, _y*(y)+(y_offset), tile_size);
      } else {
      tiles[index] = new Tile(_x*(3*tile_size)+3*x+x_offset, _y*(y)+(y_offset), tile_size);
      }
    }
  }
}



void draw() {
  background(0);
  for(int y = 0 ; y < tiles_high ; y++){
    for(int x = 0 ; x < tiles_wide ; x++){
      int index = x+ (y*tiles_wide);
      tiles[index].display(index, 0, table.getFloat(index,column));
    }
  }
  if(frameCount % 30 == 29 ){
    refreshPrices();
  }
  
}

void keyPressed(){
  if(keyCode == 32){
    refreshPrices();
  }
  if(keyCode == 82 ){
    table = loadTable("input/pindex.csv");
  }
}

void refreshPrices(){
  for(int i = 0 ; i < table.getRowCount() ; i ++ ){
    table.setFloat(i,0, (table.getFloat(i,0)+random(-1,1)));
  }
}

class Tile{
  
  PVector location;
  color fill_color;
  color stroke_color;
  PShape hex;
  float r;
  float x;
  float y;
  
  Tile(float _x, float _y, float _size){
    r = _size;
    x = r / 2;
    y = r / 2 * sqrt(3);
    location = new PVector(_x, _y);
    fill_color = color(0);
    stroke_color = color(255);
    hex = createShape();
    hex.beginShape();
    hex.fill(fill_color);
    hex.stroke(stroke_color);
    hex.strokeWeight(1);
    hex.vertex(-x, y);
    hex.vertex(x, y);
    hex.vertex(2*x, 0);
    hex.vertex(x, -y);
    hex.vertex(-x, -y);
    hex.vertex(-2*x, 0);
    hex.endShape(CLOSE);  
  }
  
  void display(int index, color _fill_color, float _price){
    hex.resetMatrix();
    hex.translate(location.x, location.y);
    hex.setFill(color(_fill_color));
    shape(hex);
    textSize(16);
    fill(255);
    text(index,location.x-x,location.y+y-5);
    textSize(16);
    fill(0xFF13FF75);
    text(_price,location.x-(1.5*x),location.y+(y/2));
  } 
}

