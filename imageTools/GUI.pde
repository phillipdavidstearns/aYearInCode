ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}

// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded
public class ControlFrame extends PApplet {

  int w, h;

  
  public void setup() {
    size(w, h);
    frameRate(30);
    cp5 = new ControlP5(this);
    
    cp5.addButton("open_file")
      .setPosition(5, 5)
        .setSize(40, 20)
          .setLabel("open")
            ;

    cp5.addButton("save_file")
      .setPosition(50, 5)
        .setSize(40, 20)
          .setLabel("save")
            ;
            
     cp5.addButton("sort_rows")
      .setPosition(95, 5)
        .setSize(40, 20)
          .setLabel("sort")
            ;
    
  }

  public void draw() {
      background(255);
  }
  
 public void sort_rows() {
    sort_issued=true;
  }
  
 public void open_file() {
    selectInput("Select a file to process:", "inputSelection");
  }
  
  void inputSelection(File input) {
    if (input == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      println("User selected " + input.getAbsolutePath());
      loadData(input.getAbsolutePath());
    }
  }

  public void save_file() {
    selectOutput("Select a file to process:", "outputSelection");
  }
  
  void outputSelection(File output) {
    if (output == null) {
      println("Window was closed or the user hit cancel.");
    } else {
      println("User selected " + output.getAbsolutePath());
      saveData(output.getAbsolutePath());
    }
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
