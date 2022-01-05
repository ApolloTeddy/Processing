
class Point {
  float x;
  float y;
  int label;
  
  Point() {
    this.x = random(width);
    this.y = random(height);
    
    if(x > y) {
      this.label = 1;
    } else {
      this.label = -1;
    }
  }
  
  void show() {
    stroke(0);
    if(label == 1) {
      fill(255);
    } else {
      fill(0);
    }
    
    circle(x, y, 10);
  }
}
