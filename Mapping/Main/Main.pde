PVector point = new PVector(0, 0); // Point for our Saturation/Brightness picker.

float hue, sat, bri; // Variables for our Hue, Saturation, and Brightness (HSB)
float sensitivity = 5, animationSpeed = 1; // Scrolling, and animation sensitivity

boolean showPoint = true, animate = false; // animate makes the bg scroll rainbow, depending on the animationSpeed

void setup() // called before the first frame update
{
  fullScreen(); // big window
  
  colorMode(HSB, 255); // Set our colorMode to HSB, with a range 0-255
  
  point.set(width / 2, height / 2); // our initial color picked is the center of the screen.
  
}

void draw() // called every frame update
{
  if(animate) hue += animationSpeed; // if animate is true, scroll the hue up by the animationSpeed
  
  if(hue > 255)
    hue = 0; // if hue gets too big, reset it to 0
  else if(hue < 0)
    hue = 255; // if hue gets too small, reset it to 255
    
  background(color(hue, sat, bri)); // makes the background the color we get from mapping our point to a HSB value
  
  if(mouseButton == LEFT) point.set(mouseX, mouseY); // if we are left clicking, set the point to our mouse
  
  sat = map(point.x, 0, width, 0, 255); // map our x mouse to the saturation
  bri = map(height - point.y, 0, height, 0, 255); // map our y mouse to the brightness
  
  if(showPoint)
  {
    stroke(80);
    strokeWeight(7);
    point(point.x, point.y); // If showPoint is true, show the point
  }
}

void mousePressed() // Called when the user clicks the mouse
{
  if(mouseButton == RIGHT) showPoint = !showPoint; // If the user right clicked, invert showPoint
  if(mouseButton == CENTER) animate = !animate; // If the user middle clicked, invert animate
}

void mouseWheel(MouseEvent ev) // Called when the user scrolls
{
  float e = ev.getCount(); // scrolling away, e is negative, scrolling towards, e is positive
  
  if(e > 0) hue += sensitivity; // if scrolling toward user, increase hue by sensitivity
  else hue -= sensitivity; // if scrolling away from user, decrese hue by sensitivity
}
