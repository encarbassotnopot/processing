
// TODO: de vegades peta, ns pq, però m'ha passat diverses vegades i no he estat capaç de recrear-ho de manera consistent.
// TODO: nivells de dificultat?
// TODO: accelerar serp amb llargada?

/**
 * Snake en processing (Java)
 * 26/05/2019 | Eina Coma Bages
 */

// declaració
int size; // tile side size in px
int xTiles; // tiles in the x axis
int yTiles; // tiles in the y axis
int tempo; // millis between moves
int lastMillis; // millis when the game was last reseted
int lastMove; // millis since last time move() was executed
int deltaTime; // time between draw()
int lastDraw; // millis when draw was last executed

Tile[][] tiles;

Tile head;
int snakeSize;
int facing; // uso els UP, DOWN, LEFT i RIGHT, constants de processing pels id de les fletxes del teclat
int currentFace;
ArrayList<Tile> snake;

int fruitNum; // how many fruits are on screen
ArrayList<Tile> fruits; // where are those furits

void setup() {
  size = 15;
  xTiles = 40;
  yTiles = 40;
  tempo = 100;
  lastMillis = 0;
  lastMove = 0;
  deltaTime = 0;
  lastDraw = 0;
  tiles = new Tile[xTiles][yTiles];
  head = new Tile(0, 0, size);
  snakeSize = 1;
  facing = 0;
  fruitNum = 2;
  snake = new ArrayList<Tile>();
  fruits = new ArrayList<Tile>();

  size(600, 620);

  // create tiles
  for (int x = 0; x < xTiles; x++) {
    for (int y = 0; y < yTiles; y++) {
      tiles[x][y] = new Tile(x, y, size);
    }
  }

  // create snake
  snake.add(tiles[xTiles/2][yTiles/2]);

  lastMillis = millis();
  loop();
}

void draw() {
  while (fruitNum > fruits.size()) {
    Tile f = getTile(int(random(0, xTiles)), int(random(0, yTiles)));
    int r = 0;
    while (snake.contains(f)) {
      f = getTile(int(random(0, xTiles)), int(random(0, yTiles)));
      r++;
      println(r);
    }
    fruits.add(f);
  }

  deltaTime = millis() - lastDraw;
  lastDraw = millis();

  lastMove += deltaTime;

  head = snake.get(0);

  display();

  fill(0);
  textSize(14);
  text("Time: " + (millis() - lastMillis)/1000 + " Length: " + (snake.size()) + " Press R to restart", 0, height - 8);

  if (lastMove > tempo) {
    move();
  }
}

void display() {
  background(200);

  for (Tile s[] : tiles) {
    for (Tile t : s) {
      t.show();
    }
  }

  for (Tile f : fruits) {
    f.fruit();
  }

  for (Tile s : snake) {
    s.snake();
  }
}

void move() {
  lastMove = 0;

  int x = head.x;
  int y = head.y;

  if (facing == UP) {
    snake.add(0, getTile(x, y-1));
    currentFace = UP;
  } else if (facing == DOWN) {
    snake.add(0, getTile(x, y+1));
    currentFace = DOWN;
  } else if (facing == LEFT) {
    snake.add(0, getTile(x-1, y));
    currentFace = LEFT;
  } else if (facing == RIGHT) {
    snake.add(0, getTile(x+1, y));
    currentFace = RIGHT;
  }

  head = snake.get(0);

  Tile rem = null;

  for (Tile f : fruits) {
    if (head == f) {
      snakeSize++;
      rem = f;
    }
  }

  if (rem != null) {
    fruits.remove(rem);
  }

  while (snake.size() > snakeSize) {
    snake.remove(snake.size()-1);
  }
  snake.trimToSize();
}

void over() {
  display();
  noLoop();
  fill(0);
  textSize(14);
  text("Time: " + (millis() - lastMillis)/1000 + " Length: " + (snake.size()) + " :sad:" + " Press R to try again", 0, height - 8);
}

// Returns the tile at the given position IN THE ARRAY
Tile getTile(int x, int y) {
  if (x >= xTiles) {
    while (x >= xTiles) {
      x -= xTiles;
    }
  } else if (x < 0) {
    while (x < 0) {
      x += xTiles;
    }
  }
  if (y >= yTiles) {
    while (y >= yTiles) {
      y -= yTiles;
    }
  } else if (y < 0) {
    while (y < 0) {
      y += yTiles;
    }
  }

  if (snake.contains(tiles[x][y])) {
    over();
  }

  return tiles[x][y];
}
