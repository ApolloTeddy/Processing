class Ray {
  PVector pos, dir;
  
  Ray(float x, float y) {
    this.pos = new PVector(x, y);
    this.dir = new PVector();
  }
  
  void setDir(float x, float y) {
    this.dir.set(x, y);
  }
  
  void show() {
    float x = this.pos.x, y = this.pos.y, dx = this.dir.x, dy = this.dir.y;
    push();
    stroke(75);
    point(x, y);
    line(x, y, dx, dy);
    pop();
  }
}
