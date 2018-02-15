/* dataViz by Phillip Stearns 2015 for aYearInCode();
 * http://ayearincode.tumblr.com
 * revised 2017
 */




byte[] raw_bytes, altered_bytes;

String srcPath; //source path from loaded file
String desPath; //destination path. defaults to create folder called "output" in the location of the source path
String fileName;
String extension;

String[] dirs;
String[] file;


int screen_width = 10;
int screen_height = 10;

void setup(){
  size(10,10);
  background(0);
  if (frame != null) {
    surface.setResizable(true);
  }
  srcPath = new String();
  desPath = new String();
  noLoop();
}



void draw(){
  background(0);
  if (raw_bytes != null){
    findReplace();
    exit();
  } else {
    open_file();
  }
}

void findReplace(){
  //allow the specification of a range of values to operate on
  int find_min=200;
  int find_max=200;
  int replace_min=0;
  int replace_max=255;
  
  for(int find = find_min; find <= find_max; find ++){
    for(int replace = replace_min; replace <= replace_max; replace++){
      
      if(find != replace){
        println("Finding "+find+" and replacing it with "+replace);
        altered_bytes = new byte[raw_bytes.length];
        for(int i = 0; i < raw_bytes.length; i++){
          if(raw_bytes[i] == byte(find)){
            altered_bytes[i] = byte(replace);
          } else {
            altered_bytes[i] = raw_bytes[i];
          }
        }
        
        println(" ...saving... ");
        String newFile = new String(fileName+"_"+find+"_"+replace+"."+extension);
        String savedPath = new String(desPath+"/"+fileName+"_"+find+"/");
        String savedFile = new String(savedPath+newFile);
        
        saveBytes(savedFile, altered_bytes);
        PImage img = loadImage(savedFile);
        img.save(savedPath+"/PNG/"+fileName+"_"+find+"_"+replace+".PNG");        
        println("saved to: "+savedFile);
        println();
      }
    }
  }
  println("All finished! Peace out!");
  
}

void loadData(String _thePath){
  raw_bytes = loadBytes(_thePath);
  altered_bytes = new byte[raw_bytes.length];
  redraw();
}

void keyPressed() {
  
  switch(key) {
  case 'o':
    open_file();
    break;
  }
}




void open_file() {
  selectInput("Select a file to process:", "inputSelection");
}

void inputSelection(File input) {
  if (input == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + input.getAbsolutePath());
    srcPath = input.getAbsolutePath();
    parsePath(srcPath);
    loadData(srcPath);
  }
}

void parsePath(String _thePath){
  dirs = split(_thePath,"/");
    file = split(dirs[dirs.length-1],".");
    fileName = file[0];
    extension = file[1];
    for(int i = 0; i < dirs.length-1 ; i++){
      desPath+=dirs[i]+"/";
    }
    desPath+="output/";
    println("path: "+desPath);
    println("filename: "+file[0]);
    println("extension: "+file[1]);
    println();
}