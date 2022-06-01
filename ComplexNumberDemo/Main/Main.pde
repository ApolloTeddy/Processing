ComNum a, b, c;
cMath m;
void setup() {
  println(new ComNum(30, 40, 0, false).hypot);
  size(400, 400);
  m = new cMath();
  a = new ComNum(2, 10, color(127, 0, 0), false);
  b = new ComNum(-6, -10, color(0, 0, 127), false);
}

void draw() {
  if(mouseButton == LEFT) {
    a.set(mouseX-width/2, -mouseY+height/2, false);
  } else if(mouseButton == RIGHT) {
    b.set(mouseX-width/2, -mouseY+height/2, false);
  }
  c = m.mult(a, b);
  c.c = color(0, 127, 0);
  background(70);
  push();
  translate(width/2, height/2);
  a.show();
  b.show();
  c.show();
  pop();
}

class cMath {
  ComNum mult(ComNum a, ComNum b) {
    return new ComNum(a.hypot*b.hypot, a.theta+b.theta, 0, true);
  }
}

class ComNum {
  float real, imag, hypot, theta;
  color c;
  ComNum(float re_hy, float im_th, color c, boolean polar) {
    set(re_hy, im_th, polar);
    this.c = c;
  }
  
  void show() {
    push();
    stroke(c);
    strokeWeight(3);
    line(0, 0, real, -imag);
    stroke(0);
    strokeWeight(4);
    point(real, -imag);
    pop();
  }
  
  void sub(ComNum z) {
    set(real-z.real, imag-z.imag, false);
  }
  
  void add(ComNum z) {
    set(real+z.real, imag+z.imag, false);
  }
  
  void mult(ComNum z) {
    set(hypot*z.hypot, theta+z.theta, true);
  }
  
  void div(ComNum z) {
    set(hypot/z.hypot, theta-z.theta, true);
  }
  
  void set(float re_hy, float im_th, boolean polar) {
    if(polar) {
      hypot = re_hy;
      theta = im_th;
      real = hypot*cos(im_th);
      imag = hypot*sin(im_th);
    } else {
      real = re_hy;
      imag = im_th;
      hypot = sqrt(sq(re_hy) + sq(im_th));
      theta = atan(imag/real);
    }
  }
}
