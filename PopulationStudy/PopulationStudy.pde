ColonySystem colonies;

void setup() {
  background(255);
  size(1920, 1080); // set screen size
  colonies = new ColonySystem();
  for (int i = 0; i < 15; i++) {
    colonies.addColony();
  }
  frameRate(60);  // set framerate);
  
}

void draw(){
  //background(255);
  
  colonies.run();
//  saveFrame("output/color02/Colonies_Color02-######.PNG");
//  if(frameCount >= 3600){
//    exit();
//  }
  
}





