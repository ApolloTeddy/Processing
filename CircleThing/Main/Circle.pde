color[] colors = new color[] { color(255, 0, 0), color(255, 154, 3), color(255, 247, 3), color(0, 255, 0), color(3, 202, 255), color(255, 0, 255)}; // An array to hold all of the colors our circles will need!

class Circle
{
  PVector pos; // PVector that stores our position.
  float r; // Floating point value that stores our radius.
  
  Circle(float x, float y, int r) // Constructor
  {
    this.pos = new PVector(x, y); // Set our position to the x and y from our constructor.
    this.r = r; // Set our radius from the constructor.
  }
  
  void show() // Code to show the circles!
  {
    int currentColor = 0; // Current index of the color we want, from our array of colors.
    for(float i = 3.1; i > 0; i -= 0.4) // Some numbers I messed around with, you can too!
    {
      fill(colors[currentColor]); // Fill the color from our array at the index of our currentColor.
      circle(this.pos.x, this.pos.y, this.r * i); // Create a new circle with our radius multiplied by i
      currentColor++; // Increase our color index.
      if(currentColor > 5) currentColor = 0; // If our current color becomes too big, loop it back around to 0.
    }
  }
}
