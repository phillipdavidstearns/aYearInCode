//Code that will create multiple screens for one App with the ability to pass variables between

// forum.processing.org/two/discussion/6256/classnotfoundexception-when-extending-papplet
 
// http://forum.processing.org/two/discussion/6822/mousepressed-from-another-frame
 
// http://forum.processing.org/two/discussion/7036/multiple-screens

 
static final void main(final String[] args) {
  final String sketch = Thread.currentThread()
    .getStackTrace()[1].getClassName();
 
  final Class[] nested;
  try {
    nested = Class.forName(sketch).getClasses();
  }
  catch (final ClassNotFoundException cause) {
    throw new RuntimeException(cause);
  }
 
  println(nested);
  for (int i = 0, ii = max(0, nested.length-2); i != ii; ++i)  try {
    PApplet.main(nested[i].getName(), args);
  }
  catch (final Exception cause) {
    println(nested[i] + " isn't a PApplet or isn't public static!");
  }
}
 
public static final class MyApp extends PApplet {
  void setup() {
    size(300, 200);
    if (frame != null) {
      frame.setResizable(true);
    }
  }
 
  void draw() {
    
  }
}
 
public static final class MyGUI extends PApplet {
  void setup() {
    size(300, 200);
    if (frame != null) {
      frame.setResizable(true);
    }
  }
 
  void draw() {
    
  }
}
