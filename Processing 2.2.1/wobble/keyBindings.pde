void keyReleased() {
  switch(key) {
  case 'o':
    open_file();
    break;
  case 's':
    save_file();
    break;
  case ' ':
    run = !run;
    if (!run) {
      noLoop();
    } else {
      loop();
    }
    break;
  default:
    if (!run) {
      redraw();
    }
    break;
  }
}
