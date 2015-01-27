class Flock {
  ArrayList<Block> blocks; // An ArrayList for all the boids

  Flock() {
    blocks = new ArrayList<Block>(); // Initialize the ArrayList
  }

  void run() {
    //loadPixels();
    //println("running Flock.run()");
    //updatePixels();
    for (Block b : blocks) {
      b.run(pixels, blocks);  // Passing the entire list of boids to each boid individually
    }
    //updatePixels();
    //println("Flock.run() complete");
  }

  void addBlock(Block b) {
    blocks.add(b);
  }

}
