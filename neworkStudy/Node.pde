class Node {

  //rather than have a separate
  ArrayList<Edge> edges;
  float g = 1;
  float maxforce = 25;
  float maxspeed = 5;
  int maxconnections = 5;
  float formBond = 25;
  float breakBond = formBond + 275;
  float m, r;  
  int ID;
  PVector location, velocity, acceleration;

  Node(float _x, float _y, float _m, float _r) {
    location.x = _x;
    location.y = _y;
    m = _m;
    r = _r;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    edges = new ArrayList<Edge>();
  }

  Node(PVector _location, float _m, float _r) {
    location = _location;
    m = _m;
    r = _r;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    edges = new ArrayList<Edge>();
  }

  Node(int _ID) {
    ID = _ID;
    location = new PVector(random(width), random(height));
    m = 50;
    r = 2;
    velocity = new PVector(random(-5, 5), random(-5, 5));
    acceleration = new PVector(0, 0);
    edges = new ArrayList<Edge>();
  }

  void run(ArrayList<Node> _nodes) {
//        calcGravity(_nodes);
    update();
//    nodeCollision(_nodes);
    calcEdges(_nodes);
  
    boundaryCollision();
  }

  void calcEdges(ArrayList<Node> _nodes) {  
    ArrayList<Edge> temp_edges = new ArrayList<Edge>();
    // 1. check to see if existing bonds are valid
    // 2. removed invalid bonds
    // 3. check to see if there are new nodes close enough to make bonds with
    for (int i = _nodes.size () - 1; i >= 0; i--) {

      Node n = _nodes.get(i);
      float dist = location.dist(n.location);
      Edge e = new Edge(this, n);
      if (dist != 0) {

        if (!edges.isEmpty() && !n.edges.isEmpty()) {
          boolean bondExists = false;
          for (int j = edges.size () - 1; j >= 0; j--) {            
            for (int k = n.edges.size () - 1; k >= 0; k--) {
              if (n.edges.get(k).tail_ID != ID && edges.get(j).tail_ID != n.ID) {
                bondExists = false;
              } else {
                bondExists = true;
              }
            }
          }
          if (!bondExists) {
            if (dist < formBond) {
              temp_edges.add(e);
            }
          } else {
            if (dist < breakBond) {
              temp_edges.add(e);
            }
          }
        }

        if (!edges.isEmpty() && n.edges.isEmpty()) {
          boolean bondExists = false;
          for (int j = edges.size () - 1; j >= 0; j--) {
            if(edges.get(j).tail_ID != n.ID){
              bondExists = false;
            } else {
              bondExists = true;
            }
          }
          if (!bondExists) {
            if (dist < formBond) {
              temp_edges.add(e);
            }
          } else {
            if (dist < breakBond) {
              temp_edges.add(e);
            }
          }
        }

        if (edges.isEmpty() && !n.edges.isEmpty()) {
          boolean bondExists = false;
          for (int j = n.edges.size () - 1; j >= 0; j--) {
            if(n.edges.get(j).tail_ID != ID){
              bondExists = false;
            } else {
              bondExists = true;
            }
          }
          if (!bondExists) {
            if (dist < formBond) {
              temp_edges.add(e);
            }
          } else {
            if (dist < breakBond) {
              temp_edges.add(e);
            }
          }
        }

        if (edges.isEmpty() && n.edges.isEmpty()) {
          if (dist < formBond) {
            temp_edges.add(e);
          }
        }
      }
    }
    edges.clear();
    for (int i = temp_edges.size () - 1; i >= 0; i--) {
      Edge e = temp_edges.get(i);
      edges.add(e);
    } 
    temp_edges.clear();
  }

  void calcGravity(ArrayList<Node> _nodes) {
    //A = F/M1
    //F = G*M1*M2/R^2
    //therefore A = G*M2/R^2;


    PVector force = new PVector(0, 0);
    for (int i = 0; i < _nodes.size (); i++) {

      Node n = _nodes.get(i);
      float dist = location.dist(n.location);
      if (dist != 0) {
        force = PVector.sub(location, n.location);
        force.setMag(g*n.m/(pow(location.dist(n.location), 2)));
        applyForce(force);
      }
    }


    //    pow(location.dist(_node.location), 2);
  }


  void applyForce(PVector _force) {
    // We could add mass here if we want A = F / M
    _force.limit(maxforce);
    acceleration.add(_force);
  }

  // Method to update location
  void update() {  
    velocity.add(acceleration);
    //velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display() {  
    stroke(0);
    strokeWeight(0);
    for (int i = edges.size () - 1; i >= 0; i--) {
      Edge e = edges.get(i);
      e.display();
    }

    stroke(0);
    strokeWeight(1);
    fill(0);
    ellipse(location.x, location.y, 2*r, 2*r);
  }

  void boundaryCollision() {
    if (location.x < 0  + r ) {
      velocity.x *= -1;
      location.x = + r;
    }
    if (location.x > width - r) {
      velocity.x *= -1;
      location.x = width-r;
    }
    if (location.y < 0 + r ) {
      velocity.y *= -1;
      location.y = + r;
    }
    if (location.y > height - r) {
      velocity.y *= -1;
      location.y = height-r;
    }
  }

  void nodeCollision(ArrayList<Node> _nodes) {
    for (int i = _nodes.size ()-1; i >= 0; i--) {
      Node other = _nodes.get(i);

      // get distances between the balls components
      PVector bVect = PVector.sub(other.location, location);

      // calculate magnitude of the vector separating the balls
      float bVectMag = bVect.mag();

      if (bVectMag != 0) {
        if (bVectMag < r + other.r) {
          // get angle of bVect
          float theta  = bVect.heading();
          // precalculate trig values
          float sine = sin(theta);
          float cosine = cos(theta);

          /* bTemp will hold rotated ball positions. You 
           just need to worry about bTemp[1] position*/
          PVector[] bTemp = {
            new PVector(), new PVector()
            };

            /* this ball's position is relative to the other
             so you can use the vector between them (bVect) as the 
             reference point in the rotation expressions.
             bTemp[0].position.x and bTemp[0].position.y will initialize
             automatically to 0.0, which is what you want
             since b[1] will rotate around b[0] */
            bTemp[1].x  = cosine * bVect.x + sine * bVect.y;
          bTemp[1].y  = cosine * bVect.y - sine * bVect.x;

          // rotate Temporary velocities
          PVector[] vTemp = {
            new PVector(), new PVector()
            };

            vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
          vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
          vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
          vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

          /* Now that velocities are rotated, you can use 1D
           conservation of momentum equations to calculate 
           the final velocity along the x-axis. */
          PVector[] vFinal = {  
            new PVector(), new PVector()
            };

            // final rotated velocity for b[0]
            vFinal[0].x = ((m - other.m) * vTemp[0].x + 2 * other.m * vTemp[1].x) / (m + other.m);
          vFinal[0].y = vTemp[0].y;

          // final rotated velocity for b[0]
          vFinal[1].x = ((other.m - m) * vTemp[1].x + 2 * m * vTemp[0].x) / (m + other.m);
          vFinal[1].y = vTemp[1].y;

          // hack to avoid clumping
          bTemp[0].x += vFinal[0].x;
          bTemp[1].x += vFinal[1].x;

          /* Rotate ball positions and velocities back
           Reverse signs in trig expressions to rotate 
           in the opposite direction */
          // rotate balls
          PVector[] bFinal = { 
          new PVector(), new PVector()
          };

          bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
          bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
          bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
          bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

          // update balls to screen position
          other.location.x = location.x + bFinal[1].x;
          other.location.y = location.y + bFinal[1].y;

          location.add(bFinal[0]);

          // update velocities
          velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
          velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
          other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
          other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;

          nodes.remove(i);
          nodes.add(other);
        }
      }
    }
  }
}

