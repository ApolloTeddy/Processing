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
    acc.add(force);
  }
  void applyForces(PVector... forces) {
    for(var force : forces) acc.add(force);
  }

  void show() {
    push();
    translate(pos.x, pos.y);
    rotate(vel.heading() - 1.5708);
    strokeWeight(0.5);
    triangle(r/2, 0, -r/2, 0, 0, r*2);
    pop();
  }

  void update() {
    vel.add(acc);
    vel.limit(maxspeed);
    pos.add(vel);
    acc.mult(0);

    if (pos.x > width + r) {
      pos.x = 0;
    } else if (pos.x < -r) {
      pos.x = width;
    }
    if (pos.y > height + r) {
      pos.y = 0;
    } else if (pos.y < -r) {
      pos.y = height;
    }
  }

  void run() {
    update();
    show();
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
      avg.sub(pos);
      avg.setMag(maxspeed);
      avg.sub(vel);
      avg.limit(maxforce);
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
      heading.setMag(maxspeed);
      heading.sub(vel);
      heading.limit(maxforce);
      return heading;
    } else {
      return new PVector();
    }
  }
  
  PVector separation(Boid[] mvrs) {
    PVector avg = new PVector();
    
    for (int i = 0; i < mvrs.length; i++) { //<>//
      Boid mvr = mvrs[i];
      float sqdist = sq(pos.x - mvr.pos.x) + sq(pos.y - mvr.pos.y);
      if (sqdist > 0) {
        PVector diff = PVector.sub(pos, mvr.pos);
        
        diff.div(sq(sqdist));
        avg.add(diff);
      }
    }
    if(mvrs.length > 1) {
      avg.setMag(maxspeed);
      avg.sub(vel);
      avg.limit(maxforce);
      return avg;
    } else {
      return new PVector();
    }
  }
  
  void flock(QuadTree qTree, float cP, float cS, float sP, float sS, float aP, float aS) {
    Boid[] cMvrs = qTree.query(pos.x, pos.y, cP);
    Boid[] sMvrs = qTree.query(pos.x, pos.y, sP);
    Boid[] aMvrs = qTree.query(pos.x, pos.y, aP);
    
    PVector coh = new PVector(), sep = new PVector(), ali = new PVector();
    
    if(cMvrs != null) coh = cohesion(cMvrs).mult(cS);
    if(sMvrs != null) sep = separation(sMvrs).mult(sS);
    if(aMvrs != null) ali = alignment(aMvrs).mult(aS);

    applyForces(coh, sep, ali);
  }
}
