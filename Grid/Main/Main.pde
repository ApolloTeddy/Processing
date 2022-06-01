Cell[][] cells;

int res = 10;

int cols = 16;
int rows = 9;

void setup() {
  fullScreen();
  frameRate(500);
  noStroke();
  cells = new Cell[width][height];
  generateCells();
}

void generateCells() {
  int tCols = cols * res;
  int tRows = rows * res;
  for(int x = 0; x < tCols; x++) {
    for(int y = 0; y < tRows; y++) {
      cells[x][y] = new Cell(x * width / tCols, y * height / tRows, width / tCols, height / tRows, x + y);
    }
  }
}

void displayCells() {
  int tCols = cols * res;
  int tRows = rows * res;
  for(int x = 0; x < tCols; x++) {
    for(int y = 0; y < tRows; y++) {
      cells[x][y].oscillate();
      cells[x][y].show();
    }
  }
}

void draw() {
  background(0);
  displayCells();
}

void mousePressed() {
  if(mouseButton == LEFT) {
    res++;
    generateCells();
  } else if(mouseButton == RIGHT) {
    res--;
    generateCells();
  }
}

class Cell {
  float x, y;
  float w, h;
  float angle;
  
  Cell(float x, float y, float w, float h, float angle) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.angle = angle;
  }
  
  void oscillate() {
    angle += 0.025;
  }
  
  void show() {
    fill(63.5 + 63.5 * sin(this.angle), 0, 127 + 63.5 * -sin(this.angle));
    rect(this.x, this.y, this.w, this.h);
  }
}
