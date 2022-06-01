import java.util.Random; //<>//
class PerlinN {
  PVector[] field[];
  Random ran;
  float frequency;
  int octaves, seed;
  
  PerlinN() {
    octaves = 4;
    setSeed(int(random(9999999)));
  }
  
  void genField() {
    field = new PVector[int(width/frequency)][int(height/frequency)];
    for(int x = 0; x < field.length; x++) {
      for(int y = 0; y < field[x].length; y++) {
        field[x][y] = randomGrad(x, y);
      }
    }
  }
  
  PVector randomGrad(int x, int y) {
    int w = field.length, h = field[0].length, s = 8;
    x *= seed ^= w/2 | s ^ h;
  }
  
  void setSeed(int newSeed) {
    seed = newSeed;
  }
  
  void noise(float x, float y) {
    if(field == null) genField();
  }
}
