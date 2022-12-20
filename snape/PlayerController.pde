// input for the game

void keyPressed() {

  if (key == CODED) {
    if (keyCode == UP && !(currentFace == DOWN)) {
      facing = UP;
    } else if (keyCode == DOWN && !(currentFace == UP)) {
      facing = DOWN;
    } else if (keyCode == LEFT && !(currentFace == RIGHT)) {
      facing = LEFT;
    } else if (keyCode == RIGHT && !(currentFace == LEFT)) {
      facing = RIGHT;
    }
  }

  if (key == 'r' || key == 'R') {
    setup();
  }
}
