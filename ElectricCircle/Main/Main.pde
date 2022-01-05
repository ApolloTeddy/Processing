float r; // Radius of our circle.
PGraphics g; // Basically a canvas that can render transparent backgrounds.
float minInc = 0.01, maxInc = 1.05; // Minimum, and maximum values for our vertex count.
float minJitter = 1, maxJitter = 100; // Minimum, and maximum values for our circle jitter.

void setup()
{
  fullScreen(); // Fullscreen...
  r = height / 2.5; // Set the radius to a little under half the height, for good visibility on landscape monitors. fuck portrait.
  g = createGraphics(width, height); // Create our cool graphics renderer.
  frameRate(23); // Slow the framerate, makes it look a little cooler I think..
}

void draw()
{
  g.beginDraw(); // Start drawing to our canvas.
  g.background(0, 60); // Set the background to black (0) with an alpha of 60, alpha can be thought of as opacity (255 = 100% opaque)
  g.push(); // Push our draw changes to the stack.
  g.translate(width / 2, height / 2); // We want our circle drawn with the origin in the center of the screen.
  g.rotate(radians(-90)); // No real reason, I just want the circle to grow from the top. :)
  cosmetics(); // Grab our cosmetics from the cosmetics function.
  g.beginShape(); // Begin drawing our circle.
  for(float a = 0; a <= TWO_PI; a += map(mouseY, height, 0, minInc, maxInc)) // Circumference of a unit circle: 2PI, map the incrememnt to the mouseY
  {
    float jitter = map(mouseX, 0, width, minJitter, maxJitter); // Map the jitter range to the mouseX
    float jit = random(r - jitter, r + jitter); // Choose a random jitter value
    if(a + map(mouseY, height, 0, minInc, maxInc) - 1  <= TWO_PI) g.vertex(cos(a) * jit, sin(a) * jit); // cos(a) = AH, sin(a) = OH. Get point along radius offset by the jitter, using sine and cosine
  }
  g.endShape(CLOSE); // Stop drawing the circle.
  g.pop(); // Pop our draw changes from the stack.
  g.endDraw(); // Stop drawing to our fancy canvas.
  image(g, 0, 0); // Paste our image to processings stupid background.
}

void cosmetics()
{
  g.noFill(); // Empty circle!
  g.colorMode(HSB, 100); // For the variance in blueness!
  g.strokeWeight(3); // Thinner lines!
  g.stroke(random(47.6, 56.7), 77, 90); // Set the line color to a random blue-ish lightning looking color!
}
