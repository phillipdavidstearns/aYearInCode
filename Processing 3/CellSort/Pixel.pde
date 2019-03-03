class Pixel {
  int x;
  int y;
  color c;
  
  Pixel(int _x, int _y, color _c){
    x=_x;
    y=_y;
    c=_c;
  }
  
  boolean isGreater(Pixel _px){
    return c > _px.c;
  }
  
  boolean hIsGreater(Pixel _px){
    return hue(c) > hue(_px.c);
  }
  
  boolean sIsGreater(Pixel _px){
    return saturation(c) > saturation(_px.c);
  }
  
  boolean vIsGreater(Pixel _px){
   return brightness(c) > brightness(_px.c);
  }
  
  boolean rIsGreater(Pixel _px){
    return red(c) > red(_px.c);
  }
  
  boolean gIsGreater(Pixel _px){
    return green(c) > green(_px.c);
  }
  
  boolean bIsGreater(Pixel _px){
    return blue(c) > blue(_px.c);
  }
  
  boolean isGreater(color _c){
    return c > _c;
  }
  
  boolean hIsGreater(color _c){
    return hue(c) > hue(_c);
  }
  
  boolean sIsGreater(color _c){
    return saturation(c) > saturation(_c);
  }
  
  boolean vIsGreater(color _c){
    return brightness(c) > brightness(_c);
  }
  
  boolean rIsGreater(color _c){
    return red(c) > red(_c);
  }
  
  boolean gIsGreater(color _c){
    return green(c) > green(_c);
  }
  
  boolean bIsGreater(color _c){
    return blue(c) > blue(_c);
  }
  
  Pixel copy(Pixel _px){
    x = _px.x;
    y = _px.y;
    c = _px.c;
    return this;
  }
  
  PVector location(){
    return new PVector(x,y); 
  }
  
}