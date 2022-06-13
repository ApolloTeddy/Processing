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
