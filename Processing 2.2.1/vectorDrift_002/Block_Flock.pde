class Flock {
  ArrayList<Block> blocks; // An ArrayList for all the boids

  Flock() {
    this.blocks = new ArrayList<Block>(); // Initialize the ArrayList
  }

  void run() {
    for (Block b : this.blocks) {
      b.run(this.blocks);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBlock(Block b) {
    this.blocks.add(b);
  }

}