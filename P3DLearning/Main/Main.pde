import peasy.*;

PeasyCam cam;

ArrayList<Mover> mvrs;

int count = 150;

void setup() {
  size(600, 600, P3D);
  
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
    mvr.applyForce(mvr.alignment(mvrs, 60));
    mvr.applyForce(mvr.cohesion(mvrs, 85));
    mvr.applyForce(mvr.separation(mvrs, 55));
    mvr.update();
    mvr.show();
  }
}
