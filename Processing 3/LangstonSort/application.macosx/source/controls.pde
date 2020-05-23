public class ControlFrame extends PApplet {

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
    
    //positions of the basic Load, Save, Play, Etc controls
    int buttonX=10;
    int buttonY=10;
    int buttonW=20;
    int buttonH=20;
    int buttonspacing=35;
    
    //iteration and quantity sliders
    int sliderX=10;
    int sliderY=85;
    int sliderW=200;
    int sliderH=20;
    int sliderSpacing=30;
    
    //evaluation mode selector
    int modeRadioX=10;
    int modeRadioY=150;
    int modeRadioW=20;
    int modeRadioH=20;
    int modeRadioSpacing=20;

    //rule radios
    int radioColSpacing = 220;
    int radioX=10;
    int radioY=190;
    int radioW=20;
    int radioH=20;
    int radioSpacing=25;

    //swap toggles
    int toggleW=20;
    int toggleH=20;
    int toggleX=160;
    int toggleY=radioY;
    int toggleSpacing=25;

    for ( int o = 0; o < orientations; o++) {
      for (int e = 0; e < evaluations; e++) {
        int col=0;
        if (o > 3) col=1;
        String name = "o"+o+"e"+e;
        radios[o][e] = cp5.addRadioButton(name+"R")
          .setSize(radioW, radioH)
          .setItemsPerRow(3)
          .setSpacingColumn(radioSpacing)
          .setSpacingRow(radioSpacing)
          .setPosition(radioX+(col*radioColSpacing), radioY+(e*radioSpacing)+((o%4)*2*(radioH+radioSpacing)))
          .addItem("CCW"+o+e, 0)
          .addItem("CW"+o+e, 1)
          .addItem("STR"+o+e, 2)
          .activate(turn[o][e])
          ;
        if (e<2) {
          toggles[o][e] = cp5.addToggle(name+"T")
            .setLabel("SW"+o+e)
            .setSize(toggleW, toggleH)
            .setPosition(toggleX+(col*radioColSpacing), toggleY+(e*toggleSpacing)+((o%4)*2*(radioH+radioSpacing)))
            .setValue(swap[o][e])
            ;
        }
      }
    }

    cp5.addRadioButton("evalModeRadio")
      .setLabel("evalMode")
      .setSize(modeRadioW, modeRadioH)
      .setItemsPerRow(8)
      .setSpacingColumn(modeRadioSpacing)
      .setSpacingRow(modeRadioSpacing)
      .setPosition(modeRadioX, modeRadioY+(0*modeRadioSpacing)+(0*2*(modeRadioH+modeRadioSpacing)))
      .addItem("RGB", 0)
      .addItem("HUE", 1)
      .addItem("SAT", 2)
      .addItem("VAL", 3)
      .addItem("RED", 4)
      .addItem("GRN", 5)
      .addItem("BLU", 6)
      .activate(0)
      ;

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
      .setPosition(buttonX+(0*buttonspacing), buttonY+(0*buttonspacing))
      ;
    cp5.addButton("save")
      .setLabel("S")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(0*buttonspacing), buttonY+(1*buttonspacing))
      ;

    cp5.addToggle("playToggle")
      .setLabel("RUN")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(1*buttonspacing), buttonY+(0*buttonspacing))
      ;
    cp5.addToggle("recordToggle")
      .setLabel("REC")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(1*buttonspacing), buttonY+(1*buttonspacing))
      ;

    cp5.addButton("reset")
      .setLabel("RST")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(2*buttonspacing), buttonY+(0*buttonspacing))
      ;

    cp5.addButton("generate")
      .setLabel("GEN")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(2*buttonspacing), buttonY+(1*buttonspacing))
      ;

    cp5.addButton("randomize")
      .setLabel("RND")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(3*buttonspacing), buttonY+(0*buttonspacing))
      ;
    cp5.addToggle("antVisibleToggle")
      .setLabel("VIS")
      .setSize(buttonW, buttonH)
      .setPosition(buttonX+(3*buttonspacing), buttonY+(1*buttonspacing))
      ;
    //cp5.addToggle("simpleToggle")
    //  .setLabel("4/8")
    //  .setSize(buttonW, buttonH)
    //  .setPosition(buttonX+(4*radiospacing), buttonY+(0*radiospacing))
    //  ;
  }


  public void evalModeRadio(int _mode) {
    switch(_mode) {
    case 0: 
      evalMode = "RGB"; 
      break;
    case 1: 
      evalMode = "HUE"; 
      break;
    case 2: 
      evalMode = "SAT"; 
      break;
    case 3: 
      evalMode = "VAL"; 
      break;
    case 4: 
      evalMode = "RED"; 
      break;
    case 5: 
      evalMode = "GRN"; 
      break;
    case 6: 
      evalMode = "BLU"; 
      break;
    }
  }

  public void open() {
    cp5.getController("playToggle").setValue(0);
    openImage();
  }
  public void save() {
    cp5.getController("playToggle").setValue(0);
    saveImage();
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
      resetOutput();
    }
  }
  public void generate() {
    randomizeAnts();
    generateNewRules();
  }


  public void randomize() {
    randomizeAnts();
  }

  public void antVisibleToggle(boolean _value) {
    visible = _value;
  }

  //To do: have a toggle dynamically switch between simple and complex mode, 4 and 8 directions, respectively.
  //public void simpleToggle(int _val) {
  //pseudocode:
  //destroyThisControllerFrame()
  //reinitializeRules()
  //createNewControllerFrame()
  //}

  void draw() {
    background(controlsBGColor);
    for ( int o = 0; o < orientations; o++) {
      for (int e = 0; e < evaluations; e++) {
        turn[o][e] = int(radios[o][e].getValue());
        if (e<2) swap[o][e] = boolean(int(toggles[o][e].getValue()));
      }
    }
    iterations = int(cp5.getValue("iterationSlider"));
    qtyAnts = int(cp5.getValue("qtyAntsSlider"));
  }

  void generateNewRules() {
    generateRules();
    //update radios and radios
    for ( int o = 0; o < orientations; o++) {
      for (int e = 0; e < evaluations; e++) {
        radios[o][e].activate(turn[o][e]);
        if (e<2) toggles[o][e].setValue(swap[o][e]);
      }
    }
  }
  
  //key bindings
  void keyPressed() {
    switch(key) {
    case 'o': //open
      openImage();
      break;
    case 's': //save
      saveImage();
      break;
    case 'r': //randomize ant locations
      if (ants != null) randomize();
      break;
    case 'g': //generate random rule set
      controls.generateNewRules();
      break;
    case 'p':
      cp5.getController("playToggle").setValue(int(!play));
      break;
    case 'f': 
      reset();
      break;
    case 'v':
      cp5.getController("antVisibleToggle").setValue(int(!visible));
      break;
    }
  }
}
