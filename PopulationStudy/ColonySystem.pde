class ColonySystem {
  ArrayList<Colony> colonies;
  
  ColonySystem(){
    colonies = new ArrayList<Colony>();
  }
  
  void addColony() {
    colonies.add(new Colony());
  }
    
  void run() {
    for (int i = colonies.size()-1; i >= 0; i--) {
      Colony c = colonies.get(i);
      c.run(colonies, i);
      if (c.population == 0) {
        colonies.remove(i);
      }
    }
  
  }
  
}
