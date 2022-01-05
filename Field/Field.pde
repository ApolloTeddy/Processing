ArrayList<Stick> sticks;

int amount = 24;
float limit = 30;
boolean lim = false;

void setup() {
  fullScreen();
  noFill();
  smooth();
  strokeWeight(2);
  sticks = new ArrayList<Stick>();
  for(float x = 10; x <= width - 10; x += (width - 10) / amount) {
    for(float y = 10; y <= height - 10; y += (height - 10) / amount) {
      sticks.add(new Stick(x, y, limit));
    }
  }
}

void draw() {
  background(144, 129, 178);
  
  stroke(81, 56, 142);
  rect(10, 10, width - 20, height - 20);
  
  stroke(#B59FEA);
  sticks.forEach(stick -> {
    stick.setAim(mouseX, mouseY, lim);
    stick.show();
  });
}
