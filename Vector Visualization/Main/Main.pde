Vector v1, v2, sub, add;
int darkenNodes = 30;

void setup()
{
  size(800, 800);
  v1 = new Vector(15, 30);
  v1.setOrigin(width / 2, height / 2); v1.setLineColor(first);
  v2 = new Vector(-15, -30);
  v2.setOrigin(width / 2, height / 2); v2.setLineColor(second);
  sub = new Vector(0, 0);
  sub.setOrigin(width / 2, height / 2); sub.setLineColor(third);
  add = new Vector(0, 0);
  add.setOrigin(width / 2, height / 2); add.setLineColor(fourth);
}

void draw()
{
  background(110);
  display();
  if(mouseButton == LEFT) 
  {
    v1.set(mouseX - width / 2, mouseY - height / 2);
  }
  if(mouseButton == RIGHT)
  {
    v2.set(mouseX - width / 2, mouseY - height / 2);
  }
  //sub.setOrigin(v2.ori.x + v2.pos.x, v2.ori.y + v2.pos.y);
  sub.set(subV(v1, v2));
  sub.show();
  add.set(addV(v1, v2));
  add.show();
  v2.show();
  v1.show();
  System.out.println();
  System.out.println("v1: (" + v1.pos.x + ", " + v1.pos.y + ")");
  System.out.println("v2: (" + v2.pos.x + ", " + v2.pos.y + ")");
  System.out.println("sub: (" + sub.pos.x + ", " + sub.pos.y + ")");
}
