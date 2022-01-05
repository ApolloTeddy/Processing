Circle c1, c2;

double eps = 0.0000001;

void setup()
{
  size(900, 900);
  c1 = new Circle(390,  570, 120);
  c2 = new Circle(600, 780, 180);
  fill(183, 25, 75);
  stroke(255);
  strokeWeight(15);
  push();
}

void draw()
{
  background(120);
  c1.pos.set(mouseX, mouseY);
  push();
  noStroke();
  translate(-170, -300);
  c1.show();
  c2.show();
  pop();
  fill(183, 25, 75);
  drawIntersections(c1, c2);
}
