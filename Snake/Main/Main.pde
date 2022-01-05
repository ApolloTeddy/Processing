// DIRECTION = CURRENT - START
// Start is pointing to current
// CURRENT <- START
Snake snake;

void setup()
{
  size(800, 800);
  snake = new Snake(width / 2, height / 2);
  for(int i = 0; i < 5; i++)
  {
    snake.addBodyPart();
  }
}

void draw()
{
  background(110);
  snake.show();
}
