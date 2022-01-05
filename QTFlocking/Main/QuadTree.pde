class QuadTree {
  Rect bounds;
  int capacity;
  ArrayList<Boid> elements;
  QuadTree NW, NE, SW, SE;
  boolean divided = false;
  
  QuadTree(Rect boundary, int capacity) {
    this.bounds = boundary;
    this.capacity = capacity;
    this.elements = new ArrayList<Boid>();
  }
  
  void buildTree(Boid[] points) {
    this.clear();
    for(int i = 0; i < points.length; i++) {
      Boid point = points[i];
      this.insert(point);
    }
  }
  
  void setCapacity(int newCapacity) {
    if(newCapacity != this.capacity) {
      this.capacity = newCapacity;
    }
  }
  
  void clear() {
    this.elements.clear();
    this.NW = null;
    this.NE = null;
    this.SW = null;
    this.SE = null;
    this.divided = false;
  }
  
  Boid[] query(Circle range) {
    ArrayList<Boid> found = new ArrayList<Boid>();
    if(!this.bounds.intersectsCircle(range)) {
        return null;
    } else {
        if(this.divided) {
            this.NW.query(range, found);
            this.NE.query(range, found);
            this.SW.query(range, found);
            this.SE.query(range, found);
        } else {
            for(int i = 0; i < this.elements.size(); i++) {
                Boid p = this.elements.get(i);
                if(range.contains(p)) {
                    found.add(p);
                }
            }
        }
    }

    return found.toArray(new Boid[found.size()]);
  }
  
  ArrayList<Boid> query(Circle range, ArrayList<Boid> found) {
    if(!this.bounds.intersects(new Rect(range.x, range.y, range.r, range.r))) {
        return null;
    } else {
        if(this.divided) {
            this.NW.query(range, found);
            this.NE.query(range, found);
            this.SW.query(range, found);
            this.SE.query(range, found);
        } else {
            for(int i = 0; i < this.elements.size(); i++) {
                Boid p = this.elements.get(i);
                if(range.contains(p)) {
                    found.add(p);
                }
            }
        }
    }

    return found;
  }
  
  void show() {
    this.bounds.show();
    if(this.divided) {
        this.NW.show();
        this.NE.show();
        this.SW.show();
        this.SE.show();
    }
  }
  
  void subdivide() {
    float x = this.bounds.x, y = this.bounds.y, w = this.bounds.w, h = this.bounds.h;
    Rect NW = new Rect(x - w / 2, y - h / 2, w / 2, h / 2);
    this.NW = new QuadTree(NW, this.capacity);
    Rect NE = new Rect(x + w / 2, y - h / 2, w / 2, h / 2);
    this.NE = new QuadTree(NE, this.capacity);
    Rect SW = new Rect(x - w / 2, y + h / 2, w / 2, h / 2);
    this.SW = new QuadTree(SW, this.capacity);
    Rect SE = new Rect(x + w / 2, y + h / 2, w / 2, h / 2);
    this.SE = new QuadTree(SE, this.capacity);
    this.divided = true;
  }
  
  boolean insert(Boid point) {
    if(!this.bounds.contains(point)) {
        return false;
    }

    if(this.divided) {
        if(this.NW.insert(point)) {
            return true;
        } else if(this.NE.insert(point)) {
            return true;
        } else if(this.SW.insert(point)) {
            return true;
        } else if(this.SE.insert(point)) {
            return true;
        }
    } else {
        this.elements.add(point);
        if(this.elements.size() > this.capacity) {
            this.subdivide();
            for(int i = 0; i < this.elements.size(); i++) {
                Boid pnt = this.elements.get(i);
                if(this.NW.insert(pnt)) {
                    continue;
                } else if(this.NE.insert(pnt)) {
                    continue;
                } else if(this.SW.insert(pnt)) {
                    continue;
                } else if(this.SE.insert(pnt)) {
                    continue;
                }
            }
            this.elements.clear();
            return true;
        }
    }
    return false;
  }
}

class Circle {
  float x, y, r;
  Circle(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
  }
  
  boolean contains(Boid point) {
    float dx = abs(point.pos.x - this.x);
    if(dx > this.r) {
        return false;
    }
    float dy = abs(point.pos.y - this.y);
    if(dy > this.r) {
        return false;
    }
    if(dx + dy <= this.r) {
        return true;
    }
    return (dx*dx) + (dy*dy) <= (this.r * this.r);
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
  
  boolean intersectsCircle(Circle circle) {
    PVector circleDistance = new PVector();
    
    circleDistance.x = abs(circle.x - this.x);
    if (circleDistance.x > (this.w/2 + circle.r)) { return false; }
    
    circleDistance.y = abs(circle.y - this.y);
    if (circleDistance.y > (this.h /2 + circle.r)) { return false; }

    if (circleDistance.x <= (this.w/2)) { return true; } 
    if (circleDistance.y <= (this.h/2)) { return true; }

    float cornerDistance_sq = sq((circleDistance.x - this.w / 2)) +
                         sq((circleDistance.y - this.h / 2));

    return (cornerDistance_sq <= (sq(circle.r)));
  }
  
  boolean contains(Boid point) {
    return !(abs(point.pos.x - this.x) > this.w ||
             abs(point.pos.y - this.y) > this.h);
  }
  
  boolean intersects(Rect other) {
    return !(abs(this.x - other.x) > this.w + other.w || 
             abs(this.y - other.y) > this.h + other.h);
  }
  
  void show() {
    push();
    stroke(30);
    rectMode(RADIUS);
    translate(this.x, this.y);
    rect(0, 0, this.w, this.h);
    pop();
  }
}
