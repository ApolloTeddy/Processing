
Diamond dim;
int T = 100, B = 100, R = 100, L = 100, A = 1;
float increment = 1, angleIncrement = 0.1;

void setup()
{
  fullScreen();
  dim = new Diamond(width / 2, height / 2);
}

void draw()
{
  background(110);
  fill(50);
  dim.show(T, B, L, R, A);
  if(keyPressed)
    switch(key)
    {
      case 'd': // Left out +
      case 'D':
        if(!(L + increment > width / 2)) L += increment;
        break;
      case 'f': // Left in - 
      case 'F':
        if(!(L - increment > 1)) L -= increment;
        break;
      case 'g': // Bottom up -
      case 'G':
        if(!(B - increment < 1)) B -= increment;
        break;
      case 'v': // Bottom down +
      case 'V':
        if(!(B + increment > height / 2)) B += increment;
        break;
      case 'h': // Right in -
      case 'H':
        if(!(R - increment < 1)) R -= increment;
        break;
      case 'j': // Right out +
      case 'J':
        if(!(R + increment > width / 2)) R += increment;
        break;
      case 'w': // Up up +
      case 'W':
        if(!(T + increment > height / 2)) T += increment;
        break;
      case 's': // up down -
      case 'S':
        if(!(T - increment < 1)) T -= increment;
        break;
    }
}
