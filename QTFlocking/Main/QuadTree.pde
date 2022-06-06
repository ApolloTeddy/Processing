public static boolean validVector(float Fx, float Fy, float check) {
    return Fx*Fx + Fy*Fy <= check*check;
}

static class Square {
  // Represented as: x, y, h
  
  static boolean containsParticle(float sx, float sy, float h, Boid p) {
    if(abs(p.pos.x - sx) > h || abs(p.pos.y - sy) > h) return false;
    return true;
  }
  
  static boolean intersectsSquare(float x1, float y1, float h1, float x2, float y2, float h2) {
    if(abs(x1 - x2) > h1 + h2 || abs(y1 - y2) > h1 + h2) return false;
    
    return true;
  }
}

static class Circle {
  // Represented as: x, y, r
  
  static boolean containsParticle(float cx, float cy, float r, Boid p) {
    return validVector(cx - p.pos.x, cy - p.pos.y, r);
  }
  
  static boolean intersectsCircle(float x1, float y1, float r1, float x2, float y2, float r2) {
    return validVector(x1 - x2, y1 - y2, r1 + r2);
  }
  
  static boolean intersectsSquare(float x1, float y1, float r, float x2, float y2, float h) {
    float dx = abs(x2 - x1), dy = abs(y2 - y1);
    return validVector(max(dx - h, 0), max(dy - h, 0), r);
  }
}

class QuadTree {
  float Bx, By, H;
  int capacity, elementCount;
  Boid elements[];
  QuadTree subs[] = new QuadTree[4];
  
  
  QuadTree(float x, float y, float h, int cap) {
    elements = new Boid[cap];
    elementCount = 0;
    capacity = cap;
    Bx = x; By = y;
    H = h;
  }
  
  void buildTree(ArrayList<Boid> party) {
    reset();
    for(var member : party) insert(member);
  }
  
  void reset() {
    elements = new Boid[capacity];
    elementCount = 0;
    subs = new QuadTree[4];
  }
  
  Boid[] query(float x, float y, float r) {
    if(elementCount == 0 || !Circle.intersectsSquare(x, y, r, Bx, By, H)) return null;
    ArrayList<Boid> out = new ArrayList();
    
    for(int i = 0; i < elements.length; i++) 
      if(Circle.containsParticle(x, y, r, elements[i])) 
        out.add(elements[i]);
    
    if(subs[0] == null) return out.toArray(new Boid[out.size()]);
    
    for(var sub : subs) sub.query(x, y, r, out);
    
    return out.toArray(new Boid[out.size()]);
  }
  private void query(float x, float y, float r, ArrayList<Boid> out) {
    if(elementCount == 0 || !Circle.intersectsSquare(x, y, r, Bx, By, H)) return;
    
    for(int i = 0; i < elements.length; i++) 
      if(Circle.containsParticle(x, y, r, elements[i])) out.add(elements[i]);
  }
  
  boolean insert(Boid member) {
    if(!Square.containsParticle(Bx, By, H, member)) return false;
    
    if(elementCount < capacity && subs[0] == null) {
      elements[elementCount] = member;
      return true;
    }
    
    if(subs[0] == null) subdivide();
    
    for(var sub : subs) 
      if(sub.insert(member)) return true;
    
    return false;
  }
  
  void subdivide() {
    subs[0] = new QuadTree(Bx - H/2, By + H/2, H/2, capacity);
    subs[1] = new QuadTree(Bx + H/2, By + H/2, H/2, capacity);
    subs[2] = new QuadTree(Bx - H/2, By - H/2, H/2, capacity);
    subs[3] = new QuadTree(Bx + H/2, By - H/2, H/2, capacity);
    
    for(var ele : elements) {
      for(var sub : subs) {
        if(sub.insert(ele)) break;
      }
    }
    elements = null;
    elementCount = 0;
  }
}
