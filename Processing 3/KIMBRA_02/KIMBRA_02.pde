Point[] points;


float bounds = 1000;
float l = 100;
float global_weight = .5;

//camera controls
float sp_mult = .0025;
float cam_x_mult = .25;
float cam_y_mult = .15;
float eyeX = 0;
float eyeY = 0;
float eyeZ = 0;
float centerX = 0;
float centerY = 0;
float centerZ = 0;

boolean spring = false;
boolean zoom = true;
boolean network = true;
boolean lines = false;
boolean colorshift = false;
boolean dots = true;
boolean update = false;
boolean clearBackground = true;
boolean oscillate = true;
boolean save = false;

float rate = 0;

int num_points_x = 10;
int num_points_y = 10;
int num_points_z = 10;
int num_points = num_points_x * num_points_y * num_points_z;
int num_points_x_by_y = num_points_x * num_points_y;
color colorA = color(random(256), random(256), random(256));
color colorB = color(random(256), random(256), random(256));

float edge_length = bounds/num_points_x;
float bond = edge_length/2;

void setup() {

  size(1280, 720, P3D);
  surface.setSize(1280, 720);
  surface.setLocation(0, 0);
  noCursor();
  noSmooth();

  points = new Point[num_points];
  pointCube();

  background(0);

  cameraDefault();
}



void pointCube() {
  for (int x = 0; x < num_points_x; x++) {
    for (int y = 0; y < num_points_y; y++) {
      for (int z = 0; z < num_points_z; z++) {
        int index = (y*num_points_x + x) + ((num_points_x_by_y)*z);
        points[index] = new Point(x*(bounds/num_points_x), y*(bounds/num_points_y), z*(bounds/num_points_z), new PVector(0, 0, 0), lerpColor(colorA, colorB, float(index)/num_points));
      }
    }
  }
}

void pointCloud() {
  for (int x = 0; x < num_points_x; x++) {
    for (int y = 0; y < num_points_y; y++) {
      for (int z = 0; z < num_points_z; z++) {
        int index = (y*num_points_x + x) + ((num_points_x_by_y)*z);
        points[index] = new Point(random(-bounds, bounds), random(-bounds, bounds), random(-bounds, bounds), new PVector(0, 0, 0), lerpColor(colorA, colorB, float(index)/num_points));
      }
    }
  }
}

void cameraDefault() {
  eyeX = 100;
  eyeY = 100;
  eyeZ = 100;
  centerX = 0;
  centerY = 0;
  centerZ = 0;
}

void keyPressed() {

  switch(key) {
  case '1':
    for (int i = 0; i < points.length; i++) {
      points[i].direction = new PVector(100, 0, 0);
    }
    break;
  case '2':
    for (int i = 0; i < points.length; i++) {
      points[i].direction = new PVector(0, 100, 0);
    }
    break;
  case '3':
    for (int i = 0; i < points.length; i++) {
      points[i].direction = new PVector(100, 100, 0);
    }
    break;
  case '4':
    for (int i = 0; i < points.length; i++) {
      points[i].direction = new PVector(-100, 100, 0);
    }
    break;
  case '5':
    PVector randomVector = new PVector(random(-1, 1), random(-1, 1), 0);
    for (int i = 0; i < points.length; i++) {
      points[i].direction = randomVector.setMag(100);
    }
    break;

  case '6':
    for (int i = 0; i < points.length; i++) {
      PVector v = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
      points[i].direction = v.setMag(100);
    }
    break;

  case '8':
    for (int i = 0; i < points.length; i++) {
      PVector v = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
      points[i].direction.add(v);
    }
    break;
  case '7':
    for (int i = 0; i < points.length; i++) {
      points[i].direction = new PVector(100, 100, 100);
    }
    break;
  case RETURN:
    for (int i = 0; i < points.length; i++) {
      points[i].applyForce(new PVector(random(-1, 1), random(-1, 1), random(-1, 1)));
    }
    break;
  case 'c':
    colorA = color(random(256), random(256), random(256));
    colorB = color(random(256), random(256), random(256));
    for (int i = 0; i < points.length; i++) {
      points[i].c = lerpColor(colorA, colorB, float(i)/num_points);
    }
    break;
  case 'w':
    global_weight = random(10);
    break;
  case 'q':
    global_weight = .5;
    break;
  case 'o':
    oscillate = !oscillate;
    break;
  case 'p':
    zoom = !zoom;
    break;
  case 's':
    save=!save;
    break;
  case 'n':
    network = !network;
    break;
  case 'l':
    lines = !lines;
    break;

  case 'u':
    update = !update;
    break;

  case 'x':
    colorshift = !colorshift;
    break;

  case 'i':
    dots = !dots;
    break;

  case 'z':
    clearBackground = !clearBackground;
    break;

  case 'b':
    spring = !spring;
    break;
  case 'v':
    for (int i = 0; i < points.length; i++) {
      points[i].velocity.mult(0);
    }
    break;

  case '9':
    pointCube();
    break;
  case '0':
    pointCloud();
    break;
  case 'e':
    edge_length = random(250)+bounds/num_points_x;
    bond = edge_length/2;
    break;
  case '[':
    rate-=.1;
    break;
  case ']':
    rate+=.1;
    break;
  case '|':
    rate=0;
    break;
  case '-':
    rate=.5;
    eyeX = 100;
    eyeY = 100;
    eyeZ = 100;

    break;
  case '=':
    rate=-0.5;
    eyeX = 500;
    eyeY = 500;
    eyeZ = 500;

    break;
  }
}




void draw() {
  if (clearBackground) background(0);

  lights(); 
  ambientLight(64, 64, 64); 
  float zm = 500;
  float sp = sp_mult * frameCount;


  if (zoom) { 
    if (oscillate) {
      eyeX = zm * pow(sin(cam_x_mult*sp), 2)+100;
      eyeY = zm * pow(sin(cam_x_mult*sp), 2)+100;
      eyeZ = zm * pow(sin(cam_x_mult*sp), 2)+100;
    } else {
      eyeZ+=rate;
      eyeX+=rate;
      eyeY+=rate;
    }
  }


  camera(eyeX, eyeY, eyeZ, centerX, centerY, centerX, 0, 0, 1);


  for (int i = 0; i < points.length; i++) {
    if (update) points[i].update();
    if (lines) renderLines(i);
    if (colorshift) points[i].rotateColor(1, 0, 0);
    if (dots) points[i].render(color(255, 255, 255), 10);
  }

  if (network) {
    renderNetwork(edge_length);
  }
  
  if(save){
    saveFrame("output/001/#########.JPG");
  }
  
}

void renderLines(int _index) {
  lineFromPoint(points[_index], l, global_weight, 2);
}

void renderNetwork(float _dist) {
  for (int i = 0; i < points.length; i++) {
    for (int j = i; j < points.length; j++) {
      float dist = PVector.dist(points[i].position, points[j].position);
      if (dist < _dist) {
        if (spring) {
          PVector force = new PVector();
          if (dist < bond) {
            force = PVector.sub(points[i].position, points[j].position).setMag(dist*-.000125);
          }
          if (dist > bond) {
            force = PVector.sub(points[i].position, points[j].position).setMag(dist*.000125);
          }
          points[i].applyForce(force);
          points[j].applyForce(PVector.mult(force, -1));
        }
        drawLine(points[i].position, points[j].position, lerpColor(points[i].c, points[j].c, 0.5), global_weight);
      }
    }
  }
}

void lineFromPoint(Point _point, float _length, float _weight, int _mode) {
  float l = _length;
  PVector p = new PVector();
  PVector q = new PVector();

  switch(_mode) {
  case 0:
    p = _point.position;
    q = PVector.add(_point.position, PVector.mult(_point.direction, l));
    break;
  case 1:
    p = _point.position;
    q = PVector.sub(_point.position, PVector.mult(_point.direction, l));
    break;
  case 2:
    p = PVector.add(_point.position, PVector.mult(_point.direction, l/2));
    q = PVector.sub(_point.position, PVector.mult(_point.direction, l/2));
    break;
  }
  drawLine(p, q, _point.c, _weight);
}

void drawLine(PVector _position1, PVector _position2, color _color, float _weight) {
  stroke(_color);
  strokeWeight(_weight);
  line(_position1.x, _position1.y, _position1.z, _position2.x, _position2.y, _position2.z);
}

void drawLine(PVector _position1, PVector _position2) {
  stroke(0);
  strokeWeight(1);
  line(_position1.x, _position1.y, _position1.z, _position2.x, _position2.y, _position2.z);
}