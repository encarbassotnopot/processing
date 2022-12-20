// input for the game

void mouseClicked() {
  if (firstClick) {
    firstTile = getTile(mouseX/size, mouseY/size);
    placeMines();
    firstClick = false;
  }
  if (mouseButton == 37) {
    Tile t = getTile(mouseX/size, mouseY/size);
    t.reveal();

    if (t.num == flagArround(t) && t.revealed) {
      t.revealArround();
    }
  }

  if (mouseButton == 39) {
    Tile t = getTile(mouseX/size, mouseY/size);
    t.flag();
  }
}


void mousePressed() {
  if (mouseButton == 3) {
    te = getTile(mouseX/size, mouseY/size);
    te.high();
  }
}

void mouseReleased() {
  if (mouseButton == 3) {
    te.low();
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    reset();
  }
}
