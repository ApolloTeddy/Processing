int accuracy = 10;

void setup() {
  println(sin(72));
  println(sine(72));
  println(cos(72));
  println(cosine(72));
}

float cosine(float val) {
  val = ((val + PI) % TAU) - PI;
  float result = 0;
  
  int sign = 1;
  int power = 0;
  
  for(int i = 0; i < accuracy; i++) {
    result += power(val, power) / fact(power) * sign;
    sign *= -1;
    power += 2;
  }
  return result;
}

float sine(float val) {
  val = ((val + PI) % TAU) - PI;
  float result = 0; //<>//
  
  int sign = 1;
  int power = 1;
  
  for(int i = 0; i < accuracy; i++) {
    result += power(val, power) / (float)fact(power) * sign;
    sign *= -1;
    power += 2;
  }
  return result;
}

float power(float val, int power) {
  float tmp = val;
  for(int i = 1; i < power; i++) {
    val *= tmp;
  }
  return val;
}

int fact(float val) {
  int tmp = (int)val;
  int res = tmp;
  for(int i = tmp - 1; i > 0; i--) {
    res *= i;
  }
  return res;
}
