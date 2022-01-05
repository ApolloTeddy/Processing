public float dist = 50;

class Snake
{
  PVector pos, vel;
  ArrayList<bodyPart> bParts;
  float maxSpeed = 100;
  
  Snake(float x, float y)
  {
    this.pos = new PVector(x, y);
    this.vel = new PVector(0, 0);
    this.bParts = new ArrayList<bodyPart>();
  }
  
  void update()
  {
    this.vel.limit(this.maxSpeed);
    this.pos.add(this.vel);
  }
  
  void show()
  {
    for(bodyPart part : bParts)
    {
      part.updatePositionInList(bParts);
      part.update();
      part.show();
    }
  }
  
  void setVel(float x, float y)
  {
    var newVel = new PVector(x, y);
    this.vel = newVel;
  }
  
  void addBodyPart()
  {
    bParts.add(new bodyPart());
  }
}

class bodyPart
{
  PVector pos, vel, acc;
  float maxSpeed = 3, maxForce = 0.1;
  bodyPart()
  {
    this.pos = new PVector(0, 0);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
  }
  
  void updatePositionInList(ArrayList<bodyPart> list)
  {
    if(!list.contains(this)) return;
    int i = list.indexOf(this);
    if(i == 0)
    {
      this.applyForce(this.seek(new PVector(mouseX, mouseY)));
    }
    else
    {
      this.applyForce(this.seek(list.get(i - 1).pos));
      //this.applyForce(this.destroy(list.get(i - 1).pos));
    }
  }
  
  void show()
  {
    push();
    stroke(90);
    strokeWeight(10);
    point(this.pos.x, this.pos.y);
    pop();
  }
  
  void update()
  {
    this.vel.add(this.acc);
    this.vel.limit(this.maxSpeed);
    this.pos.add(this.vel);
    this.acc.mult(0);
  }
  
  // DESIRED = TARGET - POSITION
  // STEER = DESIRED - VELOCITY
  void applyForce(PVector force)
  {
    this.acc.add(force);
  }
  
  PVector seek(PVector target)
  {
    PVector steer, des;
    des = PVector.sub(target, this.pos);
    //des.setMag(maxSpeed);
    steer = PVector.sub(des, this.vel);
    steer.limit(maxForce);
    return steer;
  }
  
  PVector destroy(PVector target)
  {
    PVector steer, diff;
    float dist = PVector.dist(this.pos, target);
    diff = PVector.sub(this.pos, target);
    diff.normalize();
    diff.div(dist);
    steer = PVector.sub(target, this.pos);
    steer.add(diff);
    //steer.setMag(maxSpeed);
    steer.sub(this.vel);
    steer.limit(maxForce);
    return steer;
  }
}
