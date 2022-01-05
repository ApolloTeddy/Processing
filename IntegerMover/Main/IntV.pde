class IntV {
  float val, vel, acc;
  float maxf = 1, maxs = 1;
  
  IntV() {
    this.val = random(-10, 10);
    this.vel = 0;
    this.acc = 0;
  }
  
  void run() {
    this.update();
    this.edges();
    this.show();
  }
  
  void update() {
    this.vel += this.acc;
    this.vel = min(this.vel, this.maxs);
    this.val += this.vel;
    this.acc = 0;
  }
  
  void applyForce(float force) {
    this.acc += force;
  }
  
  void show() {
    println("\n\n\n", this.val);
  }
  
  void edges() {
    if(this.val > 10) {
      this.val = 0;
    }
    if(this.val < 0) {
      this.val = 10;
    }
  }
  
  float seek(float target) {
    float des, str;
    des = target - this.val;
    des /= abs(des);
    str = des - this.vel;
    str = min(str, this.maxs);
    return str;
  }
}
