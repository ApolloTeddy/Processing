QuadTree qTree;
ArrayList<Point> pnts = new ArrayList<Point>();
Rect search = new Rect(0, 0, 50, 50);

void setup() {
  size(600, 600);
  strokeWeight(2);
  Rect boundary = new Rect(width / 2, height / 2, width / 2, height / 2);
  qTree = new QuadTree(boundary, 10);
  for(int i = 0; i < 10000; i++) {
    qTree.insert(new Point(random(width), random(height)));
  }
  rectMode(RADIUS);
  noFill();
}

ArrayList<Point> withinSearch = new ArrayList<Point>();

void draw() {
  background(100);
  search.x = mouseX; search.y = mouseY;
  withinSearch = qTree.query(search);
  stroke(90);
  qTree.show();
  stroke(0);
  search.show();
  stroke(0, 100, 0);
  int s = withinSearch.size();
  for(int i = 0; i < s; i++) {
    Point cur = withinSearch.get(i);
    cur.show();
  }
  text(int(frameRate), 10, 20);
}

void mousePressed() {
  if(mouseButton == LEFT) {
    Point newPoint = new Point(mouseX, mouseY);
    qTree.insert(newPoint);
    pnts.add(newPoint);
  }
}
