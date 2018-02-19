public class ControlFrame extends PApplet {

  int w, h;
  PApplet parent;
  ControlP5 cp5;

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
  int thresholdSlidersSpacing = 20;

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

    cp5.addSlider("rMin")
      .setPosition(thresholdSlidersX, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacing)*0)
      .setSize(thresholdSlidersW, thresholdSlidersH)
      .setMin(0)
      .setMax(255)
      .setValue(red(min))
      ;

    cp5.addSlider("gMin")
      .setPosition(thresholdSlidersX, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacing)*1)
      .setSize(thresholdSlidersW, thresholdSlidersH)
      .setMin(0)
      .setMax(255)
      .setValue(green(min))
      ;

    cp5.addSlider("bMin")
      .setPosition(thresholdSlidersX, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacing)*2)
      .setSize(thresholdSlidersW, thresholdSlidersH)
      .setMin(0)
      .setMax(255)
      .setValue(blue(min))
      ;

    cp5.addSlider("rMax")
      .setPosition(thresholdSlidersX+thresholdSlidersW+thresholdSlidersSpacing, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacing)*0)
      .setSize(thresholdSlidersW, thresholdSlidersH)
      .setMin(0)
      .setMax(255)
      .setValue(red(max))
      ;

    cp5.addSlider("gMax")
      .setPosition(thresholdSlidersX+thresholdSlidersW+thresholdSlidersSpacing, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacing)*1)
      .setSize(thresholdSlidersW, thresholdSlidersH)
      .setMin(0)
      .setMax(255)
      .setValue(green(max))
      ;

    cp5.addSlider("bMax")
      .setPosition(thresholdSlidersX+thresholdSlidersW+thresholdSlidersSpacing, thresholdSlidersY+(thresholdSlidersH+thresholdSlidersSpacing)*2)
      .setSize(thresholdSlidersW, thresholdSlidersH)
      .setMin(0)
      .setMax(255)
      .setValue(blue(max))
      ;
  }

  void draw() {
    background(0);
    min = color(cp5.getValue("rMin"),cp5.getValue("gMin"),cp5.getValue("bMin"));
    max = color(cp5.getValue("rMax"),cp5.getValue("gMax"),cp5.getValue("bMax"));
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
    case '=': // up arrow
      if (max < 255) max++;
      println(max);
      break;
    case '-': // down arrow
      if (max > min) {
        max--;
      } else {
        min = max;
      }
      println(max);
      break;
    case '[': // up arrow
      if (min > 0) min--;
      println(min);
      break;
    case ']': // down arrow
      if (min < max) {
        min++;
      } else {
        max = min;
      }
      println(min);
      break;
    case 'p': // play toggles animation
      play=!play;
      break;
    case 'q':
      initRules(); 
      break;
    case 'w': // w toggles edge wrap mode
      wrap=!wrap;
      break;
    case 'e':
      resetOutput();
      break;
    case 'r': // 
      record=!record;
      break;
    }
  }
}