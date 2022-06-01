ComplexNumber a, b;
void setup() {
  a = new ComplexNumber(0, 1);
  b = new ComplexNumber(0, 1);
  println(ComplexNumber.mult(a, b));
}

static class ComplexNumber {
  float re, im, theta, hypot;
  ComplexNumber(float re, float im) {
    this.re = re;
    this.im = im;
    theta = degrees(atan(im/re));
    hypot = sqrt(sq(re) + sq(im));
  }
  ComplexNumber(float hypot, float theta, boolean dummy) {
    this.theta = theta;
    this.hypot = hypot;
    re = hypot*cos(radians(theta));
    im = hypot*sin(radians(theta));
  }
  
  void setR(float hypot, float theta) {
    this.theta = theta;
    this.hypot = hypot;
    re = hypot*cos(radians(theta));
    im = hypot*sin(radians(theta));
  }
  void set(float re, float im) {
    this.re = re;
    this.im = im;
    theta = degrees(atan(im/re));
    hypot = sqrt(sq(re) + sq(im));
  }
  
  String toPolarForm() {
    return hypot + "e^i" + theta;
  }
  
  String toString() {
    return re + " + " + im + "i";
  }
  
  static ComplexNumber add(ComplexNumber a, ComplexNumber b) {
    return new ComplexNumber(a.re + b.re, a.im + b.im);
  }
  
  static ComplexNumber sub(ComplexNumber a, ComplexNumber b) {
    return new ComplexNumber(a.re - b.re, a.im - b.im);
  }
  
  static ComplexNumber mult(ComplexNumber a, ComplexNumber b) {
    return new ComplexNumber(a.hypot * b.hypot, a.theta + b.theta, false);
  }
}
