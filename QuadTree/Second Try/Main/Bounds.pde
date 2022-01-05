class Boundary
{
  PVector pos; 
  int w, h;
  Boundary(float x, float y, int w, int h)
  {
    this.pos = new PVector(x, y);
    this.w = w;
    this.h = h;
  }
  
  public boolean contains(Point point)
  {
    return (point.pos.x <= this.pos.x + w && point.pos.x >= this.pos.x - w) &&
           (point.pos.y >= this.pos.y - h && point.pos.y <= this.pos.y + h);
  }
  
  public boolean intersects(Boundary range)
  {
    return !(range.pos.x - range.w >= this.pos.x + this.w ||
       range.pos.x + range.w <= this.pos.x - this.w ||
       range.pos.y - range.h >= this.pos.y + this.h ||
       range.pos.y + range.h <= this.pos.y - this.h);
  }
}
