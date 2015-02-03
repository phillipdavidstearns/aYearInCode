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
    frameRate(25);
    cp5 = new ControlP5(this);

// controls for skipping bits 

    cp5.addSlider("bit_offset")
      .plugTo(parent,"bit_offset")
      .setRange(0, 24)
      .setSize(100, 20)
      .setPosition(10,110)
      .setNumberOfTickMarks(25)
      ;
     
// controls for skipping pixels     
   cp5.addSlider("pixel_offset")
     .plugTo(parent,"pixel_offset")
     .setPosition(10, 140)
     .setRange(0, raw_bits.length/pixel_depth)
     .setSize(100, 20)
     ;
      
    cp5.addBang("pixel_inc")
     .setPosition(175, 140)
     .setSize(20, 20)
     .setLabel("px+")
     ;
     
   cp5.addBang("pixel_dec")
     .setPosition(205, 140)
     .setSize(20, 20)
     .setLabel("px-")
     ;
     
   cp5.addBang("line_inc")
     .setPosition(235, 140)
     .setSize(20, 20)
     .setLabel("ln+")
     ;
     
   cp5.addBang("line_dec")
     .setPosition(265, 140)
     .setSize(20, 20)
     .setLabel("ln-")
     ;
       
// exits program       
    cp5.addBang("quit")
     .setPosition(400, 130)
     .setSize(20, 20)
     .setLabel("EXIT")
     ;

  cp5.addRadioButton("swap_mode")
         .setPosition(10,10)
         .setSize(20,20)
         .setItemsPerRow(2)
         .setSpacingColumn(30)
         .addItem("RGB", 0)
         .addItem("GBR", 1)
         .addItem("BRG", 2)
         .addItem("BGR", 3)
         .addItem("GRB", 4)
         .addItem("RBG", 5)
         ;

     

// controls for color channel depth

  cp5.addSlider("chan1_depth")
    .setPosition(240,10)
    .setSize(50,20)
    .setRange(0,8)
    .setValue(8)
    .setNumberOfTickMarks(9)
    ;
     
  cp5.addSlider("chan2_depth")
    .setPosition(240,40)
    .setSize(50, 20)
    .setRange(0,8)
    .setValue(8)
    .setNumberOfTickMarks(9)
    ;
     
  cp5.addSlider("chan3_depth")
    .setPosition(240,70)
    .setSize(50, 20)
    .setRange(0,8)
    .setValue(8)
    .setNumberOfTickMarks(9)
    ; 

  cp5.addToggle("R_INV")
     .setPosition(10+(0*30), 70)
     .setSize(20, 20)
     .plugTo(parent,"red_invert")
     ;
   cp5.addToggle("G_INV")
     .setPosition(10+(1*30), 70)
     .setSize(20, 20)
     .plugTo(parent,"green_invert")
     ;
   cp5.addToggle("B_INV")
     .setPosition(10+(2*30), 70)
     .setSize(20, 20)
     .plugTo(parent,"blue_invert")
     ;
     
  }

  public void draw() {
      background(0);
  }

  public void chan1_depth(int value){
    chan1_depth = value;
    pixel_depth = chan1_depth + chan2_depth + chan3_depth;
  }
  
  public void chan2_depth(int value){
    chan2_depth = value;
    pixel_depth = chan1_depth + chan2_depth + chan3_depth;
  }
  
  public void chan3_depth(int value){
    chan3_depth = value;
    pixel_depth = chan1_depth + chan2_depth + chan3_depth;
  }
  
  public void swap_mode(int id) {
   if(id!= -1){
      swap_mode = id;
    }
   
  }
  
  public void quit(){
    exit();
  }
  
  public void pixel_inc(){
    if(pixel_offset < raw_bits.length)  pixel_offset++;
    cp5.getController("pixel_offset").setValue(pixel_offset);
  }
  
  public void pixel_dec(){
    if(pixel_offset > 0)  pixel_offset--;
    cp5.getController("pixel_offset").setValue(pixel_offset);
  }
  
  public void line_inc(){
    if(pixel_offset+screen_width < raw_bits.length)  pixel_offset+=screen_width;
    cp5.getController("pixel_offset").setValue(pixel_offset);
  }
  
  public void line_dec(){
    if(pixel_offset-screen_width > 0)  pixel_offset-=screen_width;
    cp5.getController("pixel_offset").setValue(pixel_offset);
  }
  
  private ControlFrame() {
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
