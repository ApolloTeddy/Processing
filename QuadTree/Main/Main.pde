QTree qTree;
ArrayList<Poid> poids;
Rectangle startBoundary;

int amountOfElements = 10;

void setup()
{
  size(800, 800);
  poids = new ArrayList<Poid>();
  startBoundary = new Rectangle(width / 2, height / 2, width, height);
  qTree = new QTree(startBoundary, 3);
  //for(int i = 0; i < amountOfElements; i++) 
  //{
  //  Poid newPoid = new Poid(int(random(width)), int(random(height)));
  //  poids.add(newPoid);
  //  qTree.insert(newPoid);
  //}
}

void keyPressed()
{
  if(key == 'r' || key == 'R')
  {
    Poid newPoid = new Poid(mouseX, mouseY);
    poids.add(newPoid);
    qTree.insert(newPoid);
  }
}

void draw()
{
  background(120);
  qTree.show();
  for(Poid poid : poids)
  {
    poid.show();
  }
}
