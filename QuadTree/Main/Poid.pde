class Poid
{
  int x, y;
  Poid(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
  
  public void show()
  {
    stroke(75);
    strokeWeight(10);
    point(this.x, this.y);
  }
}
