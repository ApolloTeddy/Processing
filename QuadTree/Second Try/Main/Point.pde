class Point
{
  PVector pos;
  int stroke = 0;
  
  Point(int x, int y)
  {
    this.pos = new PVector(x, y);
  }
  
  public void setStroke(int stroke)
  {
    if(stroke > 0)
    {
      this.stroke = stroke;
    }
  }
  
  public void show()
  {
    stroke(stroke);
    strokeWeight(10);
    point(this.pos.x, this.pos.y);
  }
}
