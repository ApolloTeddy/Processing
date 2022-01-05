class Diamond
{
  int x, y;
  
  Diamond(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
  
  public void show(int T, int B, int L, int R, int A)
  {
    float theta = A + radians(90);
    
    pushMatrix();
    rotate(theta);
    beginShape();
    vertex(x, y + T);
    vertex(x + R, y);
    vertex(x, y - B);
    vertex(x - L, y);
    endShape();
    popMatrix();
  }
}
