class Vector
{
  PVector ori, pos;
  color clr = 100;
  int darkenNodes = 30;
  
  Vector(float x, float y)
  {
    this.pos = new PVector(x, y);
    this.ori = new PVector(0, 0);
  }
  
  void show()
  {
    pushMatrix();
    translate(this.ori.x, this.ori.y);
    stroke(clr);
    strokeWeight(10);
    line(0, 0, this.pos.x, this.pos.y);
    stroke(red(clr) - darkenNodes, green(clr) - darkenNodes, blue(clr) - darkenNodes);
    strokeWeight(20);
    point(0, 0);
    point(this.pos.x, this.pos.y);
    popMatrix();
  }
  void setLineColor(color clr) { this.clr = clr; }
  
  void setOrigin(float x, float y)
  {
    this.ori.set(x, y);
    this.pos = PVector.add(this.ori, this.pos);
  }
  
  void sub(Vector other)
  {
    this.pos.x -= other.pos.x;
    this.pos.y -= other.pos.y;
  }
  
  void set(float x, float y) { this.pos.x = x; this.pos.y = y; }
  void set(Vector newPos) { this.pos.x = newPos.pos.x; this.pos.y = newPos.pos.y; }
  
}
