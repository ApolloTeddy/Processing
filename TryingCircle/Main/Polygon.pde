class Polygon {
  int vertices = 3;
  float radius;
  PVector pos;

  Polygon(float x, float y, float r, int v) {
    this.pos = new PVector(x, y);
    this.radius = r;
    this.vertices = v;
  }

  void show() {
    PVector dir = PVector.sub(new PVector(mouseX, mouseY), pos);
    push();
    translate(pos.x, pos.y);
    rotate(dir.heading());
    beginShape();
    float inc = TAU / vertices;
    for (float i = 0; i < TAU; i += inc) {
      vertex(cos(i) * radius, sin(i) * radius);
    }
    endShape();
    pop();
  }

  boolean isIntersectingOther(ArrayList<Polygon> p) {
    for (Polygon s : p) {
      if (sq(pos.x - s.pos.x) + sq(pos.y - s.pos.y) < sq(radius + s.radius)) {
        return true;
      }
    }
    return false;
  }
}
