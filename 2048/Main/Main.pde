ArrayList<Shape> shapes;

void setup() {
  size(600, 600);
  rectMode(CENTER);
  shapes = new ArrayList<Shape>();
  
  shapes.add(new Shape() { // Cirlce
    int r = 50;
    void show() {
      ellipse(x, y, r, r);
    }
  }); 
  shapes.add(new Shape() { // Rectangle
    int w = 25, h = 50;
    void show() {
      rect(x, y, w, h);
    }
  }); 
  
  shapes.get(0).setO(50, 50); // Circle offset
  shapes.get(1).setO(-50, -50); // Rectangle offset
}

void draw() {
  background(100);
  
  shapes.forEach(s -> { 
    s.setPos(mouseX, mouseY); 
    s.show(); 
  });
}
