ArrayList<Mover> mvrs;

void setup() {
  size(600, 600);
  strokeWeight(2);
  stroke(30);
  fill(80);
  mvrs = new ArrayList<Mover>();
  
  for(int i = 0; i < 50; i++) {
    mvrs.add(new Mover());
  }
}

void draw() {
  background(111);
  
  mvrs.forEach(mvr -> {
    mvr.applyForce(mvr.cohesion(mvrs, 100));
    mvr.applyForce(mvr.seek(new PVector(mouseX, mouseY)));
    mvr.update();
    mvr.edges(); 
    mvr.show();
  });
}
