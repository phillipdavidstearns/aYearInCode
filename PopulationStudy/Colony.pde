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
  float attraction = -.125;
  int age;
  float dampening = .95;
  int popLimit = 255;
  float r = 100;
  
  float deathRate = .11;
  float emigrationRate = .05;
  
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
    //print("Population of " + population + " + " + immigrants + " immigrants");
    
    if (immigrants > 0){
      population += immigrants; // this value should be incremented by other neighboring colonies
      immigrants = 0;
    }
    
    if (birth(population)){
      population+=int(random(5)+1);
     // print(" + 1 birth");
    }
    
    if (death(population)){
      population-=int(random(deathRate*age));
     // print(" - 1 death");
    }
    
    if (population > popLimit){
      emigrants+=(population-popLimit);     
    } else {
      emigrants+=int(random(emigrationRate*population));
    }
    
    population -= emigrants;    
   // print(" = " + population + " colonists and " + emigrants + " emigrants. ");
    if (emigrants > 0){
     emigration(colonies);
     if(emigrants > 0){
       newColony(emigrants);
     }
    }
    //print(" final population after emigration = " + population + " + " + emigrants + " emigrants not relocated = ");
    population += emigrants;
    //println(population);
    changeInPopulation = changeInPopulation - population;
    //println("changeinPopulation = " + changeinPopulation);
    locomotion(colonies, changeInPopulation); 
    age++;
  }

  void emigration(ArrayList<Colony> colonies){
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
    if(random(1000/1000) < (1 - float(_population)/255)){
      return true;
    } else {
      return false;
    }
  }
  
  boolean birth(int _population){
    //if(random(1000/1000) < (1 - float(_population)/255)){
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
