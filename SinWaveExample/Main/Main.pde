float[] a;

void setup() {
  noStroke();
  fill(50);
  size(600, 600);
  
  float offset = 0.01;
  
  for(int i = 0; i < height / 100; i++) {
    a[i] = offset;
    offset += 0.01;
  }
}

void draw() {
  for(float f : a) f += 0.01;
  background(100);
  
  push();
  translate(width / 2, height / 2);
  float r = map(sin(a), -1, 1, 10, height / 10);
  ellipse(0, 0, r, r);
  pop();
}
