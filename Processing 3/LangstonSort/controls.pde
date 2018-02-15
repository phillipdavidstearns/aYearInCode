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

    for ( int o = 0; o < 8; o++) {

      for (int e = 0; e < 3; e++) {
        String name = "o"+o+"e"+e;
        buttons[o][e] = cp5.addRadioButton(name+"B")
          .setSize(20, 20)
          .setItemsPerRow(3)
          .setSpacingColumn(20)
          .setSpacingRow(1)
          .setPosition(10, 10+(e*25)+(o*110))
          .addItem("L"+o+e, 0)
          .addItem("R"+o+e, 1)
          .addItem("S"+o+e, 2)
          .activate(turn[o][e])
          ;
          
          toggles[o][e] = cp5.addToggle(name+"T")
          .setLabel("SW"+o+e)
          .setSize(20, 20)
          .setPosition(160, 10+(e*25)+(o*110))
          .setValue(swap[o][e])
          ;
          
        println();
      }
    }
  }


  void draw() {
    background(190);
    for ( int o = 0; o < 8; o++) {
      for (int e = 0; e < 3; e++) {
        turn[o][e] = int(buttons[o][e].getValue());
        swap[o][e] = boolean(int(toggles[o][e].getValue()));
      }
    }
  }

  void randomizeTurns() {
    generateRules();
    for ( int o = 0; o < 8; o++) {
      for (int e = 0; e < 3; e++) {
        buttons[o][e].activate(turn[o][e]);
        toggles[o][e].setValue(swap[o][e]);
      }
    }
  }
}