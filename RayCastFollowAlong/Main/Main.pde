Bounds b;
Ray r;
void setup() {
  size(600, 600);
  b = new Bounds(width/2, height/2, width, height/2);
  r = new Ray(100, 100);
}

void draw() {
  background(100);
  r.setDir(mouseX-r.pos.x, mouseY-r.pos.y);
  b.show();
  r.show();
}
