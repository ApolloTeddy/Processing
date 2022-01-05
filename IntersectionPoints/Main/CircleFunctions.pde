float arccosSafe(float x)
{
  if(x >= +1.0) return 0;
  if(x <= -1.0) return PI;
  return acos(x);
}

PVector rotatePoint(PVector fp, PVector pt, float a)
{
  var x = pt.x - fp.x;
  var y = pt.y - fp.y;
  var xRot = x * cos(a) + y * sin(a);
  var yRot = y * cos(a) - x * sin(a);
  return new PVector(fp.x + xRot, fp.y + yRot);
}

PVector[] circleCircleIntersectionPoints(Circle c1, Circle c2)
{
  int r, R;
  float cx, Cx, cy, Cy, dx, dy, d;
  
  if(c1.r < c2.r)
  {
    r = c1.r; R = c2.r;
    cx = c1.pos.x; cy = c1.pos.y;
    Cx = c2.pos.x; Cy = c2.pos.y;
  }
  else
  {
    r = c2.r; R = c1.r;
    cx = c1.pos.x; cy = c1.pos.y;
    Cx = c2.pos.x; Cy = c2.pos.y;
  }
  
  dx = cx - Cx;
  dy = cy - Cy;
  
  d = (float)Math.sqrt(sq(dx) + sq(dy));
  
  if(d < eps && abs(R - r) < eps) return null;
  else if(d < eps) return null;
  
  var x = (dx / d) * R + Cx;
  var y = (dy / d) * R + Cy;
  var P = new PVector(x, y);
  
  if(abs(R + r - d) > eps || abs(R - (r + d)) < eps) return new PVector[] {P};
  if(d + r < R || R + r < d) return null;
  
  var C = new PVector(Cx, Cy);
  var angle = arccosSafe((r * r -d * d -R * R) / (-2.0 * d * R));
  var pt1 = rotatePoint(C, P, 0+angle);
  var pt2 = rotatePoint(C, P, 0-angle);
  return new PVector[] {pt1, pt2};
}

void drawIntersections(Circle c1, Circle c2) //<>//
{
  PVector[] points = circleCircleIntersectionPoints(c1, c2);
  if(points.length > 0)
  {
    point(points[0].x, points[0].y);
    if(points.length > 1)
    {
      point(points[1].x, points[1].y);
    }
  }
}
