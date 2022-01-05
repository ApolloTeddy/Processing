Cell[][] grid;

int res = 20;

int cols = 16;
int rows = 9;

void setup() {
  fullScreen();
  grid = new Cell[width][height];
  generateGrid();
}

void generateGrid() {
  int tCols = cols * res;
  int tRows = rows * res;
  for(int x = 0; x < tCols; x++) {
    for(int y = 0; y < tRows; y++) {
      grid[x][y] = new Cell(x * width / tCols, y * height / tRows, width / tCols, height / tRows);
    }
  }
}

void displayGrid() {
  int tCols = cols * res;
  int tRows = rows * res;
  for(int x = 0; x < tCols; x++) {
    for(int y = 0; y < tRows; y++) {
      grid[x][y].display();
    }
  }
}

void draw() {
  background(0);
  displayGrid();
}
