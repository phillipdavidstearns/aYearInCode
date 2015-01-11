ColonySystem colonies;

void setup() {
  size(1280, 720); // set screen size
  colonies = new ColonySystem();
  for (int i = 0; i < 5; i++) {
    colonies.addColony();
  }
  frameRate(60);  // set framerate);
  background(255);
}

void draw(){
  
  colonies.run();
  saveFrame("output/test3/Colonies_002-######.PNG");
}





