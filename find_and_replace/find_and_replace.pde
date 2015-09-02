byte[] file;
int find = 0;
int replace = 0;
String filename = "1000X1000";
String extension = ".GIF";

void setup(){  
  size(10,10);
  file = loadBytes(filename+extension);
  noLoop();
}

void draw(){
  
  for(int i = 0 ; i < 256; i++ ){
    for(int j = 0 ; j < 265; j++){
      if(i != j){
        for(int k = 0 ; k < file.length ; k++){
  
          if(int(file[k]) == i){
            file[k] = byte(j);
          } 
        }
      saveBytes("output/"+filename+"/"+filename+"_"+int(i)+"_"+int(j)+extension, file);
      }
    }
  }
  exit();
}
