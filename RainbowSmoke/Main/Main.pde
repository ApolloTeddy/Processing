PGraphics r;

void setup() {
  size(800, 800);
  r = createGraphics(100, 100);
}

int pixelPos(int x, int y) {
  return x + r.width*y;
}

void draw() {
  r.beginDraw();
  r.background(0);
  r.loadPixels();
  for(int x = 0; x < r.width; x++) {
    r.pixels[pixelPos(x, r.height/2)] = color(255);
  }
  r.updatePixels();
  r.endDraw();
  image(r, 0, 0, width, height);
}
