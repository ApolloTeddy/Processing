class Stick {
  PVector pos, aim;
  float lim;
  
  Stick(float x, float y, float lim) {
    this.pos = new PVector(x, y);
    this.aim = PVector.random2D();
    this.lim = lim;
  }
  
  void show() {
    push();
    translate(this.pos.x, this.pos.y);
    line(0, 0, this.aim.x, this.aim.y);
    pop();
  }
  
  void setAim(float x, float y, boolean setMag) {
    PVector newPos = PVector.sub(new PVector(x, y), this.pos).limit(this.lim);
    if(setMag) newPos.setMag(this.lim);
    this.aim.set(newPos);
  }
}
