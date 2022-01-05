class Cell {
  float x, y;
  float w, h;
  float fill = 255;
  
  Cell(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void setFillC(int fill) {
    this.fill = fill;
  }
  
  void display() {
    fill(this.fill);
    rect(this.x, this.y, this.w, this.h);
  }
}
