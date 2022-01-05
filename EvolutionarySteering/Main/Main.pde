ArrayList<Agent> Agts;
ArrayList<PVector> food;
ArrayList<PVector> poison;

void setup() {
  size(600, 600);
  Agts = new ArrayList<Agent>();
  for(int i = 0; i < 1; i++)
    Agts.add(new Agent());
  food = new ArrayList<PVector>();
  for(int i = 0; i < 10; i++) {
    var x = random(width);
    var y = random(height);
    food.add(new PVector(x, y));
  }
  poison = new ArrayList<PVector>();
  for(int i = 0; i < 10; i++) {
    var x = random(width);
    var y = random(height);
    poison.add(new PVector(x, y));
  }
}

void draw() {
  background(80);
  food.forEach(v -> {
    fill(0, 255, 0);
    noStroke();
    ellipse(v.x, v.y, 8, 8);
  });
  poison.forEach(v -> {
    fill(152, 2, 2);
    noStroke();
    ellipse(v.x, v.y, 8, 8);
  });
  for(int i = 0; i < Agts.size(); i++) {
    Agent a = Agts.get(i);
    a.eat(food);
    a.eat(poison);
    a.run();
  }
}
