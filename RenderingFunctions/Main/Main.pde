import java.util.Arrays;

Graph g;
float points = 1000, scl = 8;

ArrayList<Func> f = new ArrayList<Func>(Arrays.asList(
                    (x) -> cos(x)*sin(x), 
                    (x) -> -sin(x)*sin(x) + cos(x)*cos(x)
                ));

interface Func {
  float of(float x);
}

void setup() {
  size(600, 600);
  float start = -width/2, end = width/2;
  g = new Graph(start, end);
}

void draw() {
  background(110);
  g.show();
  float a = map(mouseX, 0, width, -PI*4, PI*4);
  g.drawFunc(f.get(0), color(180, 0, 0));
  g.tanLine(f.get(0), f.get(1), a, color(0, 0, 180));
}
