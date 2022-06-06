Flock flock;


void setup() {
  size(800, 800);
  noFill();
  flock = new Flock();
  flock.flockSize(1050);
}

void draw() {
  background(100);
  flock.flock(46, 0.9, 50, 1.45, 55, 0.9);
}
