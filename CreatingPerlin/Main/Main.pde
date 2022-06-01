PerlinN n;
float increment = 0.02;
void setup() {
  size(600, 600);
  background(50);
  strokeWeight(2);
  n = new PerlinN(width, height);
}

void draw() {
  println("\n\n\n" + mouseX + ", " + mouseY);
  loadPixels();

  float xoff = 0.0; // Start xoff at 0
  float detail = map(mouseX, 0, width, 0.1, 0.6);
  noiseDetail(22, 0.02);
  
  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (int x = 0; x < width; x++) {
    xoff += increment;   // Increment xoff 
    float yoff = 0.0;   // For every xoff, start yoff at 0
    for (int y = 0; y < height; y++) {
      yoff += increment; // Increment yoff
      
      // Calculate noise and scale by 255
      float bright = n.noise(xoff, yoff) * 255;

      // Try using this line instead
      //float bright = random(0,255);
      
      // Set each pixel onscreen to a grayscale value
      pixels[x+y*width] = color(bright);
    }
  }
  
  updatePixels();
  n.showField();
}
void mousePressed() {
  saveFrame("noise_###.png");
}
