class QTree
{
  Rectangle bounds;
  int capacity;
  ArrayList<Poid> points;
  QTree NW, NE, SW, SE;
  boolean divided;
  
  QTree(Rectangle bounds, int capacity)
  {
    this.bounds = bounds;
    this.capacity = capacity;
    this.points = new ArrayList<Poid>();
    this.divided = false;
    
  }
  
  public void show()
  {
    stroke(75);
    strokeWeight(3);
    rectMode(CENTER);
    noFill();
    rect(this.bounds.x, this.bounds.y, this.bounds.w * 2, this.bounds.h * 2);
    if(this.divided)
    {
      this.NW.show();
      this.NE.show();
      this.SW.show();
      this.SE.show();
    }
  }
  
  public void insert(Poid poid)
  {
    if(!this.bounds.contains(poid))
    {
      return;
    }
    if(this.points.size() < this.capacity)
    {
      this.points.add(poid);
    }
    else
    {
      if(!this.divided)
      {
        this.subdivide();
      }
      this.NW.insert(poid);
      this.NE.insert(poid);
      this.SW.insert(poid);
      this.SE.insert(poid);
    }
  }
  
  void subdivide()
  {
    int x = this.bounds.x, y = this.bounds.y, w = this.bounds.w, h = this.bounds.h;
    var NW = new Rectangle(x - w / 2, y - h / 2, w / 2, h / 2);
    this.NW = new QTree(NW, this.capacity);
    for(int i = 0; i < this.points.size(); i++) this.NW.insert(this.points.get(i));
    var NE = new Rectangle(x + w / 2, y - h / 2, w / 2, h / 2);
    this.NE = new QTree(NE, this.capacity);
    for(int i = 0; i < this.points.size(); i++) this.NE.insert(this.points.get(i));
    var SW = new Rectangle(x - w / 2, y + h / 2, w / 2, h / 2);
    this.SW = new QTree(SW, this.capacity);
    for(int i = 0; i < this.points.size(); i++) this.SW.insert(this.points.get(i));
    var SE = new Rectangle(x + w / 2, y + h / 2, w / 2, h / 2);
    this.SE = new QTree(SE, this.capacity);
    for(int i = 0; i < this.points.size(); i++) this.SE.insert(this.points.get(i));
    this.divided = true;
  }
}

class Rectangle
{
  int x, y, w, h;
  Rectangle(int x, int y, int w, int h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  public boolean contains(Poid poid)
  {
    return (poid.x > poid.x - w &&
            poid.x < poid.x + w) &&
           (poid.y > poid.y - h &&
            poid.y < poid.y + h);
  }
}
