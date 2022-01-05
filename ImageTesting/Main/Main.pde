PImage smile;

void setup()
{
  size(600, 600);
  imageMode(CENTER);
  smile = loadImage("smiley.jpg");
}

void draw()
{
  background(0);
  image(smile, mouseX, mouseY);
}
