public class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;
  
  int playbackControlsX = 200;
  int playbackControlsY = 50;
  int toggleW = 30;
  int toggleH = 30;
  int toggleSpacing = 20;

  int buttonW = 30;
  int buttonH = 30;
  int buttonSpacing = 20;

  int neighborToggleX=10;
  int neighborToggleY=10;
  int neighborToggleSpacing = 20;
  int neighborToggleW=30;
  int neighborToggleH=30;

  int radiosX = 10;
  int radiosY = 180;
  int radiosW = 30;
  int radiosH = 30;
  int radiosSpacing=20;

  int thresholdSlidersX = 200;
  int thresholdSlidersY = 10;
  int thresholdSlidersW = 255;
  int thresholdSlidersH = 30;
  int thresholdSlidersSpacingX = 30;
  int thresholdSlidersSpacingY = 20;

  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w = _w;
    h = _h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
  }

  public void setup() {
    surface.setLocation(0, 400);
    cp5 = new ControlP5(this);

    //toggles to enable/disable checking of specific neighbor cells.
    for (int x = 0; x < 3; x++) {
      for (int y = 0; y < 3; y++) {
        int id = y * 3 + x;
        if (id !=4) {
          neighborToggles[x][y] = cp5.addToggle("neighborToggle_"+x+"_"+y)
            .setLabel(nf(id))
            .setPosition(neighborToggleX + ((neighborToggleSpacing+neighborToggleW)*x), neighborToggleY + ((neighborToggleSpacing+neighborToggleH)*y))
            .setSize(neighborToggleW, neighborToggleH);
          ;
        }
      }
    }

    //radio controls for the compare and threshold logic 
    cp5.addRadio("compare")
      .setSize(radiosW, radiosH)
      .setPosition(radiosX, radiosY)
      .setItemsPerRow(14)
      .setSpacingColumn(30)
      .addItem("RGB<", 0)
      .addItem("RGB>", 1)
      .addItem("HUE<", 2)
      .addItem("HUE>", 3)
      .addItem("SAT<", 4)
      .addItem("SAT>", 5)
      .addItem("VAL<", 6)
      .addItem("VAL>", 7)
      .addItem("RED<", 8)
      .addItem("RED>", 9)
      .addItem("GRN<", 10)
      .addItem("GRN>", 11)
      .addItem("BLU<", 12)
      .addItem("BLU>", 13)
      ;

    cp5.addRadio("threshold").setSize(radiosW, radiosH)
      .setPosition(radiosX, radiosY+radiosH+radiosSpacing)
      .setItemsPerRow(14)
      .setSpacingColumn(30)
      .addItem("RGB", 0)
      .addItem("!RGB", 1)
      .addItem("HUE", 2)
      .addItem("!HUE", 3)
      .addItem("SAT", 4)
      .addItem("!SAT", 5)
      .addItem("VAL", 6)
      .addItem("!VAL", 7)
      .addItem("RED", 8)
      .addItem("!RED", 9)
      .addItem("GRN", 10)
      .addItem("!GRN", 11)
      .addItem("BLU", 12)
      .addItem("!BLU", 13)
      ;

    //togles and buttons for the penultimate row
    cp5.addToggle("playToggle")
      .setLabel("PLAY")
      .setSize(toggleW, toggleH)
      .setPosition(playbackControlsX+(toggleSpacing+toggleW)*0, playbackControlsY+(buttonSpacing+buttonH)*0)
      .setValue(play)
      ;
    cp5.addToggle("recordToggle")
      .setLabel("REC")
      .setSize(toggleW, toggleH)
      .setPosition(playbackControlsX+(toggleSpacing+toggleW)*1, playbackControlsY+(buttonSpacing+buttonH)*0)
      .setValue(record)
      ;
    cp5.addButton("openButton")
      .setLabel("OPEN")
      .setSize(buttonW, buttonH)
      .setPosition(playbackControlsX+(buttonSpacing+buttonW)*2, playbackControlsY+(buttonSpacing+buttonH)*0)
      ;
    cp5.addButton("saveButton")
      .setLabel("SAVE")
      .setSize(buttonW, buttonH)
      .setPosition(playbackControlsX+(buttonSpacing+buttonW)*3, playbackControlsY+(buttonSpacing+buttonH)*0)
      ;

    //togles and buttons for the bottom row
    cp5.addToggle("wrapToggle")
      .setLabel("WRAP")
      .setSize(toggleW, toggleH)
      .setPosition(playbackControlsX+(toggleSpacing+toggleW)*0, playbackControlsY+(toggleSpacing+toggleH)*1)
      .setValue(wrap)
      ;
    cp5.addButton("resetButton")
      .setLabel("RESET")
      .setSize(buttonW, buttonH)
      .setPosition(playbackControlsX+(buttonSpacing+buttonW)*1, playbackControlsY+(buttonSpacing+buttonH)*1)
      ;
    cp5.addToggle("visibleToggle")
      .setLabel("VIEW")
      .setSize(buttonW, buttonH)
      .setPosition(playbackControlsX+(buttonSpacing+buttonW)*2, playbackControlsY+(buttonSpacing+buttonH)*1)
      ;

    //Sliders for the threshold Min + Max  
    cp5.addSlider("minSlider")
      .setLabel("MIN")
      .setPosition(thresholdSlidersX+(thresholdSlidersW+thresholdSlidersSpacingX)*0, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacingY)*0)
      .setSize(thresholdSlidersW, thresholdSlidersH)
      .setMin(0)
      .setMax(255)
      .setValue(red(min))
      ;

    //    cp5.addSlider("gMin")
    //      .setPosition(thresholdSlidersX+(thresholdSlidersW+thresholdSlidersSpacingX)*0, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacingY)*1)
    //      .setSize(thresholdSlidersW, thresholdSlidersH)
    //      .setMin(0)
    //      .setMax(255)
    //      .setValue(green(min))
    //      ;

    //    cp5.addSlider("bMin")
    //      .setPosition(thresholdSlidersX+(thresholdSlidersW+thresholdSlidersSpacingX)*0, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacingY)*2)
    //      .setSize(thresholdSlidersW, thresholdSlidersH)
    //      .setMin(0)
    //      .setMax(255)
    //      .setValue(blue(min))
    //      ;

    cp5.addSlider("maxSlider")
      .setLabel("MAX")
      .setPosition(thresholdSlidersX+(thresholdSlidersW+thresholdSlidersSpacingX)*1, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacingY)*0)
      .setSize(thresholdSlidersW, thresholdSlidersH)
      .setMin(0)
      .setMax(255)
      .setValue(red(max))
      ;

    //cp5.addSlider("gMax")
    //  .setPosition(thresholdSlidersX+(thresholdSlidersW+thresholdSlidersSpacingX)*1, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacingY)*1)
    //  .setSize(thresholdSlidersW, thresholdSlidersH)
    //  .setMin(0)
    //  .setMax(255)
    //  .setValue(green(max))
    //  ;

    //cp5.addSlider("bMax")
    //  .setPosition(thresholdSlidersX+(thresholdSlidersW+thresholdSlidersSpacingX)*1, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacingY)*2)
    //  .setSize(thresholdSlidersW, thresholdSlidersH)
    //  .setMin(0)
    //  .setMax(255)
    //  .setValue(blue(max))
    //  ;

    cp5.addSlider("iterationSlider")
      .setLabel("Iterations")
      .setPosition(thresholdSlidersX+(thresholdSlidersW+thresholdSlidersSpacingX)*1, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacingY)*1)
      .setSize(thresholdSlidersW, thresholdSlidersH)
      .setMin(1)
      .setMax(256*2-1)
      .setValue(blue(max))
      ;
  }

  void draw() {
    background(0);
    min = color(cp5.getValue("minSlider"));
    max = color(cp5.getValue("maxSlider"));
    iterations = int (cp5.getValue("iterationSlider"));
    textAlign(LEFT, BOTTOM);
    text("Iterations: "+nf(iterationCount), 800, 30);
  }


  //GUI callbacks
  public void pixelCheck(boolean _val) {
    pixelCheck = _val;
    println("pixelCheck: "+pixelCheck);
  }

  public void playToggle(boolean _val) {
    play = _val;
  }

  public void recordToggle(boolean _val) {
    record = _val;
  }

  public void openButton() {
    openImage();
  }

  public void saveButton() {
    saveImage();
  }

  public void wrapToggle(boolean _val) {
    wrap = _val;
  }

  public void resetButton() {
    
    resetOutput();
  }

  public void visibleToggle(boolean _val) {
    visible = _val;
  }

  public void compare(int _mode) {
    switch(int(_mode)) {
    case 0:
      compareMode = "RGB<";
      break;
    case 1:
      compareMode = "RGB>";
      break;
    case 2:
      compareMode = "HUE<";
      break;
    case 3:
      compareMode = "HUE>";
      break;
    case 4:
      compareMode = "SAT<";
      break;
    case 5:
      compareMode = "SAT>";
      break;
    case 6:
      compareMode = "VAL<";
      break;
    case 7:
      compareMode = "VAL>";
      break;
    case 8:
      compareMode = "RED<";
      break;
    case 9:
      compareMode = "RED>";
      break;
    case 10:
      compareMode = "GRN<";
      break;
    case 11:
      compareMode = "GRN>";
      break;
    case 12:
      compareMode = "BLU<";
      break;
    case 13:
      compareMode = "BLU>";
      break;
    }
    println("compareMode: "+compareMode);
  }

  public void threshold(int _mode) {
    switch(int(_mode)) {
    case 0:
      thresholdMode = "<RGB>";
      break;
    case 1:
      thresholdMode = ">RGB<";
      break;
    case 2:
      thresholdMode = "<HUE>";
      break;
    case 3:
      thresholdMode = ">HUE<";
      break;
    case 4:
      thresholdMode = "<SAT>";
      break;
    case 5:
      thresholdMode = ">SAT<";
      break;
    case 6:
      thresholdMode = "<VAL>";
      break;
    case 7:
      thresholdMode = ">VAL<";
      break;
    case 8:
      thresholdMode = "<RED>";
      break;
    case 9:
      thresholdMode = ">RED<";
      break;
    case 10:
      thresholdMode = "<GRN>";
      break;
    case 11:
      thresholdMode = ">GRN<";
      break;
    case 12:
      thresholdMode = "<BLU>";
      break;
    case 13:
      thresholdMode = ">BLU<";
      break;
    }
    println("thresholdMode: "+ thresholdMode);
  }

  void keyPressed() {
    switch(key) {

    case '1':
      neighborToggles[0][0].setValue(!neighborToggles[0][0].getState());
      println("rules[0][0] = "+neighborToggles[0][0].getState());
      break;
    case '2':
      neighborToggles[1][0].setValue(!neighborToggles[1][0].getState());
      println("rules[1][0] = "+neighborToggles[1][0].getState());    
      break;
    case '3':
      neighborToggles[2][0].setValue(!neighborToggles[2][0].getState());
      println("rules[2][0] = "+neighborToggles[2][0].getState());    
      break;
    case '4':
      neighborToggles[0][1].setValue(!neighborToggles[0][1].getState());
      println("rules[0][1] = "+neighborToggles[0][1].getState());    
      break;
    case '6':
      neighborToggles[2][1].setValue(!neighborToggles[2][1].getState());
      println("rules[2][1] = "+neighborToggles[2][1].getState());    
      break;
    case '7':
      neighborToggles[0][2].setValue(!neighborToggles[0][2].getState());
      println("rules[0][2] = "+neighborToggles[0][2].getState());    
      break;
    case '8':
      neighborToggles[1][2].setValue(!neighborToggles[1][2].getState());
      println("rules[1][2] = "+neighborToggles[1][2].getState());    
      break;
    case '9':
      neighborToggles[2][2].setValue(!neighborToggles[2][2].getState());
      println("rules[2][2] = "+neighborToggles[2][2].getState());    
      break;


    case 'o':
      openImage();
      break;
    case 's':
      saveImage();
      break;
    case 'p': // play toggles animation
      play=!play;
      break;
    case 'q':
      initRules(); 
      break;
    case 'w': // w toggles edge wrap mode
      wrapToggle(!wrap);
      break;
    case 'e':
      resetButton();
      break;
    case 'r': // 
      recordToggle(!record);
      break;
    case 'v': // 
      visibleToggle(!visible);
      break;
    }
  }
}