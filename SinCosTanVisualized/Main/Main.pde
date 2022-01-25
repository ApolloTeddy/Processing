float theta = 0,
      inc = 0.015,
      r = 200;

void setup() {
  size(500, 500);
  noFill();
  strokeWeight(2);
}

void renderGridCircle() {
  line(-250, 0, 250, 0);
  line(0, 250, 0, -250);
  circle(0, 0, r);
}

void renderPoint() {
  strokeWeight(5);
  stroke(255);
  point(sin(theta) * r / 2, cos(theta) * r / 2);
}

void draw() {
  background(60);
  theta += inc;
  
  float x = sin(theta)*r/2, y = cos(theta)*r/2;
  
  push();
  translate(250, 250);
  renderGridCircle();
  
  // Sin
  strokeWeight(2);
  stroke(150, 0, 0);
  line(x, y, x, 0);
  
  // Cos
  stroke(0, 0, 150);
  line(x, y, 0, y);
  
  // Tan
  stroke(#991BDE);
  line(x, y, r/sin(theta)/2, 0);
  
  // Cot
  stroke(#B98116);
  line(x, y, 0, r/cos(theta)/2);
  
  // Sec
  stroke(#24DE8B);
  line(0, 0, r/sin(theta)/2, 0);
  
  // Csc
  stroke(#2ABF02);
  line(0, 0, 0, r/cos(theta)/2);
  
  // Vers
  stroke(#5DB0DB);
  line(x, 0, x + (r/2 - x), 0);
  
  // Covers
  stroke(#3E6A81);
  line(0, y, 0, y - (r/2 + y));
  
  renderPoint();
  pop();
}
