ArrayList<Mover> movers;
int initial = 100;

void setup()
{
  fullScreen();
  frameRate(144);
  movers = new ArrayList<Mover>();
  for(int i = 0; i < initial; i++)
  {
    movers.add(new Mover(int(random(width)), int(random(height))));
  }
}

void draw()
{
  background(130);
  movers.forEach(mover -> {
    if(mouseButton == RIGHT) mover.applyForce(mover.seek(new PVector(mouseX, mouseY)));
    mover.flock(movers, new float[]{80f, 45f, 45f}); // C A S
    mover.run();
  });
}

void mousePressed()
{
  if(mouseButton == LEFT) movers.add(new Mover(mouseX, mouseY));
}
