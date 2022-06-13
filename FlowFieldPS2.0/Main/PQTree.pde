class PQTree {
  int capacity, elementCount, maxDepth, depth;
  float Bx, By, H;
  ArrayList<Particle> elements;
  PQTree[] subs = new PQTree[4];
  
  PQTree(float x, float y, float h, int cap, int maxDep) {
    elements = new ArrayList(cap);
    elementCount = 0;
    Bx = x; By = y;
    H = h;
    maxDepth = maxDep;
    depth = 0;
    
    capacity = cap;
  }
  PQTree(PQTree parent, float x, float y, float h) {
    elementCount = 0;
    Bx = x; By = y;
    H = h;
    
    maxDepth = parent.maxDepth;
    this.depth = parent.depth + 1;
    capacity = parent.capacity;
    elements = new ArrayList(capacity);
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
    
    boolean c1 = subs[0] == null, c2 = depth < maxDepth;
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
    float hh = H/2;
    subs[0] = new PQTree(this, Bx - hh, By + hh, hh);
    subs[1] = new PQTree(this, Bx + hh, By + hh, hh);
    subs[2] = new PQTree(this, Bx - hh, By - hh, hh);
    subs[3] = new PQTree(this, Bx + hh, By - hh, hh);
    
    for(var ele : elements) {
      int i = 0;
      while(i < 4 && !subs[i].insert(ele)) i++;
    }
    elements = null;
    elementCount = 0;
  }
}
