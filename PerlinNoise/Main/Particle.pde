class Particle {
  PVector pos = new PVector(random(width), random(height));
  PVector vel = PVector.random2D();
  PVector acc = new PVector(0, 0);
  float maxSpeed = 2;
  
  void update() {
    this.vel.add(this.acc);
    this.vel.mult(map(this.acc.mag(), 0.1, 10, 0.5, 0.9));
    this.pos.add(this.vel);
    this.acc.mult(0);
  }
  
  void applyForce(PVector force) {
    this.acc.add(force);
  }
  
  void edges() {
    if(this.pos.x > width) {
      this.pos.x = 0;
    }
    if(this.pos.x < 0) {
      this.pos.x = width;
    }
    if(this.pos.y > height) {
      this.pos.y = 0;
    }
    if(this.pos.y < 0) {
      this.pos.y = height;
    }
  }
  
  void show() {
    stroke(0);
    strokeWeight(2);
    point(this.pos.x, this.pos.y);
  }
  
  void follow(ArrayList<PVector> field) {
    var x = floor(this.pos.x / scale);
    var y = floor(this.pos.y / scale);
    var ind = x + y * cols;
    PVector force;
    if(ind > 899) force = field.get(899); else force = field.get(ind);
    this.applyForce(force);
  }
}
