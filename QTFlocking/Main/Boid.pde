class Boid {
  PVector pos, vel, acc;

  float maxspeed = 2;
  float maxforce = 0.035;
  int r = 5;

  Boid() {
    this.pos = new PVector(random(width), random(height));
    this.vel = PVector.random2D();
    this.acc = new PVector();
  }

  void applyForce(PVector force) {
    this.acc.add(force);
  }

  void show() {
    push();
    translate(this.pos.x, this.pos.y);
    rotate(this.vel.heading() - 1.5708);
    strokeWeight(0.5);
    triangle(this.r / 2, 0, -this.r / 2, 0, 0, this.r * 2);
    pop();
  }

  void update() {
    this.vel.add(this.acc);
    this.vel.limit(this.maxspeed);
    this.pos.add(this.vel);
    this.acc.mult(0);

    if (this.pos.x > width + this.r) {
      this.pos.x = 0;
    } else if (this.pos.x < -this.r) {
      this.pos.x = width;
    }
    if (this.pos.y > height + this.r) {
      this.pos.y = 0;
    } else if (this.pos.y < -this.r) {
      this.pos.y = height;
    }
  }

  void run() {
    this.update();
    this.show();
  }

  PVector cohesion(Boid[] mvrs) {
    PVector avg = new PVector(); //<>//
    int total = 0;

    
    for(int i = 0; i < mvrs.length; i++) {
      Boid mvr = mvrs[i];
      if (mvr != this) {
        avg.add(mvr.pos);
        total++;
      }
    }
    if (total > 0) {
      avg.div(total);
      avg.sub(this.pos);
      avg.setMag(this.maxspeed);
      avg.sub(this.vel);
      avg.limit(this.maxforce);
      return avg;
    } else {
      return new PVector();
    }
  }

  PVector alignment(Boid[] mvrs) {
    PVector heading = new PVector();

    for (int i = 0; i < mvrs.length; i++) {
      Boid mvr = mvrs[i];
      if (mvr != this) {
        heading.add(mvr.vel);
      }
    }
    if(mvrs.length > 1) {
      heading.setMag(this.maxspeed);
      heading.sub(this.vel);
      heading.limit(this.maxforce);
      return heading;
    } else {
      return new PVector();
    }
  }
  
  PVector separation(Boid[] mvrs) {
    PVector avg = new PVector();
    
    for (int i = 0; i < mvrs.length; i++) { //<>//
      Boid mvr = mvrs[i];
      float dist = PVector.dist(this.pos, mvr.pos);
      if (dist > 0) {
        PVector diff = PVector.sub(this.pos, mvr.pos);
        diff.normalize();
        diff.div(sq(dist));
        avg.add(diff);
      }
    }
    if(mvrs.length > 1) {
      avg.setMag(this.maxspeed);
      avg.sub(this.vel);
      avg.limit(this.maxforce);
      return avg;
    } else {
      return new PVector();
    }
  }
  
  void flock(QuadTree qTree, float cP, float cS, float sP, float sS, float aP, float aS) {
    Boid[] cMvrs = qTree.query(new Circle(this.pos.x, this.pos.y, cP));
    Boid[] sMvrs = qTree.query(new Circle(this.pos.x, this.pos.y, sP));
    Boid[] aMvrs = qTree.query(new Circle(this.pos.x, this.pos.y, aP));
    
    PVector coh = new PVector(), sep = new PVector(), ali = new PVector();
    
    if(cMvrs != null) coh = this.cohesion(cMvrs).mult(cS);
    if(sMvrs != null) sep = this.separation(sMvrs).mult(sS);
    if(aMvrs != null) ali = this.alignment(aMvrs).mult(aS);

    this.applyForce(coh);
    this.applyForce(sep);
    this.applyForce(ali);
  }
}
