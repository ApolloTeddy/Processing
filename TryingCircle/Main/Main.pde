ArrayList<Polygon> shapes;

int trg = 102, tries = 5000;
int minR = 5, maxR = 25;
int minV = 3, maxV = 9;

void setup() {
  size(800, 800);
  shapes = new ArrayList<Polygon>();
  int cur = 0;
  for (int i = 0; i < trg; i++) {
    if (cur > tries) break;
    float[] pos = { random(width), random(height) };
    float r = random(minR, maxR);
    int v = int(random(minV, maxV));
    Polygon newShape = new Polygon(pos[0], pos[1], r, v);
    if (!newShape.isIntersectingOther(shapes)) {
      shapes.add(newShape);
    } else {
      i--;
      tries++;
    }
    cur++;
  }
  if(cur < tries)
    print("S");
  else
    print("F");
}

void draw() {
  background(100);
  for (int i = 0; i < shapes.size(); i++) {
    shapes.get(i).show();
  }
}
