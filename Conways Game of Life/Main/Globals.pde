public static final int cellColorDead = 113;
public static final int cellColorAlive = 88;
public static final int gridColor = 123;

public static int[] getIndexPosition(int index)
{
  switch(index)
  {
    case 1:
      return new int[] {-1, -1};
    case 2:
      return new int[] {0, -1};
    case 3:
      return new int[] {1, -1};
    case 4:
      return new int[] {1, 0};
    case 5:
      return new int[] {1, 1};
    case 6:
      return new int[] {0, 1};
    case 7:
      return new int[] {-1, 1};
    case 8:
      return new int[] {-1, 0};
    default:
      return new int[] {0, 0};
  }
}
public Cell getCell(int x, int y)
{
  if ((x >= 0 && x < cols) && (y >= 0 && y < rows)) return grid[x][y];
  else return null;
}

public Cell getCellAtIndex(Cell cell, int index)
{
  return getCell(cell.x / cellSize + int(getIndexPosition(index)[0]), cell.y / cellSize + int(getIndexPosition(index)[1]));
}
