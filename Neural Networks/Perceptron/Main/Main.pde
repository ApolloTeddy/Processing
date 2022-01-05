Perceptron perc;

Point[] points = new Point[100];

int trainingIndex = 0;

void setup()
{
  size(800, 800); 
  perc = new Perceptron();
  
  randomize();
  
  float[] inputs = {-1, 0.5};
  int guess = perc.guess(inputs);
  println(guess);
}

void randomize() {
  for(int i = 0; i < points.length; i++) {
    points[i] = new Point();
  }
}

void draw()
{
  background(125);
  
  strokeWeight(1);
  line(0, 0, width, height);
  for(Point point : points) {
    Point training = points[trainingIndex];
    float[] inputs = {training.x, training.y};
    int target = training.label;    
    int guess = perc.guess(inputs);
    trainingIndex++;
    if(trainingIndex == points.length) {
      trainingIndex = 0;
    }
    
    if(guess == target)
      fill(0, 255, 0);
    else 
      fill(255, 0, 0);
    noStroke();
    circle(point.x, point.y, 17);
  }
}

void mousePressed() {
  if(mouseButton == LEFT) {
    for(Point point : points) {
      float[] inputs = {point.x, point.y};
      int target = point.label;
      perc.train(inputs, target);
    }
  } else if(mouseButton == RIGHT) {
    randomize();
  }
}
