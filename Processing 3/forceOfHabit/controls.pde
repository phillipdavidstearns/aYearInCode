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

    int buttonsX=10;
    int buttonsY=10;
    int buttonsW=30;
    int buttonsH=30;
    int buttonsSpacing=50;


     
    cp5.addToggle("playToggle")
      .setLabel("RUN")
      .setSize(buttonsW, buttonsH)
      .setPosition(buttonsX+(0*buttonsSpacing),buttonsY+(0*buttonsSpacing))
      ;
      cp5.addToggle("recordToggle")
      .setLabel("REC")
      .setSize(buttonsW, buttonsH)
      .setPosition(buttonsX+(1*buttonsSpacing),buttonsY+(0*buttonsSpacing))
      ;
      cp5.addButton("open")
      .setLabel("O")
      .setSize(buttonsW, buttonsH)
      .setPosition(buttonsX+(0*buttonsSpacing),buttonsY+(1*buttonsSpacing))
      ;
      cp5.addButton("save")
      .setLabel("S")
      .setSize(buttonsW, buttonsH)
      .setPosition(buttonsX+(1*buttonsSpacing),buttonsY+(1*buttonsSpacing))
      ;
      cp5.addButton("reset")
      .setLabel("RST")
      .setSize(buttonsW, buttonsH)
      .setPosition(buttonsX+(0*buttonsSpacing),buttonsY+(2*buttonsSpacing))
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