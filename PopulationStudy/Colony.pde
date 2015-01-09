class Colony{
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  int population;
  int emigrants;
  int immigrants;
  
  Colony(){
    population = int(random(255));
    emigrants = 0;
    immigrants = 0;
    location = new PVector(random(width),random(height));
  }
  
  void run(ArrayList<Colony> colonies , int _index){
    update(colonies);   // update colony populations
    display(_index);  // show the colonies
  }
  
  void update(ArrayList<Colony> colonies) {
    emigrants = 0;
    population += immigrants; // this value should be incremented by other neighboring colonies
    if (birth(population)) population++; 
    if (death(population)) population--;
    if (emigration(population)) emigrants++;
    if (population > 255) emigrants+=population-255;
    if (emigrants > 0){
      //search nearby neighboring colonies
      //randomly select a neighboring colony
      //increment its immigrants field
      //decrement this emigrant field
      //until emigrants = 0
      //if no neighbors, emigrants stay
    }

    
    population += emigrants; // the emigrants who had nowhere to go
    if (population > 255) population = 255; //poputation capped at 255
    
  }

  
  void display(int _index){
    noStroke();
    fill(population);
    ellipse(location.x, location.y, 20, 20);
    println("rendering colony: " + _index + " colony location: " + location.x + ", " + location.y );
    
  }
  
  boolean birth(int _population){
    if(random(1000/1000) < pow(sin(PI*(float(_population)/255)), 2)){
      return true;
    } else {
      return false;
    }
  }
  
  boolean death(int _population){
    if(random(1000/1000) < float(_population)/255){
      return true;
    } else {
      return false;
    }
  }
  
  boolean emigration(int _population){
    if(random(1000/1000) < 0.5 * float(_population) / 255){
      return true;
    } else {
      return false;
    }
  }
  
}
