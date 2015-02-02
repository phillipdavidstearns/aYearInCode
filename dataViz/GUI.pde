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
  int GUI = 0;
  String names[]={"RGB" , "GBR" , "BRG" , "BGR" , "GRB" , "RBG"};
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);

// controls for skipping bits    
    cp5.addSlider("bit_offset")
      .plugTo(parent,"bit_offset")
      .setRange(0, 24)
      .setSize(100, 20)
      .setPosition(10,10)
      ;
      
    cp5.addBang("bit_inc")
     .setPosition(175, 10)
     .setSize(20, 20)
     .setLabel("Inc")
     ;
     
   cp5.addBang("bit_dec")
     .setPosition(205, 10)
     .setSize(20, 20)
     .setLabel("Dec")
     ;
     
// controls for skipping pixels     
   cp5.addSlider("pixel_offset")
     .plugTo(parent,"pixel_offset")
     .setPosition(10, 45)
     .setRange(0, raw_bits.length/pixel_depth)
     .setSize(100, 20)
     ;
      
    cp5.addBang("pixel_inc")
     .setPosition(175, 45)
     .setSize(20, 20)
     .setLabel("Inc")
     ;
     
   cp5.addBang("pixel_dec")
     .setPosition(205, 45)
     .setSize(20, 20)
     .setLabel("Dec")
     ;
       
// exits program       
    cp5.addBang("quit")
     .setPosition(250, 120)
     .setSize(20, 20)
     .setLabel("EXIT")
     ;
     
// controls for color channel swap mode
//makes a row of buttons
for (int i=0;i<6;i++) { 
    cp5.addBang(names[i])
       .setPosition(10+i*30, 80)
       .setSize(20, 20)
       .setId(i)
       ;
}

     

// controls for color channel depth
//number boxes go here


    cp5.addToggle("R_INV")
       .setPosition(10+(0*30), 120)
       .setSize(20, 20)
       .plugTo(parent,"red_invert")
       ;
     cp5.addToggle("G_INV")
       .setPosition(10+(1*30), 120)
       .setSize(20, 20)
       .plugTo(parent,"green_invert")
       ;
     cp5.addToggle("B_INV")
       .setPosition(10+(2*30), 120)
       .setSize(20, 20)
       .plugTo(parent,"blue_invert")
       ;
//     cp5.addToggle("INV_ALL")
//       .setPosition(10+(3*30), 120)
//       .setSize(20, 20)
//       ;

    
  }

  public void draw() {
      background(GUI);
  }
  
//haven't figured out how to get this to work...  
//  public void INV_ALL(boolean invert){
//    cp5.getController("R_INV").setValue(invert);
//    cp5.getController("G_INV").setValue(invert);
//    cp5.getController("B_INV").setValue(invert);
//  }
  
  public void controlEvent(ControlEvent theEvent) {
    /* events triggered by controllers are automatically forwarded to 
       the controlEvent method. by checking the id of a controller one can distinguish
       which of the controllers has been changed.
    */
    println("got a control event from controller with id "+theEvent.getController().getId());
    if(theEvent.getController().getId() != -1){
      swap_mode = theEvent.getController().getId();
    }
   
  }

  
  public void quit(){
    exit();
  }
  
  public void bit_inc(){
    if(bit_offset < 24)  bit_offset++;
    cp5.getController("bit_offset").setValue(bit_offset);
  }
  
  public void bit_dec(){
    if(bit_offset > 0)  bit_offset--;
    cp5.getController("bit_offset").setValue(bit_offset);
  }
  
  public void pixel_inc(){
    if(pixel_offset < raw_bits.length)  pixel_offset++;
    cp5.getController("pixel_offset").setValue(pixel_offset);
  }
  
  public void pixel_dec(){
    if(pixel_offset > 0)  pixel_offset--;
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
