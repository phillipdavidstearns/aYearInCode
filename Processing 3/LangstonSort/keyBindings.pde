void keyPressed() {
  switch(key) {
  case 'o':
    selectInput("Select a file to read:", "inputSelected");
    break;
  case 's':
    selectOutput("Select a file to write to:", "outputSelected");
    break;
  case 'r':
    if (ants!=null) {
      for (int i = 0; i < ants.length; i++) {
        ants[i].randomize();
      }
    }
    break;
  case 'g':
    controls.randomizeTurns();
    break;
  case RETURN:
    play = !play;
    break;
  case 'f':
    buffer=input.copy();
    break;
    case 'v':
    visible = !visible;
    break;
  }
}