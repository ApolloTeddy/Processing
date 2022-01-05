class QTree
{
  Boundary bounds;
  int capacity;
  ArrayList<Point> points;
  boolean divided = false;
  QTree NW, NE, SW, SE;
  
  QTree(Boundary bounds, int capacity)
  {
    this.bounds = bounds;
    this.capacity = capacity;
    this.points = new ArrayList<Point>();
  }
  
  public boolean insert(Point point)
  {
    if(!this.bounds.contains(point)) 
    {
      return false;
    }
    
    if(this.points.size() < this.capacity)
    {
      this.points.add(point);
      return true;
    }
    else
    {
      if(!divided) 
      {
        this.subdivide();
      }
      
      if(this.NW.insert(point))
      {
        return true;
      }
      else if(this.NE.insert(point))
      {
        return true;
      }
      else if(this.SW.insert(point))
      {
        return true;
      }
      else if(this.SE.insert(point))
      {
        return true;
      }
      
      return false;
    }
  }
  
  public int size()
  {
    return this.points.size();
  }
  
  void subdivide()
  {
    float x = this.bounds.pos.x, y = this.bounds.pos.y;
    int w = this.bounds.w, h = this.bounds.h;
    Boundary NW = new Boundary(x - w / 2, y + h / 2, w / 2, h / 2);
    this.NW = new QTree(NW, this.capacity);
    Boundary NE = new Boundary(x + w / 2, y + h / 2, w / 2, h / 2);
    this.NE = new QTree(NE, this.capacity);
    Boundary SW = new Boundary(x - w / 2, y - h / 2, w / 2, h / 2);
    this.SW = new QTree(SW, this.capacity);
    Boundary SE = new Boundary(x + w / 2, y - h / 2, w / 2, h / 2);
    this.SE = new QTree(SE, this.capacity);
    this.divided = true;
    for(Point point : points)
    {
      this.NW.insert(point);
      this.NE.insert(point);
      this.SW.insert(point);
      this.SE.insert(point);
    }
  }
  
  public void show()
  {
    rectMode(CENTER);
    stroke(100);
    strokeWeight(1);
    noFill();
    rect(this.bounds.pos.x, this.bounds.pos.y, this.bounds.w * 2, this.bounds.h * 2);
    if(this.divided)
    {
      this.NW.show();
      this.NE.show();
      this.SW.show();
      this.SE.show();
    }
  }
  
  public ArrayList<Point> query(Boundary range)
  {
    ArrayList<Point> found = new ArrayList<Point>();
    
    if(!this.bounds.intersects(range))
    {
      return null;
    }
    else
    {
      for(Point p : this.points)
      {
        if(range.contains(p))
        {
          found.add(p);
        }
      }
      if(this.divided)
      {
        if(this.NW.bounds.intersects(range)) 
        {
          found.addAll(this.NW.query(range));
        }
        if(this.NE.bounds.intersects(range)) 
        {
          found.addAll(this.NE.query(range));
        }
        if(this.SW.bounds.intersects(range)) 
        {
          found.addAll(this.SW.query(range));
        }
        if(this.SE.bounds.intersects(range)) 
        {
          found.addAll(this.SE.query(range));
        }
      }
    }

    return found;
  }
  
  public boolean contains(Point point)
  {
    float x = this.bounds.pos.x, y = this.bounds.pos.y;
    int w = this.bounds.w, h = this.bounds.h;
    return (point.pos.x <= x + w && point.pos.x >= x - w) &&
           (point.pos.y >= y - h && point.pos.y <= y + h);
  }
}
