float inc = 0.2;
float scale = 10;
int cols, rows;

float zoff = 0;

ArrayList<Particle> particles = new ArrayList<Particle>();

ArrayList<PVector> flowfield;

void setup() {
  size(300, 300);
  smooth();
  cols = floor(width / scale);
  rows = floor(height / scale);
  flowfield = new ArrayList<PVector>();
  for(int i = 0; i < cols * rows; i++) flowfield.add(new PVector(0, 0));
  for(int i = 0; i < 1000; i++) {
    particles.add(new Particle());
  }
}

void draw() {
  background(100);
  strokeWeight(1);
  float yoff = 0;
  for(int y = 0; y < rows; y++) {
    float xoff = 0;
    for(int x = 0; x < cols; x++) {
      var ind = x + y * cols;
      var angle = noise(xoff, yoff, zoff) * TAU;
      var v = PVector.fromAngle(angle);
      flowfield.set(ind, v);
      xoff += inc;
      stroke(80);
      push();
      translate(x * scale, y * scale);
      rotate(v.heading());
      //line(0, 0, scale, 0);
      pop();
    }
    yoff += inc;
  } zoff += 0.01;
  particles.forEach(p -> {
    if(flowfield.size() != 0) p.follow(flowfield);
    p.applyForce(PVector.sub(p.pos, new PVector(mouseX, mouseY)).setMag(0.5));
    p.update();
    p.edges();
    p.show();
  });
  println("\n\n\n", floor(frameRate));
}
