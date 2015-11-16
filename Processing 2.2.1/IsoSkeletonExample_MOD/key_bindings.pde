void keyPressed() {
  switch(key) {
  case '1':
    blend_mode = 0;
    break;
  case '2':
    blend_mode = 1;
    break;
  case '3':
    blend_mode = 2;
    break;
  case '4':
    blend_mode = 3;
    break;
  case '5':
    blend_mode = 4;
    break;
  case '6':
    blend_mode = 5;
    break;
  case 'm':
    move = !move;
    break;
  case'v':
    randomizeVelocities();
    break;
  case'p':
    randomizePositions();
    break;
  case '7':
    sp_mult = .00125;
    break;
  case '8':
    sp_mult = .0125;
    break;
  case '9':
    sp_mult = .125;
    break;
  case '0':
    sp_mult = 1.25;
    break;
  case '-':
    cam_x_mult = random(-2, 2);
    cam_y_mult = random(-2, 2);
    break;
  case '=':
    offset_skeleton = random(256);
    offset_iso = random(256);
    offset_wrap = random(256);
    break;
  case 'q':
    render_texture = !render_texture ;
    break;
  case 'w':
    render_skeleton = !render_skeleton ;
    break;
  case 'e':
    render_iso = !render_iso ;
    break;
  case 'r':
    render_wrap = !render_wrap ;
    break;
  case's':
    skeleton_distance = random(75)+25;
    break;
  case'b':
    render_balls = !render_balls;
    break;
    case 'o':
    save = !save;
    if (save == true) println("saving!");
    if (save == false) println("done saving!");
    break;
  }
}

