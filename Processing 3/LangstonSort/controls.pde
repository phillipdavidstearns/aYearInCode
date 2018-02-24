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


    int radioX=10;
    int radioY=140;
    int radioW=20;
    int radioH=20;
    int radioSpacing=30;

    int toggleW=20;
    int toggleH=20;
    int toggleX=180;
    int toggleY=radioY;
    int toggleSpacing=30;

    int sliderX=10;
    int sliderY=10;
    int sliderW=200;
    int sliderH=20;
    int sliderSpacing=30;

    int buttonX=10;
    int buttonY=70;
    int buttonW=20;
    int buttonH=20;
    int buttonSpacing=30;


    for ( int o = 0; o < orientations; o++) {
      for (int e = 0; e < evaluations; e++) {
        String name = "o"+o+"e"+e;
        buttons[o][e] = cp5.addRadioButton(name+"B")
          .setSize(radioW, radioH)
          .setItemsPerRow(3)
          .setSpacingColumn(radioSpacing)
          .setSpacingRow(radioSpacing)
          .setPosition(radioX, radioY+(e*radioSpacing)+(o*2*(radioH+radioSpacing)))
          .addItem("CCW"+o+e, 0)
          .addItem("CW"+o+e, 1)
          .addItem("STR"+o+e, 2)
          .activate(turn[o][e])
          ;
        if (e<2) {
          toggles[o][e] = cp5.addToggle(name+"T")
            .setLabel("SW"+o+e)
            .setSize(toggleW, toggleH)
            .setPosition(toggleX, toggleY+(e*toggleSpacing)+(o*2*(radioH+radioSpacing)))
            .setValue(swap[o][e])
            ;
        }
        println();
      }
    }

    cp5.addSlider("iterationSlider")
      .setLabel("Iterations")
      .setPosition(sliderX, sliderY+(0*sliderSpacing))
      .setRange(1, maxIterations)
      .setSize(sliderW, sliderH)
      .setValue(iterations);
    ;

    cp5.addSlider("qtyAntsSlider")
      .setLabel("# of Ants")
      .setPosition(sliderX, sliderY+(1*sliderSpacing))
      .setRange(1, maxAnts)
      .setSize(sliderW, sliderH)
      .setValue(qtyAnts);
    ;


    //play controls
      
    cp5.addButton("open")
      .setLabel("O")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(0*buttonSpacing), buttonY+(0*buttonSpacing))
      ;
    cp5.addButton("save")
      .setLabel("S")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(0*buttonSpacing), buttonY+(1*buttonSpacing))
      ;
      
    cp5.addToggle("playToggle")
      .setLabel("RUN")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(1*buttonSpacing), buttonY+(0*buttonSpacing))
      ;
    cp5.addToggle("recordToggle")
      .setLabel("REC")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(1*buttonSpacing), buttonY+(1*buttonSpacing))
      ;

    cp5.addButton("reset")
      .setLabel("RST")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(2*buttonSpacing), buttonY+(0*buttonSpacing))
      ;

    cp5.addButton("generate")
      .setLabel("GEN")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(2*buttonSpacing), buttonY+(1*buttonSpacing))
      ;

    cp5.addButton("randomize")
      .setLabel("RND")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(3*buttonSpacing), buttonY+(0*buttonSpacing))
      ;


  }

  public void playToggle(boolean _value) {
    play = _value;
  }

  public void recordToggle(boolean _value) {
    cp5.getController("playToggle").setValue(0);
    if (_value) selectRecordPath();
    record = _value;
    frameCounter=0;
  }
  public void reset() {
    if (output!=null) {
      randomizeAnts();
      resetoutput();
    }
  }
  public void generate() {
    randomizeAnts();
    generateNewRules();
  }

  public void randomize() {
    randomizeAnts();
  }
  public void open() {
    cp5.getController("playToggle").setValue(0);
    openImage();
  }
  public void save() {
    cp5.getController("playToggle").setValue(0);
    saveImage();
  }


  void draw() {
    background(controlsBGColor);
    for ( int o = 0; o < orientations; o++) {
      for (int e = 0; e < evaluations; e++) {
        turn[o][e] = int(buttons[o][e].getValue());
        if (e<2)swap[o][e] = boolean(int(toggles[o][e].getValue()));
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
        if (e<2)toggles[o][e].setValue(swap[o][e]);
      }
    }
  }
}