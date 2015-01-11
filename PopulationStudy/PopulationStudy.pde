ColonySystem colonies;

void setup() {
  background(255);
  size(1280, 720); // set screen size
  colonies = new ColonySystem();
  for (int i = 0; i < 5; i++) {
    colonies.addColony();
  }
  frameRate(60);  // set framerate);
  
}

void draw(){
  //background(255);
  
  colonies.run();
  //saveFrame("output/test4/Colonies_Color-######.PNG");
}





