class Circle
{
  PVector pos;
  int r;
  Circle(int x, int y, int r)
  {
    this.pos = new PVector(x, y);
    this.r = r;
  }
  
  void show()
  {
    push();
    fill(80);
    stroke(100);
    noStroke();
    ellipseMode(RADIUS);
    circle(this.pos.x, this.pos.y, this.r * 2);
    pop();
  }
  
  boolean isIntersecting(Circle other)
  {
    return sq(this.pos.x - other.pos.x) + sq(this.pos.y - other.pos.y) <= sq(this.r + other.r);
  }
}
