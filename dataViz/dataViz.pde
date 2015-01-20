byte[] raw_bytes;
byte[] raw_bits;

String input_path = "input/";
String input_filename = "GoogleChromeFramework";
String input_ext = ".bin";

String output_path = "output/test/";
String output_filename = "test";
String output_ext = ".PNG";

int offset=0; // skips bits 

void setup(){
 size(128, 128);
 raw_bytes = loadBytes(input_path + input_filename + input_ext);
 raw_bits = new byte[raw_bytes.length*8];
 bytes_to_bits();
 
}

void draw(){
  bits_to_pixels();
  //saveFrame(output_path + output_filename +"_####"+  output_ext);
  if(frameCount>1000){
    exit();
  }
}

void bytes_to_bits(){
  
  for(int i = 0 ; i < raw_bytes.length ; i++){    
    for(int j = 0 ; j < 8 ; j++){    
      raw_bits[(i*8)+j] = byte((raw_bytes[i] >> j) & 1); 
    }  
  }
  
}

void bits_to_pixels(){
  
  loadPixels();
  color[] pixel_values = new color[pixels.length];
  
  int[] chan1 = new int[pixels.length]; 
  int[] chan2 = new int[pixels.length];
  int[] chan3 = new int[pixels.length];
  
  // sets number of bits to be packed into color channel values
  int chan1_depth = 1; //defaul = red channel
  int chan2_depth = 1; //default = green channel
  int chan3_depth = 1; //default = blue channel
  
  int pixel_depth = chan1_depth + chan2_depth + chan3_depth; //this is the total number of bits used to create a pixel
  
  for(int i = 0 ; i < pixels.length ; i++){
    
    int chan1_value = 0;
    int chan2_value = 0; 
    int chan3_value = 0; 
    
    //using some bit shifting voodoo to pack bits into channel values
    
    for(int x = 0 ; x < chan1_depth ; x++){
      chan1_value |=  (raw_bits[((i+offset)*pixel_depth)+x] << x);
    }
  
    for(int y = 0 ; y < chan2_depth ; y++){
      chan2_value |=  (raw_bits[((i+offset)*pixel_depth)+chan1_depth+y] << y);
    }
  
    for(int z = 0 ; z < chan3_depth ; z++){
      chan3_value |=  (raw_bits[((i+offset)*pixel_depth)+chan1_depth+chan2_depth+z] << z);       
    }
    
    pixels[i] = color(chan1_value*(255/(pow(2,(chan1_depth))-1)), chan2_value*(255/(pow(2,(chan2_depth))-1)), chan3_value*(255/(pow(2,(chan3_depth))-1)));
  
  }
  
  updatePixels();
  offset+=512; //causes scrolling
  
}
