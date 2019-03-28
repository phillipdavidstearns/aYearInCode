/*
  Key Bindings:
 o
 O
 1-6
 q
 w
 e
 a
 s
 d
 z
 UPARROW
 DOWNARROW
 LEFTARROW
 RIGHTARROW
 */

boolean shift = false;

void keyPressed() {
  //    println(keyCode);

  switch(keyCode) {
  case 38: //UPARROW
    frame_inc(height/4);
    break;
  case 40: //DOWNARROW
    frame_dec(height/4);
    break;
  case 37: //LEFTARROW
    if (bit_offset>0) bit_offset-=1;
    ;
    break;
  case 39: //RIGHTARROW
    bit_offset+=1;
    ;
    break;
  }

  if (keyCode == SHIFT) shift = true;

  if (shift) {
    switch(keyCode) {
    case 38: //UPARROW
      frame_inc(1);
      break;
    case 40: //DOWNARROW
      frame_dec(1);
      break;
    case 37: //LEFTARROW
      if (bit_offset>0) bit_offset-=1;
      ;
      break;
    case 39: //RIGHTARROW
      bit_offset+=1;
      ;
      break;
    }
  } else {
    switch(keyCode) {
    case 38: //UPARROW
      frame_inc(screen_height-1);
      break;
    case 40: //DOWNARROW
      frame_dec(screen_height-1);
      break;
    case 37: //LEFTARROW
      if (pixel_offset>0) pixel_offset-=1;
      ;
      break;
    case 39: //RIGHTARROW
      pixel_offset+=1;
      ;
      break;
    }
  }

  switch(key) {
  case 'o':
    open_file();
    break;
  case 'O':
    save_file();
    break;
  case '0':
    mode^=0x1;
    if (mode == 0) {
      println("color mode = RGB");
    } else if (mode == 1) {
      println("color more = Greyscale");
    } else {
      println("You broke the matrix.");
    }
    break;
  case '1':
    swap_mode=0;
    println("channel swap mode: "+swap_mode);
    break;
  case '2':
    swap_mode=1;
    println("channel swap mode: "+swap_mode);
    break;
  case '3':
    swap_mode=2;
    println("channel swap mode: "+swap_mode);
    break;
  case '4':
    swap_mode=3;
    println("channel swap mode: "+swap_mode);
    break;
  case '5':
    swap_mode=4;
    println("channel swap mode: "+swap_mode);
    break;
  case '6':
    swap_mode=5;
    println("channel swap mode: "+swap_mode);
    break;
  case 'q':
    red_invert=!red_invert;
    println("red_invert = "+red_invert);
    break;
  case 'w':
    green_invert=!green_invert;
    println("green_invert = "+green_invert);
    break;
  case 'e':
    blue_invert=!blue_invert;
    println("blue_invert = "+blue_invert);
    break;
  case 'a':
    red_invert_pre=!red_invert_pre;
    println("red_invert_pre = "+red_invert_pre);
    break;
  case 's':
    green_invert_pre=!green_invert_pre;
    println("green_invert_pre = "+green_invert_pre);
    break;
  case 'd':
    blue_invert_pre=!blue_invert_pre;
    println("blue_invert_pre = "+blue_invert_pre);
    break;
  case 'z':
    bw_invert=!bw_invert;
    println("invert = "+bw_invert);
    break;
  case 'r': //incrase red channel bit depth
    if (chan1_depth < 8) set_chan1_depth(chan1_depth+1);
    println("Channel 1 Depth = "+chan1_depth);
    break;
  case 'R': //decrease red channel bit depth
    if (chan1_depth > 0) set_chan1_depth(chan1_depth-1);
    println("Channel 1 Depth = "+chan1_depth);
    break;
  case 'g': //increase green channel bit depth
    if (chan2_depth < 8) set_chan2_depth(chan2_depth+1);
    println("Channel 2 Depth = "+chan2_depth);
    break;
  case 'G': //decrease green channel bit depth
    if (chan2_depth > 0) set_chan2_depth(chan2_depth-1);
    println("Channel 2 Depth = "+chan2_depth);
    break;
  case 'b': //increase blue channel bit depth
    if (chan3_depth < 8) set_chan3_depth(chan3_depth+1);
    println("Channel 3 Depth = "+chan3_depth);
    break;
  case 'B': //decrease blue channel bit depth 
    if (chan3_depth > 0) set_chan3_depth(chan3_depth-1);
    println("Channel 3 Depth = "+chan3_depth);
    break;
  case '(': //decrease greyscale bit depth
    if (bw_depth>1) bw_depth--;
    println("Greyscale bit depth = "+bw_depth);
    break;
  case ')': //increase greyscale bit depth 
    if (bw_depth<24) bw_depth++;
    println("Greyscale bit depth = "+bw_depth);
  case '[': //decrease window width by 1 pixel
    setWindowWidth(width-1);
    break;
  case ']': //increase window width by 1 pixel
    setWindowWidth(width+1);
    break;
  case '{': //decrease window height by 1 pixel
    setWindowHeight(height-1);
    break;
  case '}': //increase window height by 1 pixel
    setWindowHeight(height+1);
    break;
  }
}

void keyReleased() {
  if (keyCode == SHIFT) shift = false;
}

public void open_file() {
  selectInput("Select a file to process:", "inputSelection");
}

public void inputSelection(File input) {
  if (input == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + input.getAbsolutePath());
    loadData(input.getAbsolutePath());
  }
}

public void save_file() {
  selectOutput("Select a file to process:", "outputSelection");
}

public void outputSelection(File output) {
  if (output == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + output.getAbsolutePath());
    saveData(output.getAbsolutePath());
  }
}

public void setWindowWidth(int _width) {
  if (int(_width) != 0) {
    setScreenSize(_width, height);
  }
}

public void setWindowHeight(int _height) {
  if (int(_height) != 0) {
    setScreenSize(width, _height);
  }
}

public void set_window_size(int _width, int _height) {
  if (_height != 0 && _width != 0) {
    setScreenSize(_width, _height);
  }
}

public void set_chan1_depth(int _value) {
  chan1_depth = _value;
  pixel_depth = chan1_depth + chan2_depth + chan3_depth;
}

public void set_chan2_depth(int _value) {
  chan2_depth = _value;
  pixel_depth = chan1_depth + chan2_depth + chan3_depth;
}

public void set_chan3_depth(int _value) {
  chan3_depth = _value;
  pixel_depth = chan1_depth + chan2_depth + chan3_depth;
}

public void mode(int value) {
  mode = value;
}

public void depth(int value) {
  bw_depth = value;
  if (mode == 1) {
    pixel_depth = chan1_depth + chan2_depth + chan3_depth;
  }
  if (pixel_depth != 0) {
    pixel_offset=raw_bits.length/pixel_depth;
  }
}

public void swap_mode(int id) {
  if (id!= -1) {
    swap_mode = id;
  }
}

public void quit() {
  exit();
}

public void pixel_offset(int value) {
  pixel_offset = value;
}

public void pixel_inc() {
  if (pixel_offset < raw_bits.length/pixel_depth) pixel_offset+=1;
}

public void pixel_dec() {
  if (pixel_offset > 0) {
    pixel_offset-=1;
  }
}

public void line_inc() {
  if (pixel_offset < raw_bits.length/pixel_depth) pixel_offset+=screen_width*line_multiplier;
}

public void frame_inc(int _lines) {
  if (pixel_offset < raw_bits.length/pixel_depth) pixel_offset+=screen_width*_lines;
}

public void line_dec() {
  if (pixel_offset>0) pixel_offset-=screen_width*line_multiplier;
  if (pixel_offset<0) pixel_offset=0;
}

public void frame_dec(int _lines) {
  if (pixel_offset>0) pixel_offset-=screen_width*_lines;
  if (pixel_offset<0) pixel_offset=0;
}
