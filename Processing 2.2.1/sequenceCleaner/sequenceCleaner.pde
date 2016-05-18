//'o' open dialog
//'c' clean sequence - this removes any characters that are not ATCG or N - note that you must manually remove any non genomic info
//'l' scales the sequence to values between 0 and 255.
//'s' saves output as raw bytes

byte[] input;
byte[] output;
String path;
int start_codon = 0;
int scroll_speed = 3;
PImage frame;
int counter = 0;

void setup() {
  size(1280, 720); // can be adjusted to match any display
  frameRate(30);
  frame = createImage(width/4, height/4, RGB);
  noSmooth();
}

void draw() {
  if (output != null) {
    frame = createImage(width/4, height/4, RGB);
    renderSequence(frame, output, start_codon);
    start_codon+=scroll_speed;
    image(frame, 0, 0, width, height);
    saveFrame("output/PantheraTigrisAltaica/Panthera Tigris Altaica-"+nfs(counter, 4)+".png");
    counter++;
  }
  if(counter == 5100){
    exit();
  }
}

void keyPressed() {
  switch(key) {
  case 'o':
    selectInput("Select a file to process:", "fileSelected");
    break;
  case 'c':
    cleanSequence(input);
    break;
  case 's':
    if (input == null) {
      println("no sequence loaded. please press 'o' to load a sequence");
    } else if (output == null) {
      println("sequence has not been cleaned. press 'c' to clean sequence.");
    } else {
      selectOutput("Select a file to process:", "outputSelected");
    }
    break;
  case 'l':
    levelSequence(output);
    break;
  case 'r':
    renderSequence(frame, output, start_codon);
    break;
//  case 'q':
//    run = !run;
//    break;
  }
}

void renderSequence(PImage _image, byte[] _sequence, int _skip) {

  if (_sequence == null) {
    println("sequence has not been cleaned. press 'c' to clean.");
    //return;
  } else {
    int[] temp = new int[_image.height*3];
    println("rendering sequence...");
    for (int i = 0; i < temp.length; i++) {
      if (temp.length+_skip < _sequence.length ) {
        if (i + _skip >= 0) {
          switch(_sequence[i + _skip]) {
          case 0x41: //A
            temp[i] = 63;
            break;
          case 0x43: //C
            temp[i] = 127;
            break;
          case 0x47: //G
            temp[i] = 191;
            break;
          case 0x54: //T
            temp[i] = 255;
            break;
          case 0x4E: //N
            temp[i] = 0;
            break;
          default:
            println("sequence contains invalid characters");
            return;
          }
        } else {
          temp[i] = 0;
        }
      }
    }
    _image.loadPixels();
    int index = 0;
    for (int y = 0; y < _image.height; y++) {
      if (index < temp.length) {
        for (int x = 0; x < _image.width; x++) {
          _image.pixels[y*_image.width+x] = 255 << 24 | temp[index] << 16 | temp[index+1] << 8 | temp[index+2];
        }
        index+=3;
      } else {
        for (int x = 0; x < _image.width; x++) {
          _image.pixels[y*_image.width+x] = color(0);
        }
      }
    }
    _image.updatePixels();
    println("done rendering sequence");
  }
}

void animateSequence() {
}

void levelSequence(byte[] _sequence) {
  if (_sequence == null) {
    println("sequence has not been cleaned. press 'c' to clean.");
  } else {
//    byte[] temp = new byte[_sequence.length];
    println("leveling sequence...");
    for (int i = 0; i < _sequence.length; i++) {
      switch(_sequence[i]) {
      case 0x41: //A
        output[i] = byte(63);
        break;
      case 0x43: //C
        output[i] = byte(127);
        break;
      case 0x47: //G
        output[i] = byte(191);
        break;
      case 0x54: //T
        output[i] = byte(255);
        break;
      case 0x4E: //N
        output[i] = byte(0);
        break;
      default:
        println("sequence contains invalid characters");
        return;
      }
    }
    println("done leveling sequence");
  }
}

void cleanSequence(byte[] _input) {
  if (_input == null) {
    println("no sequence loaded. please press 'o' to load a sequence");
  } else {
    byte[] temp = new byte[_input.length];
    int temp_index = 0;
    println("cleaning sequence. sequence has " + _input.length + " items");
    for (int i = 0; i < _input.length; i++) {
      if (_input[i] == 0x41 || _input[i] == 0x43 || _input[i] == 0x47 || _input[i] == 0x54 || _input[i] == 0x4E) {
        temp[temp_index] = _input[i];
        temp_index++;
      }
    }
    output = new byte[temp_index];
    for (int i = 0; i < output.length; i++) {
      output[i] = temp[i];
    }
    println("sequence cleaned. " + (_input.length - temp_index) + " items removed.");
    println("sequence contains " + temp_index + " items");
  }
}

void loadSequence(String _path) {
  println("loading sequence: " + _path);
  input = loadBytes(_path);
  println("sequence loaded");
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    path = selection.getAbsolutePath();
    println("User selected " + path);
    loadSequence(path);
  }
}

void outputSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("saving cleaned sequence as " + selection.getAbsolutePath());
    saveBytes(selection.getAbsolutePath(), output);
    println("done saving file");
  }
}

