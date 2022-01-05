class Segment
{
  PVector a;
  double len;
  double angle;
  double selfAngle;
  
  double xOff = random(1000);
  
  Segment par;
  
  PVector b;
  
  Segment(float x, float y, float len, float angle)
  {
    this.a = new PVector(x, y);
    this.len = len;
    this.angle = angle;
    this.selfAngle = angle;
    flushB();
    par = null;
  }
  Segment(Segment parent, float len, float angle)
  {
    par = parent;
    this.a = par.b.copy();
    this.len = len;
    this.angle = angle;
    flushB();
  }
  
  void wiggle()
  {
    selfAngle = map(noise((float)xOff), 0, 1, -1, 1);
    xOff += 0.001;
  }
  
  void update()
  {
    angle = selfAngle;
    if(par != null)
    {
      a = par.b.copy();
      angle += par.angle;
    }
    flushB();
  }
  
  void flushB()
  {
    float dx = (float)(len * cos((float)angle));
    float dy = (float)(len * sin((float)angle));
    b = new PVector(a.x + dx, a.y + dy);
  }
  
  void show()
  {
    push();
    stroke(255);
    strokeWeight(4);
    scale(0.5);
    line(a.x, a.y, b.x, b.y);
    pop();
  }
}

class Worm {
  ArrayList<Segment> segs;
  Worm(float x, float y) {
    segs = new ArrayList<Segment>();
    segs.add(new Segment(x, y, len, radians(-45)));
  }
  
  void addSeg() {
    segs.add(new Segment(segs.get(segs.size() - 1), len, radians(0)));
  }
  
  void show() {
    segs.forEach(seg -> {
      seg.wiggle();
      seg.update();
      seg.show();
    });
  }
}
