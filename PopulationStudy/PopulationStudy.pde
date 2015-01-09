ColonySystem colonies;

void setup() {
  size(500, 500); // set screen size
  colonies = new ColonySystem();
  for (int i = 0; i < 50; i++) {
    colonies.addColony();
  }
  frameRate(10);  // set framerate
  
}

void draw(){
  background(255);
  colonies.run();
}





