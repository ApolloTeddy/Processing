class Mover {
  PVector pos, vel, acc;
  float maxForce = 0.35;
  float maxSpeed = 9;
  // DESIRED = TARGET - POSITION
  // STEER = DESIRED - VELOCITY
  
  Mover() {
    this.pos = new PVector(random(width), random(height));
    this.vel = PVector.random2D();
    this.acc = new PVector(0, 0);
  }
  
  void update() {
    this.vel.add(this.acc);
    this.vel.limit(this.maxSpeed);
    this.pos.add(this.vel);
    this.acc.mult(0);
  }
  
  void edges() {
    if(this.pos.x + 5 > width) {
      this.pos.x = 5; println(1);
    } else if(this.pos.x - 5 < -5) {
      this.pos.x = width - 5; println(2);
    }
    if(this.pos.y + 5 > height) {
      this.pos.y = 5; println(3);
    } else if(this.pos.y - 5 < -5) {
      this.pos.y = height - 5; println(4);
    }
  }
  
  void show() {
    push();
    translate(this.pos.x, this.pos.y);
    PVector dir = this.vel.copy().setMag(10);
    line(0, 0, dir.x, dir.y);
    pop();
  }
  
  void applyForce(PVector force) {
    this.acc.add(force);
  }
  
  PVector seek(PVector trg) {
    PVector des, str;
    des = PVector.sub(trg, this.pos);
    des.setMag(maxSpeed);
    str = PVector.sub(des, this.vel);
    str.limit(maxForce);
    return str;
  }
  
  PVector cohesion(ArrayList<Mover> movers, float perception) {
    PVector avg = new PVector(0, 0);
    int total = 0;
    for(Mover mover : movers) {
      float dist = PVector.dist(this.pos, mover.pos);
      if(dist != 0 && dist <= perception) {
        avg.add(mover.pos);
        total++;
      }
    }
    if(total > 0) {
      avg.div(total);
      return this.seek(avg);
    } else {
      return new PVector(0, 0);
    }
  }
}
