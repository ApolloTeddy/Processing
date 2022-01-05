QTree qTree;
ArrayList<Point> points;
Boundary looker;

int initialPoints = 350;

void setup()
{
  size(1000, 1000);
  looker = new Boundary(0, 0, width / 4, height / 4);
  Boundary bounds = new Boundary(width / 2, height / 2, width / 2, height / 2);
  qTree = new QTree(bounds, 2);
  points = new ArrayList<Point>();
  for(int i = 0; i < initialPoints; i++)
  {
    Point newPoint = new Point(int(random(width)), int(random(height)));
    points.add(newPoint);
    qTree.insert(newPoint);
  }
}

void draw()
{
  background(111);
  qTree.show();
  for(Point point : points)
  {
    point.setStroke(0);
    point.show();
  }
  if(mouseButton == LEFT)
  {
    looker.pos.x = mouseX;
    looker.pos.y = mouseY;
    for(Point point : qTree.query(looker))
    {
      point.setStroke(50);
      point.show();
    }
  }
  noFill();
  rectMode(CENTER);
  rect(looker.pos.x, looker.pos.y, looker.w * 2, looker.h * 2);
}

//void mousePressed()
//{
//  if(mouseButton == LEFT)
//  {
//    Point newPoint = new Point(mouseX, mouseY);
//    points.add(newPoint);
//    qTree.insert(newPoint);
//  }
//  if(mouseButton == RIGHT)
//  {
//    looker.pos.x = mouseX;
//    looker.pos.y = mouseY;
//    for(Point point : qTree.query(looker))
//    {
//      point.setStroke(50);
//    }
//  }
//}
