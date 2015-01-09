ColonySystem colonies;

void setup() {
  size(1280, 720); // set screen size
  colonies = new ColonySystem();
  for (int i = 0; i < 5; i++) {
    colonies.addColony();
  }
  frameRate(60);  // set framerate);
}

void draw(){
  background(255);
  colonies.run();
  //saveFrame("output/test2/Colonies_001-######.PNG");
}





