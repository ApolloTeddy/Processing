float aStart = 0;
float aBump = 0;
float thick = 71;
float speed = .8;
color a = color(53, 23, 229);
color b = color(242, 220, 17);

void setup()
{
  size(600, 600);
  smooth();
  noStroke();
}

void draw()
{
  background(0);
  float diam = height;
  float angle = aStart;
  while(diam > 0)
  {
    fill(a);
    ellipse(width / 2, height / 2, diam, diam);
    fill(b);// else fill(a);
    if(diam % 2 == 0)
    {
      arc(width / 2, height / 2, diam / 2, diam / 2, angle, angle + PI);
    }
    else
    {
      arc(width / 2, height / 2, diam, diam, angle, angle + PI);
    }
    if(diam % 2 == 0) diam -= thick / 2; else diam -= thick;
    angle += speed * aBump;
  }
  aStart += speed * .01;
  aBump += speed * .005;
}
