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
        buttons[o][e] = cp5.addRadioButton(name)
          .setSize(20, 20)
          .setItemsPerRow(3)
          .setSpacingColumn(10)
          .setSpacingRow(1)
          .setPosition(10, 10+(e*30)+(o*110))
          .addItem(name+"L", 0)
          .addItem(name+"R", 1)
          .addItem(name+"S", 2)
          .activate(turn[o][e])
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
        buttons[o][e].activate(turn[o][e]);
      }
    }
  }

  void randomizeTurns() {
    generateRules();
    for ( int o = 0; o < 8; o++) {
      for (int e = 0; e < 3; e++) {
        buttons[o][e].activate(turn[o][e]);
      }
    }
  }

  void keyPressed() {
    switch(key) {
      case 'q':
      randomizeTurns();
      break;
    }
  }
}