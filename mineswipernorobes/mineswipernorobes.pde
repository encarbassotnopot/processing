
/**
 * Minesweeper en processing (Java)
 * 17/04/2019 | Eina Coma Bages
 */


int size = 24; // tile side size in px
int mines = 99;
int xTiles = 30; // tiles in the x axis
int yTiles = 16; // tiles in the y axis
int lastMillis; // millis when the game was last reseted
int w;

boolean firstClick = true; // 1st time the user clicks a tile?

Tile firstTile = new Tile(0, 0, size); // 1st tile clicked
Tile te;
Tile i;

Tile[][] tiles = new Tile[xTiles][yTiles];
Tile[] tMines = new Tile[mines];

ArrayList<Tile> tFlags = new ArrayList<Tile>();
ArrayList<Tile> toBeRevealed = new ArrayList<Tile>(); // in case of StackOverflowError

void setup() {
  firstClick = true;

  size(720, 400);

  // create tiles
  for (int x = 0; x < xTiles; x++) {
    for (int y = 0; y < yTiles; y++) {
      tiles[x][y] = new Tile(x, y, size);
    }
  }

  // inicialize surrounding tiles
  for (Tile s[] : tiles) {
    for (Tile t : s) {
      t.surrounding[0] = getTile(t.x - 1, t.y - 1);
      t.surrounding[1] = getTile(t.x, t.y - 1);
      t.surrounding[2] = getTile(t.x + 1, t.y - 1);
      t.surrounding[3] = getTile(t.x - 1, t.y);
      t.surrounding[4] = getTile(t.x + 1, t.y);
      t.surrounding[5] = getTile(t.x - 1, t.y + 1);
      t.surrounding[6] = getTile(t.x, t.y + 1);
      t.surrounding[7] = getTile(t.x + 1, t.y + 1);
    }
  } 
  loop();
}

void draw() {
  background(200); 

  if (!toBeRevealed.isEmpty()) {
    for (Tile t : toBeRevealed) {
      try {
        t.reveal();
        toBeRevealed.remove(i);
      } 
      catch (NullPointerException e) {
        println(e);
      }
      i = t;
      if (toBeRevealed.size() == 1) {
        break;
      }
    }
    if (toBeRevealed.size() == 1) {
      toBeRevealed.clear();
    }
  }

  textAlign(CENTER, CENTER);

  w = 0;
  for (Tile s[] : tiles) {
    for (Tile t : s) {
      t.show();
      if (t.revealed) {
        w++;
      }
    }
  }

  if (w == (xTiles * yTiles) - mines &&
    mines == tFlags.size()) {
    winnerWinner();
  }

  fill(0);
  textSize(14);
  textAlign(TOP, TOP);
  text("Time: " + (millis() - lastMillis)/1000 + " Mines: " + (mines - tFlags.size()) + " --Flag all the tiles with mines and reveal the rest to win!--" + " Press r to restart", 0, 384);
}



int flagArround(Tile that) {
  int f = 0;

  for (Tile t : that.surrounding) {
    if (t.flagged) {
      f++;
    }
  }
  return f;
}

void over() {
  for (Tile s[] : tiles) {
    for (Tile t : s) {
      t.theShowIsOver();
    }
  }
  noLoop();
  fill(0);
  textSize(14);
  textAlign(TOP, TOP);
  text("Time: " + (millis() - lastMillis)/1000 + " Mines: " + (mines - tFlags.size()) + " :sad:" + " Press R to try again", 0, 384);
}

void winnerWinner() {
  fill(0);
  textSize(14);
  textAlign(TOP, TOP);
  text("Time: " + (millis() - lastMillis)/1000 + " Mines: " + (mines - tFlags.size()) + " A WINNER IS YOU" + " Press R to play again", 0, 384);

  noLoop();
}

void reset() {
  setup();
  toBeRevealed.clear();
  tFlags.clear();
  lastMillis = millis();
}

// Returns the tile at the given position IN THE ARRAY
Tile getTile(int x, int y) {
  try {
    return tiles[x][y];
  } 
  catch(ArrayIndexOutOfBoundsException e) {
    Tile err = new Tile(0, 0, size);
    return err;
  }
}

void placeMines() {

  // place mines
  for (int m = 0; m < mines; m++) {
    int x = int(random(xTiles));
    int y = int(random(yTiles));
    if (tiles[x][y] != firstTile &&
      tiles[x][y] != firstTile.surrounding[0] &&
      tiles[x][y] != firstTile.surrounding[1] &&
      tiles[x][y] != firstTile.surrounding[2] &&
      tiles[x][y] != firstTile.surrounding[3] &&
      tiles[x][y] != firstTile.surrounding[4] &&
      tiles[x][y] != firstTile.surrounding[5] &&
      tiles[x][y] != firstTile.surrounding[6] &&
      tiles[x][y] != firstTile.surrounding[7] &&
      !tiles[x][y].mine) {
      tiles[x][y].mine = true;
      tMines[m] = tiles[x][y];
    } else {
      m--;
    }
  }

  // set numbers
  for (Tile s[] : tiles) {
    for (Tile t : s) {
      if (!t.mine) {
        for (Tile u : t.surrounding) {
          if (u.mine) {
            t.num++;
          }
        }
      }
    }
  }
}
