int len = 20;
int numberOfSeg = 100;
Worm w, a;

void setup()
{
  fullScreen();
  w = new Worm(width / 2, height / 2);
  for(int i = 0; i < numberOfSeg; i++) {
    w.addSeg();
  }
}
boolean alt;
void draw()
{
  background(120);
  w.show();
}
