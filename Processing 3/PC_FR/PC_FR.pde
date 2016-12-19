PImage design;

//initial data
float[] sales = {  
  0.7, 13.2, 23.1, 21.0, 21.6, 6.2
};
float[] margin = { 
  13.7, 13.8, 11.7, 10.6, 8.7, 7.2
};
float[] stores = {
  181.0, 292.0, 446.0, 633.0, 798.0, 958.0
};

//normalize the data
int[] salesNorm;
int[] marginNorm;
int[] storesNorm;

int RGBMode = 0;
boolean invA, invB, invC, notA, notB, notC = false;

void setup() {
  size(768, 1000);
  design = createImage(768, 1000, RGB);
  salesNorm = normalize(sales);
  marginNorm = normalize(margin);
  storesNorm = normalize(stores);
  noLoop();
}

void draw() {
  
  //goes through and renders and saves every possible combination of variables for rendering the data
  for (int i = 0; i < 6; i++) {
    
    for (int j = 0; j < 8; j++) {
      
      RGBMode = i;
      invA = boolean(j & 1);
      invB = boolean(j >> 1 & 1);
      invC = boolean(j >> 2 & 1);
      
      for (int k = 0; k < 8; k++) {
        notA = boolean(k & 1);
        notB = boolean(k >> 1 & 1);
        notC = boolean(k >> 2 & 1);
        
  
        render(design);
        
        //display(design);
        design.save("output/FastRetailing_2011-2016_"+RGBMode+"_"+j+"_"+k+".png");
        
      }
      
    }
    
  }
  
  exit();
  
}


// normalizes input to int between 0-255
int[] normalize(float[] data) {
  int[] normalized = new int[data.length];
  float largest = 0.0;
  for (int i = 0; i < data.length; i++) {
    if (data[i] > largest) {
      largest = data[i];
    }
  } 
  for (int i = 0; i < data.length; i++) {
    normalized[i] = int(255 * data[i] / largest);
  }  
  return normalized;
}

void render(PImage layer) {
  
  //1 Create a gradient between data points
  //2 Translate the gradient to an 8 bit pattern
  //3 multiply the gradient and the pattern
  //4 assign the data to RGB channels
  
  color[] pattern = new color[8];
  
  int section = int(float(layer.height)/float(5));

  layer.loadPixels(); 
  
  //creates the pattern for the row
  for (int i=0; i < layer.height; i++) {
    
    int div = int(float(i)/float(section));
    float position = float(i%section)/float(section);
    
    for (int k = 0; k < pattern.length; k++) {
      
      //creates an interpolated integer value between data points
      int salesValue = int(lerp(salesNorm[div], salesNorm[div+1], position));
      int marginValue = int(lerp(marginNorm[div], marginNorm[div+1], position));
      int storesValue = int(lerp(storesNorm[div], storesNorm[div+1], position));
      
      int A = 0;
      int B = 0;
      int C = 0;
      
      //render settings
      
      //this is where the masking happens
      if(notA){
        A = salesValue*(1-(salesValue >> k & 1));
      } else {
        A = salesValue*(salesValue >> k & 1);
      }
      
      if(notB){
        B = marginValue*(1-(marginValue >> k & 1));
      } else {
      B = marginValue*(marginValue >> k & 1);
      }
      
      if(notC){
        C = storesValue*(1-(storesValue >> k & 1));
      } else {
      C = storesValue*(storesValue >> k & 1);
      }

      //invert the color channel
      if (invA) A = 0xFF - A;
      if (invB) B = 0xFF - B;
      if (invC) C = 0xFF - C;

      //assign data to color channels
      switch(RGBMode) {
      case 0:
        pattern[k] = color(A, B, C);
        break;
      case 1:
        pattern[k] = color(C, A, B);
        break;
      case 2:
        pattern[k] = color(B, C, A);
        break;
      case 3:
        pattern[k] = color(B, A, C);
        break;
      case 4:
        pattern[k] = color(C, B, A);
        break;
      case 5:
        pattern[k] = color(A, C, B);
        break;
      }
    }  
    
    //repeats the pattern across the design
    for (int j = 0; j < layer.width; j += pattern.length) {
      for (int k = 0; k < pattern.length; k++) {
        layer.pixels[(width*i) +(j+k)] = pattern[k];
      }
    }
    
  }
  layer.updatePixels();
}

void display(PImage layer) {
  image(layer, 0, 0);
}

//here for manual control
void keyPressed() { 
 
  switch(key) {
    
    //testing the normalizing functions
  case 'q':
    printNorm(salesNorm);
    break;
  case 'w':
    printNorm(marginNorm);
    break;
  case 'e':
    printNorm(storesNorm);
    break;
    
    //mode selection
  case '1':
    RGBMode = 0;
    break;
  case '2':
    RGBMode = 1;
    break;
  case '3':
    RGBMode = 2;
    break;
  case '4':
    RGBMode = 3;
    break;
  case '5':
    RGBMode = 4;
    break;
  case '6':
    RGBMode = 5;
    break;

    //channel invert
  case 'a':
    invA=!invA;
    break; 
  case 'b':
    invB=!invB;
    break; 
  case 'c':
    invC=!invC;
    break;
 
  //mask invert
    case 'A':
    notA=!notA;
    break; 
  case 'B':
    notB=!notB;
    break; 
  case 'C':
    notC=!notC;
    break;
  }
  redraw();
}

void printNorm(int[] data) {
  for (int i = 0; i < data.length; i ++) {
    println(data[i]);
  }
}