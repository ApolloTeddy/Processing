abstract class Obj {
  float x, y, r;
  
  Obj(float r) {
    this.x = random(width);
    this.y = random(height);
    this.r = r;
  }
  
  abstract void show();
}
