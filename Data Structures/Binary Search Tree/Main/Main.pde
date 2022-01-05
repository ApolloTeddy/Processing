Node tree;

void setup() {
  size(600, 500);
  tree = new Node(int(random(1, 100)));
  for(int i = 0; i < 100; i++) {
    tree.insert(int(random(1, 100)));
  }
}

void draw() {
  background(100);
  println("\n\n\n\n");
  tree.printOut();
}
