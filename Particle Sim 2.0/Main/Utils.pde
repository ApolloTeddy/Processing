import java.util.Arrays;

public static boolean validVector(float Fx, float Fy, float check) {
    return Fx*Fx + Fy*Fy <= check*check;
}

public static float setMagCoef(float x, float y, float mag) {
  return invSqrt(x*x + y*y) * mag;
}

// public static boolean withinBound

public float rvar(float x) {
  return random(-x, x);
}

public float rbou(float min, float max) {
  return random(min, max);
}

public static float invSqrt(float x) {
    float xhalf = 0.5f * x;
    int i = Float.floatToIntBits(x);
    
    i = 0x5f3759df - (i >> 1);
    x = Float.intBitsToFloat(i);
    
    x *= (1.5f - xhalf * x * x);
    
    return x;
}

enum P_STATES {
  ALIVE,
  RESPAWNING,
  DELETE
}

class PQTree {
  int capacity, elementCount;
  float Bx, By, H;
  ArrayList<Particle> elements;
  PQTree[] subs = new PQTree[4];
  
  PQTree(float x, float y, float h, int cap) {
    elements = new ArrayList(cap);
    elementCount = 0;
    Bx = x; By = y;
    H = h;
    
    capacity = cap;
  }
  
  void buildTree(ArrayList<Particle> members) {
    reset();
    for(var p : members) insert(p);
  }
  
  void reset() {
    elements = new ArrayList();
    elementCount = 0;
    subs = new PQTree[4];
  }
  
  void show() {
    square(Bx, By, H);
    
    if(subs[0] != null) for(var sub : subs) sub.show();
  }
  
  boolean insert(Particle p) {
    if(!Square.containsParticle(Bx, By, H, p)) return false;
    
    boolean c1 = subs[0] == null, c2 = H > 0.1;
    if(c1 && c2 && elementCount < capacity) {
      elements.add(p);
      elementCount++;
      return true;
    }
    
    if(c1 && !c2) {
      elements.add(p);
      elementCount++;
      return true;
    }
    
    if(c1) subdivide();
    
    int i = 0;
    while(!subs[i].insert(p)) {
      i++;
      if(i > 3) return false;
    }
    return true;
  }
  
  Particle[] queryRadius(float x, float y, float r) {
    ArrayList<Particle> out = new ArrayList();
    
    if(!Circle.intersectsSquare(x, y, r, Bx, By, H)) return out.toArray(new Particle[out.size()]);
    
    if(subs[0] != null) {
      for(var sub : subs) out.addAll(Arrays.asList(sub.queryRadius(x, y, r)));
      return out.toArray(new Particle[out.size()]);
    }
    
    for(var ele : elements) if(ele != null && Circle.containsParticle(x, y, r, ele)) out.add(ele);
    return out.toArray(new Particle[out.size()]);
  }
  
  void subdivide() {
    subs[0] = new PQTree(Bx - H/2, By + H/2, H/2, capacity);
    subs[1] = new PQTree(Bx + H/2, By + H/2, H/2, capacity);
    subs[2] = new PQTree(Bx - H/2, By - H/2, H/2, capacity);
    subs[3] = new PQTree(Bx + H/2, By - H/2, H/2, capacity);
    
    for(var ele : elements) {
      int i = 0;
      while(i < 4 && !subs[i].insert(ele)) i++;
    }
    elements = null;
    elementCount = 0;
  }
}

static class Square {
  // Represented as: x, y, h
  
  static boolean containsParticle(float sx, float sy, float h, Particle p) {
    if(abs(p.x - sx) > h || abs(p.y - sy) > h) return false;
    return true;
  }
  
  static boolean intersectsSquare(float x1, float y1, float h1, float x2, float y2, float h2) {
    if(abs(x1 - x2) > h1 + h2 || abs(y1 - y2) > h1 + h2) return false;
    
    return true;
  }
}

static class Circle {
  // Represented as: x, y, r
  
  static boolean containsParticle(float cx, float cy, float r, Particle p) {
    return validVector(cx - p.x, cy - p.y, r);
  }
  
  static boolean intersectsCircle(float x1, float y1, float r1, float x2, float y2, float r2) {
    return validVector(x1 - x2, y1 - y2, r1 + r2);
  }
  
  static boolean intersectsSquare(float x1, float y1, float r, float x2, float y2, float h) {
    float dx = abs(x2 - x1), dy = abs(y2 - y1);
    return validVector(max(dx - h, 0), max(dy - h, 0), r);
  }
}
