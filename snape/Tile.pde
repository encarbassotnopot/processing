
class Tile {

  int x; // pos in the array
  int y; // pos in the array
  int realX; // pos in the canvas
  int realY; // pos in the canvas
  int size; // size of the tile

  Tile(int x, int y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.realX = x * size;
    this.realY = y * size;
  }

  void show() {
    dTile(#0000ff);
  }

  void snake() {
    dTile(#ff0000);
  }

  void fruit() {
    dTile(#00ff00);
  }

  void dTile(color c) { // draws a tile w/ the given fill color
    stroke(#0000ff);
    strokeWeight(1);
    fill(c);
    rect(realX, realY, size, size);
  }
}
