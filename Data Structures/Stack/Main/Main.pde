Stack<Integer> s;
int r = 20;

int des = 20;

int tries = 0;
void setup() {
  size(600, 600);
  fill(0);
  s = new Stack<Integer>();
  for(int i = 0; i < 400; i++) {
    s.push(int(random(1, 100)));
    if(s.peek() != des) {
      s.pop();
      i--;
      tries++;
    }
  }
  println(tries);
}

void draw() {
  background(100);

  int current = 0;
  for (float x = 0; x < width; x += width / r) {
    for (float y = 0; y < height; y += height / r) {
      if (current < s.size()) {
        Stack.Node selected = s.top;
        for(int i = (s.size() - 1) - current; i > 0; i--) {
          selected = selected.next;
        }
        current++;
        text(selected.data.toString(), x + 5, y + 15);
      }
    }
  }
  text(s.size(), width - 15, height - 15);
}

void mousePressed() {
  int rand = int(random(1, 100));
  if (mouseButton == LEFT) {
    s.push(rand);
  } else if (mouseButton == RIGHT) {
    s.pop(); 
  }
}
