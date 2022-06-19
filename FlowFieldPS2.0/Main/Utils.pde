import java.util.Arrays;

public static boolean validVector(float Fx, float Fy, float check) {
    return Fx*Fx + Fy*Fy <= check*check;
}

public static boolean validVector(float Fx, float Fy, float Fz, float check) {
    return Fx*Fx + Fy*Fy + Fz*Fz <= check*check;
}

public static float sqMag(float... args) {
  float ret = 0;
  for(var fl : args) ret += fl*fl;
  return ret;
}

public static float setMagCoef(float x, float y, float mag) {
  return invSqrt(x*x + y*y) * mag;
}
public static float setMagCoef(float x, float y, float z, float mag) {
  return invSqrt(x*x + y*y + z*z) * mag;
}

// public static boolean withinBound

public float rvar(float x) {
  return random(-x, x);
}

public float rbou(float min, float max) {
  return random(min, max);
}

public static float invSqrt(float x) { // I didn't make this, of course
    float xhalf = 0.5f * x;
    int i = Float.floatToIntBits(x);
    
    i = 0x5f3759df - (i >> 1);
    x = Float.intBitsToFloat(i);
    
    x *= (1.5f - xhalf * x * x);
    
    return x;
}
