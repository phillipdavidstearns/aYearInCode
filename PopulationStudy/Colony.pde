class Colony{
  
  //vectors for doing the physics of classical motion
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  int population;
  int emigrants;   // colony members leaving
  int immigrants;  // colony members arriving
  float radius;    
  float repulsion = 0;
  float attraction = -.25;
  int age;
  float dampening = .95;
  int popLimit = 255;
  float r = 100;
  float birthRate = 3.5;
  float deathRate = .125;
  float emigrationRate = .25;
  
  Colony(){
    age = 0;
    population = int(random(255));
    emigrants = 0;
    immigrants = 0;
    location = new PVector(random(width),random(height));
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
  }
  
  Colony(float _x, float _y, int _population){
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
    if (population > popLimit){
      emigrants+=(population-popLimit);     
      } else {
        emigrants+=int(random(emigrationRate*population) * 0.5 * float(population) / 255);
      }
    
    population -= emigrants;    //remove the emigrants from the total population count   
    
    if (emigrants > 0){
      int rNeighborhood = 100; // radius of the neighborhood
      for (int i = colonies.size()-1; i >= 0; i--) {      
        Colony c = colonies.get(i);
        float distance = PVector.dist(c.location, location);
        if (distance != 0.0 && emigrants > 0 && distance < rNeighborhood){
          if(c.immigration(c.population)){
            c.immigrants++;
            emigrants--;
            colonies.set(i, c);
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
      if(distance != 0.0){              
      forces[i] = PVector.sub(c.location, location);
      float mag = (attraction * (float(c.population)*float(population) / pow(distance,2))) + (repulsion * abs(c.age-age));
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
    radius = r*(float(population)/255);
    ellipse(location.x, location.y, radius, radius);
  }
  
  boolean immigration(int _population){
    if(random(1000/1000) < (1 - float(_population)/popLimit)){
      return true;
    } else {
      return false;
    }
  }
  
  void birth(){
    population+=int(random(birthRate*population*(age*.025)) * pow(sin(PI*(float(population)/popLimit)),2) / (age + 1));
  }
  
  void death(){
    population-=int(random(deathRate*age) * float(population)/popLimit);
  }
  

}
