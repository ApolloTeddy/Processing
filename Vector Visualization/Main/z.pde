public color first = color(80, 177, 255);
public color second = color(95, 255, 120);
public color third = color(255, 117, 95);
public color fourth = color(201, 103, 255);

void display()
{
  stroke(first);
  fill(first);
  text("v1", width - width / 10, height / 14.8);
  point(width - width / 16, height / 16);
  stroke(second);
  fill(second);
  text("v2", width - width / 10, height / 7.55);
  point(width - width / 16, height / 8);
  stroke(third);
  fill(third);
  text("sub", width - width / 8.9, height / 5.1);
  point(width - width / 16, height / 5.25);
}

public Vector subV(Vector v1, Vector v2)
{
  return new Vector(v1.pos.x - v2.pos.x, v1.pos.y - v2.pos.y);
}
public Vector addV(Vector v1, Vector v2)
{
  return new Vector(v1.pos.x + v2.pos.x, v1.pos.y + v2.pos.y);
}
