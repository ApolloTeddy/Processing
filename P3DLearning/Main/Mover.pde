class Mover {
  PVector pos, vel, acc;
  
  float maxspeed = 12, maxforce = .35;
  
  Mover() {
    this.pos = new PVector(random(-width/2, width/2),
                           random(-height/2, height/2),
                           random(-width/2, width/2));
    this.vel = PVector.random3D();
    this.acc = new PVector(0, 0, 0);
  }
  
  void show() {
    push();
    stroke(#DE6FF0);
    strokeWeight(map(this.vel.mag(), maxspeed, 0.1, 4, 0.5));
    
    translate(this.pos.x, this.pos.y, this.pos.z);
    PVector tmp = this.vel.copy().mult(5).limit(this.maxspeed*5);
    line(0, 0, 0, tmp.x, 
                  tmp.y, 
                  tmp.z);
    pop();
  }
  
  void update() {
    this.vel.add(this.acc);
    this.vel.limit(this.maxspeed);
    this.pos.add(this.vel);
    this.acc.mult(0);
    
    if(this.pos.x > width/2 + 5) {
      this.pos.x = -width/2;
    } else if(this.pos.x < -width/2 - 5) {
      this.pos.x = width/2;
    }
    if(this.pos.y > height/2 + 5) {
      this.pos.y = -height/2;
    } else if(this.pos.y < -height/2 - 5) {
      this.pos.y = height/2;
    }
    if(this.pos.z > width/2 + 5) {
      this.pos.z = -width/2;
    } else if(this.pos.z < -width/2 - 5) {
      this.pos.z = width/2;
    }
  }
  
  void applyForce(PVector force) {
    this.acc.add(force);
  }
  
  PVector seek(PVector target) {
    target.sub(this.pos);
    target.setMag(this.maxspeed);
    target.sub(this.vel);
    target.limit(this.maxforce);
    
    return target;
  }
  
  PVector separation(ArrayList<Mover> mvrs, float perc) {
    PVector avg = new PVector();
    int total = 0;
    
    for(Mover mvr : mvrs) {
      float dist = PVector.dist(this.pos, mvr.pos);
      if(mvr != this && dist < perc) {
        PVector towards = PVector.sub(this.pos, mvr.pos);
        towards.normalize();
        towards.div(dist);
        avg.add(towards);
        total++;
      }
    }
    
    if(total > 0) {
      avg.setMag(this.maxspeed);
      avg.sub(this.vel);
      avg.limit(this.maxforce);
      return avg;
    } else {
      return new PVector();
    }
  }
  
  PVector alignment(ArrayList<Mover> mvrs, float perc) {
    PVector avg = new PVector();
    int total = 0;
    
    for(Mover mvr : mvrs) {
      float dist = PVector.dist(this.pos, mvr.pos);
      if(mvr != this && dist < perc) {
        avg.add(mvr.vel);
        total++;
      }
    }
    
    if(total > 0) {
      avg.div(total);
      avg.setMag(this.maxspeed);
      avg.sub(this.vel);
      avg.limit(this.maxforce);
      return avg;
    } else {
      return new PVector();
    }
  }
  
  PVector cohesion(ArrayList<Mover> mvrs, float perc) {
    PVector avg = new PVector();
    int total = 0;
    
    for(Mover mvr : mvrs) {
      float dist = PVector.dist(this.pos, mvr.pos);
      if(mvr != this && dist < perc) {
        avg.add(mvr.pos);
        total++;
      }
    }
    
    if(total > 0) {
      avg.div(total);
      return this.seek(avg);
    } else {
      return new PVector();
    }
  }
}
