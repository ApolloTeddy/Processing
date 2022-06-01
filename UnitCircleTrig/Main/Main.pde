float inc = TAU / (100), scale = 200, theta = TAU / (100);

void setup() {
  background(60);
  frameRate(1);
  size(500, 500);
  ellipseMode(RADIUS);
  fill(100);
  circle(width / 2, height / 2, scale);
  noFill();
}

void draw() {
  //if(theta >= TAU * 2) noLoop();
  float sin = sin(theta) * scale;
  float cos = cos(theta) * scale;
  float sec = 1 / cos(theta) * scale;
  float csc = 1 / sin(theta) * scale;
  
  //background(100);
  translate(width / 2, height / 2);
  
  strokeWeight(2);
  circle(0, 0, scale);
  //line(-width / 2, 0, width / 2, 0);
  //line(0, -height / 2, 0, height / 2);
  
  strokeWeight(3);
  stroke(255);
  line(sin, cos, sin, 0);
  
  stroke(0);
  line(sin, cos, 0, cos);
  
  stroke(#0704DB);
  line(sin, cos, csc, 0);
  
  stroke(#A633E5);
  line(sin, cos, 0, sec);
  
  strokeWeight(7);
  stroke(0);
  //point(sin, cos);
  
  theta += inc;
  saveFrame("frame-###.png");
}
