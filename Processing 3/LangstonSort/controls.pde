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

    for ( int o = 0; o < orientations; o++) {
      for (int e = 0; e < evaluations; e++) {
        String name = "o"+o+"e"+e;
        buttons[o][e] = cp5.addRadioButton(name+"B")
          .setSize(20, 20)
          .setItemsPerRow(3)
          .setSpacingColumn(20)
          .setSpacingRow(1)
          .setPosition(xPadding, yPadding+(e*25)+(o*110))
          .addItem("L"+o+e, 0)
          .addItem("R"+o+e, 1)
          .addItem("S"+o+e, 2)
          .activate(turn[o][e])
          ;

        toggles[o][e] = cp5.addToggle(name+"T")
          .setLabel("SW"+o+e)
          .setSize(20, 20)
          .setPosition(xPadding+150, yPadding+(e*25)+(o*110))
          .setValue(swap[o][e])
          ;

        println();
      }
    }

    cp5.addSlider("iterationSlider")
     .setPosition(200,yPadding)
     .setRange(1,1000)
     .setSize(300,20)
     .setValue(iterations);
     ;
     
     cp5.addSlider("qtyAntsSlider")
     .setPosition(200,yPadding+(1*25))
     .setRange(1,10000)
     .setSize(300,20)
     .setValue(qtyAnts);
     ;
     
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
      
      cp5.addButton("generate")
      .setLabel("GEN")
      .setSize(20, 20)
      .setPosition(270, yPadding+(3*25))
      ;
      
      cp5.addButton("randomize")
      .setLabel("RND")
      .setSize(20, 20)
      .setPosition(270, yPadding+(4*25))
      ;
      
      cp5.addButton("open")
      .setLabel("O")
      .setSize(20, 20)
      .setPosition(270, yPadding+(5*25))
      ;
      cp5.addButton("save")
      .setLabel("S")
      .setSize(20, 20)
      .setPosition(270, yPadding+(6*25))
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
    randomizeAnts();
    resetBuffer();
  }
  public void generate(){
    randomizeAnts();
    generateNewRules();
  }
  
  public void randomize(){
    randomizeAnts();
  }
  public void open(){
   openImage();
  }
  public void save(){
    saveImage();
  }


  void draw() {
    background(controlsBGColor);
    for ( int o = 0; o < orientations; o++) {
      for (int e = 0; e < evaluations; e++) {
        turn[o][e] = int(buttons[o][e].getValue());
        swap[o][e] = boolean(int(toggles[o][e].getValue()));
      }
    }
    iterations = int(cp5.getValue("iterationSlider"));
    qtyAnts = int(cp5.getValue("qtyAntsSlider"));
  }

  void generateNewRules() {
    generateRules();
    for ( int o = 0; o < orientations; o++) {
      for (int e = 0; e < evaluations; e++) {
        buttons[o][e].activate(turn[o][e]);
        toggles[o][e].setValue(swap[o][e]);
      }
    }
  }
}