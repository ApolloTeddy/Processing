/* Conway's Game of Life Cellular Automata by Azavier Allen.
/*
/* CONTROLS:
/*   Mouse:
/*     Pretty intuitive brush controls, left click to set alive,
/*     again to delete, you can drag with both.
/*     Right click to start/stop the simulation.
/*     Scroll wheel to adjust brush size.
/*     Middle click while the simulation is stopped to send it one generation forward.
/*     Killing cells with the mouse is disabled while the simulation is running.
/*   Keyboard:
/*     R to add a random assortmet of Cells;
/*     C to kill all alive Cells.
/*     Up/down arrow key to increase/decrease simulation speed.
/*
/* SETTINGS BELOW */
boolean randomCells = false; // Generate a random set of cell on startup, based on randomCellChance.
int randomCellChance = 40; // Chance of an empty cell becoming alive if randomCells is true.
int updateRate = 15, _frameRate = 60, maxBrushSize = 6; // Per second.
/* SETTINGS ABOVE */

boolean updating = false, deletingMode = false;
int cols, rows, cellSize = 10, brushSize = 1;

public static Cell[][] grid;

void setup()
{
  fullScreen();
  frameRate(updateRate);
  cols = width / cellSize;
  rows = height / cellSize;
  grid = new Cell[cols][rows];

  for (int x = 0; x < cols; x++)
  {
    for (int y = 0; y < rows; y++)
    {
      grid[x][y] = new Cell(x * cellSize, y * cellSize, cellSize);
      if (randomCells) 
      {
        if (int(random(0, 11)) < randomCellChance / 10f) 
        {
          grid[x][y].live();
          grid[x][y].nextState = 1;
        }
      }
    }
  }
}

void draw()
{
  if (updating)
  {
    frameRate(updateRate);
    for (int x = 0; x < cols; x++)
    {
      for (int y = 0; y < rows; y++)
      {
        if (updating) grid[x][y].scan();
      }
    }
  } else frameRate(_frameRate);
  for (int x = 0; x < cols; x++)
  {
    for (int y = 0; y < rows; y++)
    {
      if (updating) grid[x][y].update();
      grid[x][y].show();
    }
  }
}

void mousePressed()
{
  if (mouseButton == RIGHT) updating = !updating;
  else if (mouseButton == LEFT)
  {
    Cell mouseCell = getCell(mouseX / cellSize, mouseY / cellSize);
    println(mouseCell.x, mouseCell.y);
    if (mouseCell.state == 1) deletingMode = true;
    else deletingMode = false;
    if(brushSize == 1)
    {
      if (!updating)
      {
        if (!deletingMode)
        {
          mouseCell.live();
          mouseCell.nextState = 1;
        } 
        else
        {
          mouseCell.die();
          mouseCell.nextState = 0;
        }
      } 
      else
      {
        mouseCell.live();
        mouseCell.nextState = 1;
      }
    }
    else
    {
      for (int x = -brushSize / 2; x < brushSize / 2; x++)
      {
        for (int y = -brushSize / 2; y < brushSize / 2; y++)
        {
          Cell selectedCell = getCell(mouseX / cellSize + x, mouseY / cellSize + y);
  
          if (!updating)
          {
            if (!deletingMode && selectedCell != null)
            {
              selectedCell.live();
              selectedCell.nextState = 1;
            } 
            else if(selectedCell != null)
            {
              selectedCell.die();
              selectedCell.nextState = 0;
            }
          } 
          else if(selectedCell != null)
          {
            selectedCell.live();
            selectedCell.nextState = 1;
          }
        }
      }
    }
  } 
  else
  {
    // DEBUG: System.out.print("Mouse: (" + mouseX / cellSize + ", " + mouseY / cellSize + ")\nCell: (" + getCell(mouseX / cellSize, mouseY / cellSize).x + ", " + getCell(mouseX / cellSize, mouseY / cellSize).y + ") Adj: " + getCell(mouseX / cellSize, mouseY / cellSize).checkAdjacent() + "\n");
    if(!updating)
    {
      for (int x = 0; x < cols; x++)
      {
        for (int y = 0; y < rows; y++)
        {
          grid[x][y].scan();
        }
      }
      for (int x = 0; x < cols; x++)
      {
        for (int y = 0; y < rows; y++)
        {
          grid[x][y].update();
        }
      }
    }
  }
}

void mouseWheel(MouseEvent event)
{
  if (event.getCount() < 0 && brushSize + 1 <= maxBrushSize) brushSize += 1;
  if (event.getCount() > 0 && brushSize - 1 >= 1) brushSize -= 1;
}

void mouseDragged()
{
  if (mouseButton == LEFT)
  {
    if(brushSize == 1)
    {
      Cell selectedCell = getCell(mouseX / cellSize, mouseY / cellSize);
      if (!deletingMode && selectedCell != null)
      {
        selectedCell.live();
        selectedCell.nextState = 1;
      } 
      else if (selectedCell != null)
      {
        selectedCell.die();
        selectedCell.nextState = 0;
      }
    }
    else
    {
      for (int x = -brushSize / 2; x < brushSize / 2; x++)
      {
        for (int y = -brushSize / 2; y < brushSize / 2; y++)
        {
          Cell selectedCell = getCell(mouseX / cellSize + x, mouseY / cellSize + y);
          if (!deletingMode && selectedCell != null)
          {
            selectedCell.live();
            selectedCell.nextState = 1;
          } 
          else if (selectedCell != null)
          {
            selectedCell.die();
            selectedCell.nextState = 0;
          }
        }
      }
    }
  }
}

void keyPressed()
{
  if (key == CODED)
  {
    if (keyCode == UP)
    {
      if (updateRate + 5 != 90) updateRate += 5;
    } 
    else if (keyCode == DOWN)
    {
      if (updateRate - 5 > 0) updateRate -= 5;
    }
  } 
  else
  {
    if (key == 'C' || key == 'c')
    {
      for (int x = 0; x < cols; x++)
      {
        for (int y = 0; y < rows; y++)
        {
          grid[x][y].nextState = 0;
          grid[x][y].die();
        }
      }
    }
    if(key == 'R' || key == 'r')
    {
      randomizeGrid();
    }
  }
}

void randomizeGrid()
{
  for (int x = 0; x < cols; x++)
  {
    for (int y = 0; y < rows; y++)
    {
      if (int(random(0, 11)) < randomCellChance / 10f) 
      {
        grid[x][y].live();
        grid[x][y].nextState = 1;
      }
    }
  }
}
