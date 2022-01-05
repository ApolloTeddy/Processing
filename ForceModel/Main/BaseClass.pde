class PhysObj
{
  PVector pos, vel, acc;
  float mass = 1, drag = 0.01;
  PhysObj(int x, int y)
  {
    this.pos = new PVector(x, y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
  }
}
