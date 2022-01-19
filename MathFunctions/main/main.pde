void setup() {
  println(cosine(74));
  println(cos(74));
  println(sine(74));
  println(sin(74));
}

float sine(float val) {
  val = ((val + PI) % TAU) - PI;
  float res = 0;
  int sign = 1;
  int power = 1;
  
  for(int i = 0; i < 15; i++) {
    res += pow(val, power) / fact(power) * sign; 
    sign *= -1;
    power += 2;
  }
  return res;
}

float cosine(float val) {
  val = ((val + PI) % TAU) - PI;
  float res = 1;
  int sign = -1;
  int power = 2;
  
  for(int i = 0; i < 15; i++) {
    res += pow(val, power) / fact(power) * sign; 
    sign *= -1;
    power += 2;
  }
  return res;
}

float fact(float val) {
  float res = val;
  for(float i = val-1; i > 0; i--) {
    res *= i;
  }
  return res;
}
