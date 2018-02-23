class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;

  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
  }

  public void setup() {
    surface.setLocation(10, 10);
    cp5 = new ControlP5(this);

    int yPadding=10;
    int xPadding=10;



     
    cp5.addToggle("playToggle")
      .setLabel("RUN")
      .setSize(20, 20)
      .setPosition(220, yPadding+(2*25))
      ;
      cp5.addToggle("recordToggle")
      .setLabel("REC")
      .setSize(20, 20)
      .setPosition(220, yPadding+(3*25))
      ;

    cp5.addButton("reset")
      .setLabel("RST")
      .setSize(20, 20)
      .setPosition(270, yPadding+(2*25))
      ;
      
      cp5.addButton("open")
      .setLabel("O")
      .setSize(20, 20)
      .setPosition(270, yPadding+(3*25))
      ;
      cp5.addButton("save")
      .setLabel("S")
      .setSize(20, 20)
      .setPosition(270, yPadding+(4*25))
      ;
  }
  
  public void playToggle(boolean _value){
    play = _value;
  }
  
  public void recordToggle(boolean _value){
    if(recordPath == null) selectRecordPath();
    record = _value;
    frameCounter=0;
  }
  
  public void reset(){
    resetOutput();
  }


  public void open(){
   openImage();
  }
  public void save(){
    saveImage();
  }


  void draw() {
    background(controlsBGColor);
  }

}