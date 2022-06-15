PartiParty pHandler;
ArrayList<Particle> particles;
Layer lay;
FieldManager fHandler;

int spawnPadding = 200;
float inc = PI/35;

float slope(float x, float y) {
  return x;
}

void setup() {
  size(700, 700);
  
  graphics = createGraphics(width, height);
  
  pHandler = new PartiParty();
  fHandler = new FieldManager(50) {
    void populate() {
      float scale = 100;
      for(int y = 0; y < colsY; y++) {
        for(int x = 0; x < colsX; x++) {
          float px = ((x*res)-(width/2)), py = (y*res)-(height/2);
          field[x][y] = new PVector(px + 1, py - slope(px, py));
        }
      }
    }
  };
  
  lay = pHandler.addLayer(new Layer(pHandler, 0, 0) {
    void show() {
      for(var mem : party) { //<>//
        graphics.line(mem.x, mem.y, mem.px, mem.py);
      }
    }
  });
  
  particles = lay.setCount(15000);
  
  lay.setSetting(p.SpawnVelMagMax, 3);
  lay.setSetting(p.MaxSpeedMin, 1);
  lay.setSetting(p.MaxSpeedMax, 3);
  lay.setSetting(p.MaxForceMin, 0.25);
  lay.setSetting(p.MaxForceMax, 1);
  lay.setSetting(p.MassMin, 1.25);
  lay.setSetting(p.MassMax, 3.6);
  lay.setSetting(p.Lifetime, 5);
  lay.setSetting(p.LifetimeVariance, 2);
  lay.setSetting(p.LoopEdges, true);
  lay.setSetting(p.Separate, false);
  lay.setSetting(p.Expire, true);
  lay.setSetting(p.RandomizeMaxSpeed, true);
  lay.setSetting(p.RandomizeMaxForce, true);
  
  /*pHandler.addSpawnpoints(spawnPadding, spawnPadding,
                          width - spawnPadding, height - spawnPadding,
                          spawnPadding, height - spawnPadding,
                          width - spawnPadding, spawnPadding);
  */
  pHandler.addSpawnpoint(width/2, height/2);
                          
  fHandler.populate();
}

PGraphics graphics;
void draw() {
  strokeWeight(5);
  point(width/2, height/2);
  
  for(var p : particles) {
    p.addForcePV(fHandler.getVectorClosestTo(p.x, p.y));
  }
  
  pHandler.run();
  
  strokeWeight(1);
  stroke(50);
  fHandler.show();
  
  graphics.beginDraw();
  graphics.background(0, 25);
  
  graphics.strokeWeight(1);
  graphics.strokeCap(SQUARE);
  graphics.stroke(#FF0000, 100);
  
  pHandler.show();
  graphics.endDraw();

  image(graphics, 0, 0);
}

class FieldManager {
  PVector[][] field;
  int colsX, colsY, res;
  
  FieldManager(int res) {
    this.res = res;
    colsX = width/res + 1;
    colsY = height/res + 1;
    
    field = new PVector[colsX][colsY];
  }
  
  void show() {
    for(int y = 0; y < colsY; y++) {
      for(int x = 0; x < colsX; x++) {
        PVector vec = field[x][y];
        float vox = x * res, voy = y * res;
        
        line(vox, voy, vox + vec.x * 25, voy + vec.y * 25);
      }
    }
  }
  
  PVector getVectorClosestTo(float x, float y) {
    float normX = x / res, normY = y / res;
    
    int roundedX = floor(normX + 0.5f), roundedY = floor(normY + 0.5f);
    
    roundedX = constrain(roundedX, 0, colsX - 1);
    roundedY = constrain(roundedY, 0, colsY - 1);
    
    return field[roundedX][roundedY];
  }
  
  void populate() {
    noiseDetail(12, 0.25);
    
    float yoff = 0;
    for(int y = 0; y < colsY; y++) {
      float xoff = 0;
      for(int x = 0; x < colsX; x++) {
        float theta = noise(xoff, yoff) * TAU;
        field[x][y] = PVector.fromAngle(theta).setMag(random(1));
        xoff += inc;
      }
      yoff += inc; //<>//
    }
  }
}
