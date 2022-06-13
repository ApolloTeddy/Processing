import java.util.Arrays;

public static boolean validVector(float Fx, float Fy, float check) {
    return Fx*Fx + Fy*Fy <= check*check;
}

public static float setMagCoef(float x, float y, float mag) {
  return invSqrt(x*x + y*y) * mag;
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
