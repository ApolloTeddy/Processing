class Point {
  float x, y;
  Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void show() {
    push();
    stroke(0);
    translate(x, y);
    point(0, 0);
    pop();
  }
}
