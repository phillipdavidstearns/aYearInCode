PGraphics gradient;

void setup(){
  size(1000,1000, P3D);
  gradient = createGradient(500, 500);
//  noLoop();
}

PGraphics createGradient(int w, int h){
  PGraphics graphic = createGraphics(w, h, P3D);
  graphic.beginDraw();
  graphic.loadPixels();
  color colorA = color(random(256),random(256),random(256));
  color colorB = color(random(256),random(256),random(256));
  color colorC = color(random(256),random(256),random(256));
  color colorD = color(random(256),random(256),random(256));
  for(int y = 0 ; y < graphic.height ; y++){
    color colorL = lerpColor(colorA, colorB, float(y)/float(graphic.height-1));
    color colorR = lerpColor(colorC, colorD, float(y)/float(graphic.height-1));
    for(int x = 0 ; x < graphic.width ; x++ ){
      graphic.pixels[y*graphic.width+x] = lerpColor(colorL, colorR, float(x)/float(graphic.width-1));
    }
  }
  graphic.updatePixels();
  graphic.endDraw();
  return graphic;
}

void draw(){ 
  background(255);
//  image(gradient, 250,250);
  noStroke();
  translate(500, 500, 0); 
  rotateX(2*PI*(mouseY)/height);
  rotateY(2*PI*(mouseX)/width);
  rotateZ(0.5);
  float dims = 100;
  
  float h = gradient.height;
  float w = gradient.width;
  
  //top  
  beginShape();
  texture(gradient);
  vertex(-dims,-dims, dims, 0, 0);
  vertex(dims,-dims, dims, w, 0);
  vertex(dims,dims, dims, w, h);
  vertex(-dims,dims, dims, 0, h);
  endShape();
  
  //bottom
  beginShape();
  texture(gradient);
  vertex(dims, dims, -dims, 0, 0);
  vertex(-dims, dims, -dims, w, 0);
  vertex(-dims,-dims, -dims, w, h);
  vertex(dims, -dims, -dims, 0, h);
  endShape();
 
  //left
  beginShape();
  texture(gradient);
  vertex(-dims, dims, dims, 0, 0);
  vertex(-dims, -dims, dims, w, 0);
  vertex(-dims, -dims, -dims, w, h);
  vertex(-dims, dims, -dims, 0, h);
  endShape();
 
  //right
  beginShape(); 
  texture(gradient);
  vertex(dims, -dims, -dims, 0, 0);
  vertex(dims, dims, -dims, w, 0);
  vertex(dims, dims, dims, w, h);
  vertex(dims, -dims, dims, 0, h);
  endShape();
  
  //front
   beginShape(); 
  texture(gradient);
  vertex(dims, dims, -dims, 0, 0);
  vertex(dims, dims, dims, w, 0);
  vertex(-dims, dims, dims, w, h);
  vertex(-dims, dims, -dims, 0, h);
  endShape();

  //back
  beginShape(); 
  texture(gradient);
  vertex(-dims, -dims, dims, 0, 0);
  vertex(-dims, -dims, -dims, w, 0);
  vertex(dims, -dims, -dims, w, h);
  vertex(dims,-dims, dims, 0, h);
  endShape();
  
 
  
}

void keyPressed(){
  switch(key){
    case 'r':
    gradient = createGradient(500, 500);
    break;
  }
  redraw();
}
