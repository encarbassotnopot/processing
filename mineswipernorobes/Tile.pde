class Tile {

  int x; // pos in the array
  int y; // pos in the array
  int realX; // pos in the canvas
  int realY; // pos in the canvas
  int size; // size of the tile
  int num; // number of tiles w/ mines arround it (aka: number shown in the tile)

  boolean mine = false; // has a mine
  boolean highlighted = false;
  boolean revealed = false; // has been revealed (clicked on it)
  boolean flagged = false; // has a flag 
  boolean exploded = false; // has a mine and the player pressed the tile
  boolean revealedArround = false;

  Tile[] surrounding = new Tile[8]; // surrounding tiles

  Tile(int x, int y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.realX = x * size;
    this.realY = y * size;
  }

  void show() {

    dTile(255);

    if (highlighted) {
      dTile(230);
    }

    if (revealed) {
      dTile(155);

      // number
      fill(255);
      textSize(18);
      text(num, realX + size/2, realY + size/2);
    }

    if (flagged) {
      dFlag();
    }
  }

  void theShowIsOver() {

    if (mine) {
      dTile(155);
      dMine();
    }

    if (exploded) {
      dTile(#FF0000);
      dMine();
    }

    if (flagged) {
      if (mine) {
        dTile(255);
        dFlag();
      } else {
        dTile(155);
        dMine();

        // cross
        stroke(255, 0, 0);
        strokeWeight(3);
        line(realX + size * 0.15, realY + size * 0.15, realX + size * 0.9, realY + size * 0.9);
        line(realX + size * 0.9, realY + size * 0.15, realX + size * 0.15, realY + size * 0.9);
      }
    }
  }

  void dTile(color c) { // draws a tile w/ the given fill color
    stroke(0);
    strokeWeight(1);
    fill(c);
    rect(realX, realY, size, size);
  }

  void dFlag() { // draws a "flag"
    strokeWeight(1);
    stroke(0);
    fill(255, 0, 0);
    triangle(realX + size * 0.2, realY + size * 0.8, 
      realX + size * 0.8, realY + size * 0.8, 
      realX + size * 0.5, realY + size * 0.2);
  }

  void dMine() { // draws a mine
    stroke(0);
    strokeWeight(10);
    point(realX + size/2, realY + size/2);
  }

  void reveal() {
    if (!flagged) {
      revealed = true;
      if (mine) {
        exploded = true;
        over();
      } else if (num == 0 && !revealedArround) {
        try {
          revealArround();
        }
        catch (StackOverflowError e) {
        }
      }
    }
  }

  void high() {
    highlighted = true;
    for (Tile t : surrounding) {
      t.highlighted = true;
    }
  }

  void low() {
    highlighted = false;
    for (Tile t : surrounding) {
      t.highlighted = false;
    }
    if (num == flagArround(this) && revealed) {
      revealArround();
    }
  }

  void revealArround() {
    for (Tile t : surrounding) {
      try {
        t.reveal();
      } 
      catch (NullPointerException e) {
        toBeRevealed.add(t);
      }
      revealedArround = true;
    }
  }

  void flag() {
    if (!revealed) {
      flagged = !flagged;
      if (flagged) {
        tFlags.add(this);
      } else {
        tFlags.remove(this);
      }
    }
  }
}
