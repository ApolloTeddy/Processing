class Cell
{
  int x, y;
  float size;
  int state = 0, nextState = 0, colors = 88;
  
  Cell(int x, int y, float size)
  {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  void show()
  {
    switch(state)
    {
     case 1:
       fill(cellColorAlive);
       break;
     case 0:
       fill(cellColorDead);
       break;
    }
    stroke(gridColor);
    square(x, y, cellSize);
  }
  
  public void update()
  {
    if(nextState == 1) live();
    else die();
  }
  
  public void scan()
  {
    int aliveAdj = checkAdjacent();
    
    if(state == 1)
    {
      if(aliveAdj < 2)
      {
        nextState = 0;
      }
      else if(aliveAdj == 2 || aliveAdj == 3)
      {
        // Nothing ig? idk why it's listed on the fucking wiki.
        nextState = 1;
      }
      else if(aliveAdj > 3) 
      {
        nextState = 0;
      }
    } 
    else 
    {
      if(aliveAdj == 3)
      {
        nextState = 1; 
      }
    }
  }
  
  public void die() { this.state = 0; }
  
  public void live() { this.state = 1; }
  
  public int getState() { return this.state; }
  
  public int checkAdjacent()
  {
    int aliveAdj = 0;
    for(int i = 1; i <= 8; i++)
    {
      Cell indexedCell = getCellAtIndex(this, i);
      if(indexedCell != null && indexedCell != this && indexedCell.getState() == 1) aliveAdj++;
    }
    return aliveAdj;
  }
}
