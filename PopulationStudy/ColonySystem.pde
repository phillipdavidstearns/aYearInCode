class ColonySystem {
  ArrayList<Colony> colonies;
  
  ColonySystem(){
    colonies = new ArrayList<Colony>();
  }
  
  void addColony() {
    colonies.add(new Colony());
  }
  
  void addColony(float _x, float _y, float _population) {
    colonies.add(new Colony(_x, _y, _population));
  }
  
  void run() {
    for (int i = colonies.size()-1; i >= 0; i--) {
      
      Colony c = colonies.get(i);
      if (c.location.x < 0 || c.location.x > width || c.location.y < 0 || c.location.y > height) {
        colonies.remove(i);
      } else {
        c.run(colonies);
        if (c.population <= 0) {
          colonies.remove(i);
        }
      }
    }
  
  }
  
}
