FloatList angles = new FloatList();
FloatList angles2 = new FloatList();
float r = 2;

void setup()
{
  fullScreen();
  int total = floor(width / (r * 2));
  for(int i = 0; i < total + 1; i++)
  {
    angles.append(map(i, 0, total, 0, QUARTER_PI));
    angles2.append(map(0, i, total, 0, QUARTER_PI));
  }
}

void draw()
{
  background(120);
  translate(width / 2, height / 2);
  noFill();
  stroke(40);
  strokeWeight(10);
  beginShape();
  for(int i = 0; i < angles.size(); i++)
  {
    float y = map(sin(angles.get(i)), -1, 1, -height / 2, height / 2);
    float x = map(i, 0, angles.size(), -width / 2, width / 2);
    //line(x, 0, x, y);
    vertex(x, y);
    angles.set(i, angles.get(i) + 0.1);
  }
  endShape();
  beginShape();
  for(int i = 0; i < angles.size(); i++)
  {
    float y = map(sin(angles.get(i)),                                         1, 1, -height / 2, height / 2);
    float x = map(i, 0, angles.size(), -width / 2, width / 2);
    //line(x, 0, x, y);
    vertex(x, y);
    angles.set(i, angles.get(i) + 0.1);
  }
  endShape();
  //angle += angleV; 
}
