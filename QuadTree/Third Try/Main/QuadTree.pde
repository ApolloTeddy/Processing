class QuadTree {
  int capacity;
  ArrayList<Point> points;
  Rect bounds;
  QuadTree TL, TR, BL, BR;
  boolean divided = false;

  QuadTree(Rect boundary, int capacity) {
    this.bounds = boundary;
    this.capacity = capacity;
    this.points = new ArrayList<Point>();
  }

  void show() {
    bounds.show();
    if (divided) {
      TL.show();
      TR.show();
      BL.show();
      BR.show();
    }
  }

  void subdivide() {
    float x = this.bounds.x, y = this.bounds.y, w = this.bounds.w, h = this.bounds.h;
    Rect TLb = new Rect(x - w / 2, y - h / 2, w / 2, h / 2);
    TL = new QuadTree(TLb, capacity);
    Rect TRb = new Rect(x + w / 2, y - h / 2, w / 2, h / 2);
    TR = new QuadTree(TRb, capacity);
    Rect BLb = new Rect(x - w / 2, y + h / 2, w / 2, h / 2);
    BL = new QuadTree(BLb, capacity);
    Rect BRb = new Rect(x + w / 2, y + h / 2, w / 2, h / 2);
    BR = new QuadTree(BRb, capacity);
    divided = true;
  }

  ArrayList<Point> query(Rect range) {
    if (!bounds.intersects(range)) {
      return null;
    }
    ArrayList<Point> found = new ArrayList<Point>();
    if (divided) {
      TL.query(range, found);
      TR.query(range, found);
      BL.query(range, found);
      BR.query(range, found);
    } else {
      for (int i = 0; i < points.size(); i++) {
        Point p = points.get(i);
        if (range.contains(p)) {
          found.add(p);
        }
      }
    }
    return found;
  }
  ArrayList<Point> query(Rect range, ArrayList<Point> found) {
    if (!bounds.intersects(range)) {
      return null;
    } else {
      if (divided) {
        TL.query(range, found);
        TR.query(range, found);
        BL.query(range, found);
        BR.query(range, found);
      } else {
        for (int i = 0; i < points.size(); i++) {
          Point p = points.get(i);
          if (range.contains(p)) {
            found.add(p);
          }
        }
      }
    }
    return found;
  }

  boolean insert(Point newPoint) {
    if (!bounds.contains(newPoint)) {
      return false;
    }

    if (divided) {
      if (TL.insert(newPoint)) {
        return true;
      } else if (TR.insert(newPoint)) {
        return true;
      } else if (BL.insert(newPoint)) {
        return true;
      } else if (BR.insert(newPoint)) {
        return true;
      }
    } else {
      points.add(newPoint);
      if (points.size() > capacity) {
        subdivide();
        for (int i = 0; i < points.size(); i++) {
          Point pnt = points.get(i);
          if (TL.insert(pnt)) {
            continue;
          } else if (TR.insert(pnt)) {
            continue;
          } else if (BL.insert(pnt)) {
            continue;
          } else if (BR.insert(pnt)) {
            continue;
          }
        }
        points.clear();
        return true;
      }
    }
    return false;
  }
}

class Rect {
  float x, y, w, h;
  Rect(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void show() {
    pushMatrix();
    translate(x, y);
    stroke(90);
    rect(0, 0, w, h);
    popMatrix();
  }

  boolean contains(Point p) {
    return !(abs(p.x - x) > w ||
      abs(p.y - y) > h);
  }

  boolean intersects(Rect r) {
    return !(abs(x - r.x) > w + r.w ||
      abs(y - r.y) > h + r.h);
  }
}
