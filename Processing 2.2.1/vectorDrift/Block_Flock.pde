class Flock {
  ArrayList<Block> blocks; // An ArrayList for all the boids

  Flock() {
    blocks = new ArrayList<Block>(); // Initialize the ArrayList
  }

  void run() {
    for (Block b : blocks) {
      b.run(blocks);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBlock(Block b) {
    blocks.add(b);
  }

}