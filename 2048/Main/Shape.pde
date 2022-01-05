abstract class Shape {
  int x = 0, y = 0;
  int xO = 0, yO = 0;
  
  void setPos(int x, int y) {
    this.x = x + xO;
    this.y = y + yO;
  }
  
  void setO(int x, int y) {
    this.xO = x;
    this.yO = y;
  }
  
  void show() {}
}
