class Mover
{
  PVector pos, vel, acc;
  float maxSpeed = 12; // Max moving force
  float maxForce = 0.06; // Max steering
  int r = 8;
  
  Mover(int x, int y)
  {
    this.pos = new PVector(x, y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
  }
  
  public void run()
  {
    this.update();
    this.edges();
    this.show();
  }
  
  PVector seek(PVector target)
  {
    PVector desired; // DESIRED = TARGET - POSITION
    PVector steer; // STEER = DESIRED - VELOCITY
    
    desired = PVector.sub(target, this.pos);
    desired.setMag(maxSpeed);
    
    steer = PVector.sub(desired, this.vel);
    steer.limit(maxForce);
    
    //this.applyForce(steer);
    return steer;
  }
  
  void flock(ArrayList<Mover> movers, float[] perception)
  {
    PVector cohesion = cohesionForce(movers, perception[0]);
    PVector alignment = alignmentForce(movers, perception[1]);
    PVector separation = separationForce(movers, perception[2]);
    
    applyForce(cohesion, 1);
    applyForce(alignment, 1);
    applyForce(separation, 1.5);
  }
  
  void update()
  {
    this.vel.add(this.acc);
    this.vel.limit(this.maxSpeed);
    this.pos.add(this.vel);
    this.acc.set(0, 0);
  }
  
  void show()
  {
    stroke(100);
    strokeWeight(2);
    fill(100);
    pushMatrix();
    translate(this.pos.x, this.pos.y);
    rotate(this.vel.heading());
    triangle(-this.r, -this.r / 2, -this.r, this.r / 2, this.r, 0);
    popMatrix();
  }
  
  void applyForce(PVector force)
  {
    this.acc.add(force);
  }
  void applyForce(PVector force, float weight)
  {
    this.acc.add(force.mult(weight));
  }
  
  void edges() {
    if (this.pos.x > width + this.r) {
      this.pos.x = -this.r;
    } else if (this.pos.x < -this.r) {
      this.pos.x = width + this.r;
    }
    if (this.pos.y > height + this.r) {
      this.pos.y = -this.r;
    } else if (this.pos.y < -this.r) {
      this.pos.y = height + this.r;
    }
  }
  
  PVector separationForce(ArrayList<Mover> movers, float perception)
  {
    PVector steer = new PVector(0, 0);
    float total = 0;
    
    for(Mover mover : movers)
    {
      float dist = PVector.dist(this.pos, mover.pos);
      if(dist > 0 && dist < perception)
      {
        PVector diff = PVector.sub(this.pos, mover.pos);
        diff.normalize();
        diff.div(dist);
        steer.add(diff);
        total++;
      }
    }
    if(total > 0)
    {
      steer.div(total);
    }
    if(steer.mag() > 0)
    {
      steer.setMag(maxSpeed);
      steer.sub(this.vel);
      steer.limit(maxForce);
    }
    return steer;
  }
  
  PVector alignmentForce(ArrayList<Mover> movers, float perception)
  {
    PVector averageVel = new PVector(0, 0);
    float total = 0;
    
    for(Mover mover : movers)
    {
      float dist = PVector.dist(this.pos, mover.pos);
      if(dist > 0 && dist < perception)
      {
        averageVel.add(mover.vel);
        total++;
      }
    }
    if(total > 0)
    {
      averageVel.div(total);
      averageVel.setMag(maxSpeed);
      PVector steer = PVector.sub(averageVel, this.vel);
      steer.limit(maxForce);
      return steer;
    }
    else
    {
      return new PVector(0, 0);
    }
  }
  
  PVector cohesionForce(ArrayList<Mover> movers, float perception)
  {
    PVector averagePos = new PVector(0, 0);
    float total = 0;
    
    for(Mover mover : movers)
    {
      float dist = PVector.dist(this.pos, mover.pos);
      if(dist > 0 && dist < perception)
      {
        averagePos.add(mover.pos);
        total++;
      }
    }
    if(total > 0)
    {
      averagePos.div(total);
      return seek(averagePos);
    }
    else
    {
      return new PVector(0, 0);
    }
  }
}
