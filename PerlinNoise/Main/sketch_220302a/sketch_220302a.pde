class Ship {
  float r = 10, maxSpeed = 12, maxAcc = 0.1, mass = 0.4, turnSpeed = 1;
  PVector pos, vel, acc;
  
  Ship(float x, float y, float s) {
    pos.x = x;
    pos.y = y;
    maxSpeed = s;
  }
  
  void addForce(PVector force) {
    acc.add(force.div(mass));
  }
  
  void update() {
    vel.add(acc);
    pos.add(vel);
    acc.mult(0);
    
    if(pos.x > width)
      pos.x = 0;
    else if(pos.x < 0)
      pos.x = width;
    if(pos.y > height)
      pos.y = 0;
    else if(pos.y < 0)
      pos.y = height;
  }
  
  void show() {
    push();
    translate(pos.x, pos.y);
    rotate(vel.heading() - QUARTER_PI);
    triangle(-r/2,0,r/2,0,0,r*2);
    pop();
  }
}

void setup() {
  size(600, 300);
  rectMode(CENTER);
}

void draw() {
  
}
