/*

nodes_edges_draft v0.0.0.1
by
Phillip Stearns 2014

A basic mass and springs simulation

Right now the sketch opens with a number of randomly positioned nodes connected dynamically according to their relative distance.
The network structure will take different forms based on the distance required for a "bond" referred to as edge or spring to form, the distance at which a that spring is broken,
the length of the spring once formed, the spring constant (how springy), dampening, and the mass of the nodes.

Edges are shaded based on their length in relation to the bond breaking length.
Nodes are shaded based on their momentum (mass * velocity).

Let the system settle into equilibrium, then introduce perturbations:
ENTER bumps a random node.
SPACE selects a node at random and starts/stops it wiggling.

This is not the final entrainment model. What I am working towards was building a system that could exhibit entrainment as an emergent property.
The idea is to model a situation based on the synchronizing metronomes, but with a twist.
One approach I have in mind is to create a large "world" mass. Upon it, a few smaller "land" masses are anchored to "world" by "springs". Upon the lands, "objects" are anchored to
"land" by springs and a network between objects is also generated and fixed. Objects, lands, world could all be set into motion.

There are several things that I'm working on implementing:
Interface to specify the total number, location, and mass of the nodes (basic node editing).
Interface to either manually or dynamically connect nodes (basic edge editing).
Nodes to connect via edges based on their mass and distance.
Option to enable/disable locking in the network of edges.
Possibly adding flocking algos in addition to spring interactions.
Possibly adding markov chains to bond making/breaking or to add a dynamic element to spring constants or spring lengths.

*/


Node[] nodes;

ArrayList<Edge> new_edges;
ArrayList<Edge> old_edges;

PVector[] forces;

boolean[][] edge_nodes;

int qty_nodes;

int counter = 0;

float make_bond = 25;
float break_bond = make_bond * 1.20;
float spring_length = make_bond * .75;
float spring_constant = 10;
float dampening = .99;

boolean startOscillation = false;
float rate = 120 ;
int wiggler = 0;

boolean save_output = false;

void setup() {
  
  size(500, 500);
  background(255);
  noSmooth();
  frameRate(30);
  
  qty_nodes = 1500;
  
  nodes = new Node[qty_nodes];
  forces = new PVector[qty_nodes];
  
  for (int i = 0 ; i < qty_nodes ; i++) {
    nodes[i] = new Node(random(width), random(height), random(0)+50);
    forces[i] = new PVector(0, 0);
  }
  
  new_edges = new ArrayList<Edge>();
  old_edges = new ArrayList<Edge>();
  
  edge_nodes = new boolean[qty_nodes][qty_nodes];
  for(int a = 0 ; a < qty_nodes ; a++ ){
    for(int b = 0 ; b < qty_nodes ; b++ ){
      edge_nodes[a][b]=false;
    }
  }
}


void draw() {  
 //fill(255,0,0,8);
 //rect(0,0,width,height);
  //clear background
  background(255);

  //calculate the forces on each of the nodes
  calculateForces();
    
  //apply the forces to the node and update their position  
  updateNodes(forces);
  
  //add the wiggle factor
  if(startOscillation == true){
    oscillateNodes();
  }
  
  //recalculate the bonds based on the updated node positions
  updateBonds();
  
  //show us what you got
  
  displayNodes();
  displayEdges();
  
  if(save_output == true){
    saveFrame("output/material-#####.PNG");
  }
  
}

void oscillateNodes(){
  
  //fixed oscillation applied to a single node
  
  if (counter >= rate){
    counter = 0;
  }
  
  PVector _force = new PVector(200*sin(2 * TWO_PI * (counter/rate)), 200*sin( 3 * TWO_PI * (counter/rate)));

    nodes[wiggler].update(_force);
  
  counter++;
}

void keyPressed() {
  
  //randomly bump a node, press ENTER
  //turn on and off wiggling of a randomly selected node by pressing SPACE
  if (key == 's' | key == 'S') {
     save_output = true;
  }
  
  if (key == ESC) {
     save_output = false;
  }
  if (key == ENTER) {
    PVector _force = new PVector(random(5000)-2500,random(5000)-2500);
    nodes[int(random(qty_nodes))].update(_force);
  } else if (key == ' ') {
    if(startOscillation == true){
      //stop wiggling
      startOscillation=false;  
    } else {
      //choose a node at random
      wiggler = int(random(qty_nodes));
      //make it wiggle
      startOscillation = true;
    }
  }
}

void updateBonds() {
  
  //reset edge_nodes catalog
  for(int a = 0 ; a < qty_nodes ; a++ ){
    for(int b = 0 ; b < qty_nodes ; b++ ){
      edge_nodes[a][b]=false;
    }
  }
  
  //new edges become old ones
  for(int i = 0 ; i < new_edges.size(); i++){
    old_edges.add(new_edges.get(i));
  }
  
  //clear out the new edges
  new_edges = new ArrayList<Edge>();

  //the creates initial bonds if none exist
  if(old_edges.size() == 0){
    for (int i = 0; i < nodes.length ; i++){
      for (int j = i; j < nodes.length ; j++){
        if ( j != i ){
          if (PVector.dist(nodes[i].location, nodes[j].location) <= make_bond) {
            Edge e = new Edge(nodes[i].x, nodes[i].y, nodes[j].x, nodes[j].y, i, j);
            new_edges.add(e);
          }
        }
      }
    }
    old_edges = new ArrayList<Edge>();
  } else {
    //update existing bonds and add to new_edges, bonds greater than the breaking length are left behind
    for(int k = 0 ; k < old_edges.size() ; k++){
      Edge e = old_edges.get(k);
      if(PVector.dist(nodes[e.a].location, nodes[e.b].location) < break_bond){
        Edge e_buffer = new Edge(nodes[e.a].x, nodes[e.a].y, nodes[e.b].x, nodes[e.b].y, e.a, e.b);
        new_edges.add(e_buffer);
        edge_nodes[e.a][e.b] = true;     
      }
    }
    //if there's not already an edge for a pair of nodes within the make_bond distance, make one in new_edges
    for (int i = 0; i < nodes.length ; i++){
      for (int j = i; j < nodes.length ; j++){
        if ( j != i ){
          if(edge_nodes[i][j] != true){
            if (PVector.dist(nodes[i].location, nodes[j].location) <= make_bond) {
              Edge e = new Edge(nodes[i].x, nodes[i].y, nodes[j].x, nodes[j].y, i, j);
              new_edges.add(e);
            }
          }
        }
      }
    }
    //dump old edges
    old_edges = new ArrayList<Edge>();
  }
}


void updateNodes(PVector[] _forces) {
  for (int i = 0 ; i < qty_nodes ; i++) {
    nodes[i].update(_forces[i]);
  }
}

void displayNodes() {
  for (int i = 0 ; i < qty_nodes ; i++) {
    nodes[i].display();
  }
}

void displayEdges() {
  for (Edge e: new_edges) {
    e.display();
  }
}

void calculateForces() {
  
  //clear the array of forces. 
  for (int i = 0 ; i < forces.length ; i++) {
    forces[i].set(0, 0);
  }

  
  for (int i = 0 ; i < new_edges.size() ; i++) {
    
    Edge e = new_edges.get(i);
    
    //create force vectors for each node defining the edge 
    PVector _forceA = PVector.sub(e.head, e.tail);
    PVector _forceB = PVector.sub(e.tail, e.head);
    
    //calculate the magnitude of force exterted by the edge's springy properties
    float _mag = spring_constant * (spring_length - PVector.dist(e.head, e.tail));
    
    //set the magnitude of the force vectors
    _forceA.setMag(_mag);
    _forceB.setMag(_mag);
    
    //add the new forces to those in the array
    forces[e.a] = PVector.add(_forceA, forces[e.a]);
    forces[e.b] = PVector.add(_forceB, forces[e.b]);
  }
}

