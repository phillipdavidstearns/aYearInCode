void keyPressed() {
  switch(key) {
  case 'o':
    openImage();
    break;
  case 's':
    saveImage();
    break;
  case 'r':
    if (ants!=null) {
      randomizeAnts();
    }
    break;
  case 'g':
    controls.generateNewRules();
    break;
  case RETURN:
    play = !play;
    break;
  case 'f':
    resetBuffer();
    break;
    case 'v':
    visible = !visible;
    break;
  }
}