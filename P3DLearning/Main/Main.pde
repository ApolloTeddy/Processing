import peasy.*;

PeasyCam cam;

ArrayList<Mover> mvrs;

int count = 550;

void setup() {
  size(900, 900, P3D);
  
  stroke(30);
  strokeWeight(2);
  noFill();
  
  cam = new PeasyCam(this, 100);
  mvrs = new ArrayList<Mover>();
  
  for(int i = 0; i < count; i++) {
    mvrs.add(new Mover());
  }
}

void draw() {
  background(100);
  box(width, height, width);
  for(Mover mvr : mvrs) {
    mvr.applyForce(mvr.alignment(mvrs, 60).mult(.9));
    mvr.applyForce(mvr.cohesion(mvrs, 85).mult(.9));
    mvr.applyForce(mvr.separation(mvrs, 55).mult(1.45));
    mvr.update();
    mvr.show();
  }
}
