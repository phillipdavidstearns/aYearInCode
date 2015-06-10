ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(true);
  f.setVisible(true);
  return p;
}

// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded
public class ControlFrame extends PApplet {

  int w, h;

  public void setup() {
    size(w, h);
    frameRate(30);

    cp5 = new ControlP5(this);

    // controls for skipping bits 
    cp5.addSlider("bit_offset")
      .plugTo(parent, "bit_offset")
        .setRange(0, 24)
          .setSize(100, 20)
            .setPosition(10, 160)
              .setNumberOfTickMarks(25)
                ;

    // controls for skipping pixels     
    cp5.addSlider("pixel_offset")
      .setPosition(10, 190)
        .setRange(0, raw_bits.length)
          .setSize(100, 20)
            ;
    //step forward a pixel  
    cp5.addBang("pixel_inc")
      .setPosition(175, 140)
        .setSize(20, 20)
          .setLabel("px+")
            ;
    //jump back a pixel
    cp5.addBang("pixel_dec")
      .setPosition(205, 140)
        .setSize(20, 20)
          .setLabel("px-")
            ;
    //step forward a line  
    cp5.addBang("line_inc")
      .setPosition(235, 140)
        .setSize(20, 20)
          .setLabel("ln+")
            ;
    //jump back a line 
    cp5.addBang("line_dec")
      .setPosition(265, 140)
        .setSize(20, 20)
          .setLabel("ln-")
            ;
    //specify how many lines to skip  
    cp5.addNumberbox("line_multiplier")
      .plugTo(parent, "line_multiplier")
        .setPosition(295, 140)
          .setSize(20, 20)
            .setRange(-100, 100)
              .setValue(1)
                .setDirection(0)
                  .setLabel("ln*")
                    ;

    // exits program       
    cp5.addBang("quit")
      .setPosition(470, 140)
        .setSize(20, 20)
          .setLabel("EXIT")
            ;

    cp5.addRadioButton("swap_mode")
      .setPosition(10, 10)
        .setSize(20, 20)
          .setItemsPerRow(2)
            .setSpacingColumn(30)
              .setSpacingRow(1)
                .addItem("RGB", 0)
                  .addItem("GBR", 1)
                    .addItem("BRG", 2)
                      .addItem("BGR", 3)
                        .addItem("GRB", 4)
                          .addItem("RBG", 5)
                            ;

    // controls for color channel depth
    cp5.addSlider("chan1_depth")
      .setPosition(120, 10)
        .setSize(50, 20)
          .setRange(0, 8)
            .setValue(1)
              .setNumberOfTickMarks(9)
                ;

    cp5.addSlider("chan2_depth")
      .setPosition(120, 45)
        .setSize(50, 20)
          .setRange(0, 8)
            .setValue(1)
              .setNumberOfTickMarks(9)
                ;

    cp5.addSlider("chan3_depth")
      .setPosition(120, 80)
        .setSize(50, 20)
          .setRange(0, 8)
            .setValue(1)
              .setNumberOfTickMarks(9)
                ; 
                
     cp5.addSlider("depth")
      .setPosition(400, 45)
        .setSize(50, 20)
          .setRange(0, 8)
            .setValue(1)
              .setNumberOfTickMarks(9)
                ;
                
    cp5.addToggle("mode")
      .setPosition(400, 10)
        .setSize(20, 20)
           .setLabel("GRAY")
              ;

    cp5.addToggle("R_INV_PRE")
      .setPosition(10+(0*30), 75)
        .setSize(20, 20)
          .plugTo(parent, "red_invert_pre")
            .setLabel("PRE")
              ;

    cp5.addToggle("G_INV_PRE")
      .setPosition(10+(1*30), 75)
        .setSize(20, 20)
          .plugTo(parent, "green_invert_pre")
            .setLabel("PRE")
              ;

    cp5.addToggle("B_INV_PRE")
      .setPosition(10+(2*30), 75)
        .setSize(20, 20)
          .plugTo(parent, "blue_invert_pre")
            .setLabel("PRE")
              ;

    cp5.addToggle("R_INV")
      .setPosition(10+(0*30), 120)
        .setSize(20, 20)
          .plugTo(parent, "red_invert")
            .setLabel("!R")
              ;

    cp5.addToggle("G_INV")
      .setPosition(10+(1*30), 120)
        .setSize(20, 20)
          .plugTo(parent, "green_invert")
            .setLabel("!G")
              ;

    cp5.addToggle("B_INV")
      .setPosition(10+(2*30), 120)
        .setSize(20, 20)
          .plugTo(parent, "blue_invert")
            .setLabel("!B")
              ;
              
     cp5.addToggle("INV")
      .setPosition(430, 10)
        .setSize(20, 20)
          .plugTo(parent, "invert")
            .setLabel("!")
              ;

    //controls for changing the screen size
    cp5.addNumberbox("window_width")
      .setPosition(240, 10)
        .setSize(50, 20)
          .setMin(1)
            .setValue(384)
              .setDirection(Controller.HORIZONTAL)
                .setLabel("width")
                  ; 
    cp5.addNumberbox("window_height")
      .setPosition(240, 45)
        .setSize(50, 20)
          .setMin(1)
            .setValue(512)
              .setDirection(Controller.HORIZONTAL)
                .setLabel("height")
                  ; 

    cp5.addTextfield("set_window_width")
      .setPosition(300, 10)
        .setSize(50, 20)
          .setValue(384)
            .setLabel("enter width")
              ; 
    cp5.addTextfield("set_window_height")
      .setPosition(300, 45)
        .setSize(50, 20)
          .setValue(512)
            .setLabel("enter height")
              ;

    cp5.addButton("open_file")
      .setPosition(350, 140)
        .setSize(40, 20)
          .setLabel("open")
            ;

    cp5.addButton("save_file")
      .setPosition(400, 140)
        .setSize(40, 20)
          .setLabel("save")
            ;
  }

  public void draw() {
    background(25);
  }
  
  void keyPressed(){
//    println(keyCode);
    if(keyCode == 38){
      line_inc();
    } else if(keyCode == 40){
      line_dec();
    }
  }

  public void open_file() {
    selectInput("Select a file to process:", "inputSelection");
  }
  
  void inputSelection(File input) {
    if (input == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      println("User selected " + input.getAbsolutePath());
      loadData(input.getAbsolutePath());
      cp5.get(Slider.class,"pixel_offset").setRange(0, raw_bits.length/pixel_depth);
    }
  }


  public void save_file() {
    selectOutput("Select a file to process:", "outputSelection");
  }
  
  void outputSelection(File output) {
    if (output == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      println("User selected " + output.getAbsolutePath());
      saveData(output.getAbsolutePath());
    }
  }

  

  public void set_window_width(String theValue) {
    if (int(theValue) != 0) {
      cp5.get(Numberbox.class, "window_width").setValue(int(theValue));
    }
  }

  public void set_window_height(String theValue) {
    if (int(theValue) != 0) {
      cp5.get(Numberbox.class, "window_height").setValue(int(theValue));
    }
  }

  public void window_height(int value) {
    screen_height = value;
    setScreenSize(screen_width, screen_height);
  }
  public void window_width(int value) {
    screen_width = value;
    setScreenSize(screen_width, screen_height);
  }

  public void chan1_depth(int value) {
    chan1_depth = value;
    pixel_depth = chan1_depth + chan2_depth + chan3_depth;
    if(pixel_depth != 0){
      cp5.get(Slider.class,"pixel_offset").setRange(0, raw_bits.length/pixel_depth);
    }
  }

  public void chan2_depth(int value) {
    chan2_depth = value;
    pixel_depth = chan1_depth + chan2_depth + chan3_depth;
    if(pixel_depth != 0){
      cp5.get(Slider.class,"pixel_offset").setRange(0, raw_bits.length/pixel_depth);
    }
  }

  public void chan3_depth(int value) {
    chan3_depth = value;
    pixel_depth = chan1_depth + chan2_depth + chan3_depth;
    if(pixel_depth != 0){
      cp5.get(Slider.class,"pixel_offset").setRange(0, raw_bits.length/pixel_depth);
    }
  }
  
  public void mode(int value){
    mode = value;
  }
  
  public void depth(int value) {
    depth = value;
    if(mode == 1){
      pixel_depth = chan1_depth + chan2_depth + chan3_depth;
    }
    if(pixel_depth != 0){
      cp5.get(Slider.class,"pixel_offset").setRange(0, raw_bits.length/pixel_depth);
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
    cp5.getController("pixel_offset").setValue(cp5.getController("pixel_offset").getValue()+1);
  }

  public void pixel_dec() {
    if (pixel_offset > 0) {
      cp5.getController("pixel_offset").setValue(cp5.getController("pixel_offset").getValue()-1);
    }
  }
  
  public void line_inc() {
    cp5.getController("pixel_offset").setValue(cp5.getController("pixel_offset").getValue()+(screen_width*line_multiplier));
  }

  public void line_dec() {
    if (pixel_offset-(screen_width*line_multiplier) >= 0) {
      cp5.getController("pixel_offset").setValue(cp5.getController("pixel_offset").getValue()-(screen_width*line_multiplier));
    }
  }

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }

  public ControlP5 control() {
    return cp5;
  }

  ControlP5 cp5;
  Object parent;
}

