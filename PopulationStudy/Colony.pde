class Colony{
  
  //vectors for doing the physics of classical motion
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  float population;
  int emigrants;   // colony members leaving
  int immigrants;  // colony members arriving
  float radius;    
  float affinity = -.125;
  int age;
  float dampening = .95;
  float popLimit = 255;
  float r = 50;
  float birthRate = 1.5;
  float deathRate = .5;
  float emigrationRate = 2;
  
  Colony(){
    age = 0;
    population = int(random(255));
    emigrants = 0;
    immigrants = 0;
    location = new PVector(random(width),random(height));
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
  }
  
  Colony(float _x, float _y, float _population){
    age = 0;
    population = _population;
    emigrants = 0;
    immigrants = 0;
    location = new PVector(_x, _y);
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
  }
  
  void run(ArrayList<Colony> colonies){
    update(colonies);   // update colony populations
    display();  // show the colonies
  }
  
  void update(ArrayList<Colony> colonies) {
    float changeInPopulation = population;
    emigrants = 0;
    population += immigrants; // this value should be incremented by other neighboring colonies
    immigrants = 0;
    birth();
    death();
    emigration(colonies);
    changeInPopulation = changeInPopulation - population;
    locomotion(colonies, changeInPopulation); 
    age++;
  
}

  void emigration(ArrayList<Colony> colonies){
    emigrants=int( emigrationRate * population/popLimit );
    population -= emigrants;  
    if(population > popLimit){
      emigrants += int (population - popLimit);
      population -= emigrants;
    }
    
    if (emigrants > 0){
      int rNeighborhood = 75; // radius of the neighborhood
      int colonyCount = colonies.size();
      while(colonyCount > 0 && emigrants > 0){
        colonyCount--;
        Colony c = colonies.get(colonyCount);
        float distance = PVector.dist(c.location, location);
        if (distance != 0.0 && emigrants > 0 && distance < rNeighborhood){
          if(c.immigration(c.population)){
            c.immigrants++;
            emigrants--;
            colonies.set(colonyCount, c);
          }
        }
      }
      
      if(emigrants > 0){
        newColony(emigrants);
      }
    }
  }
  
  void locomotion(ArrayList<Colony> colonies, float _changeInPopulation){
    
    velocity.setMag((_changeInPopulation+population)*velocity.mag() / population);
   
    PVector force = new PVector(0, 0);
    
    
    for (int i = colonies.size()-1; i >= 0; i--) {      
      PVector[] forces = new PVector[colonies.size()];
      Colony c = colonies.get(i);
      float distance = PVector.dist(c.location, location);
      if(distance >= 0.5){              
      forces[i] = PVector.sub(c.location, location);
      float mag = (affinity * (c.population*population / pow(distance,2))) ;
      forces[i].setMag(mag);
      force.add(forces[i]);
      }
    }
    PVector f = PVector.div(force, population);
    acceleration.add(f);
    velocity.add(acceleration); // Velocity changes according to acceleration
    location.add(velocity);     // Location changes according to velocity
    acceleration.mult(0);
    velocity.mult(dampening); // dampening
}
  
  void newColony(int _emigrants){
    colonies.addColony(.5*radius*cos(random(2*PI))+location.x , .5*radius*sin(random(2*PI))+location.y, _emigrants);
  }
  
  void display(){
    colorMode(HSB, 255);
    noStroke();
    fill(velocity.mag()*255, age, population*2);
    if(r < 0){
      r = 0;
    }
    radius = r*(population/255);
    ellipse(location.x, location.y, radius, radius);
  }
  
  boolean immigration(float _population){
    if(random(1000/1000) < .5 * (1 - _population/popLimit)){
      return true;
    } else {
      return false;
    }
  }
  
  void birth(){
    population +=  int((birthRate * population) * pow(sin(PI*(population/popLimit)),2)) ;
  }
  
  void death(){
    population -= int((deathRate * (age) * population/popLimit)) + 1;
  }
  

}
