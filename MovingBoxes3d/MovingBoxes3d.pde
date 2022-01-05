float inc = 0.1;
float a = 0;
void setup() {
  size(640, 360); 
  noStroke();
  rectMode(CENTER);
}
void draw() {
  background(50); 
  fill(color(map((int)map(cos(a), -1, 1, 0, width), 0, width, 0, 255), 0, map((int)map(cos(a), -1, 1, 0, width), 0, width, 255, 0), map((int)map(sin(a), -1, 1, 0, height), 0, height, 255, 122)));
  rect((int)map(cos(a), -1, 1, 0, width), height / 2, (int)map(sin(a), -1, 1, 0, height) / 2 + 10, (int)map(sin(a), -1, 1, 0, height) / 2 + 10);
  fill(color(map(width - (int)map(cos(a), -1, 1, 0, width), 0, width, 0, 255), 0, map(width - (int)map(cos(a), -1, 1, 0, width), 0, width, 255, 0), map((int)map(sin(a), -1, 1, 0, height), 0, height, 255, 122)));
  rect(width - (int)map(cos(a), -1, 1, 0, width), height / 2, (height - (int)map(sin(a), -1, 1, 0, height) / 2) + 10, (height - (int)map(sin(a), -1, 1, 0, height) / 2) + 10);
  a += inc;
}
