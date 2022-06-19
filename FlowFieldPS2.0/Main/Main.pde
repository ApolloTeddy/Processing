PartiParty pHandler;
ArrayList<Particle> particles;
Layer lay;
FieldManager fHandler;

int spawnPadding = 200;
float inc = PI/35, scale = 0.3, b = 8f/3, s = 10, r = 28;

PVector slopeVector(float x, float y) {
  PVector out = new PVector();
  
  out.set(y, -x); // (x : run, y : rise)
  
  return out;
}

// d3y + x(dy/dx)dx3 - 4xydx3 = 0

// d2y/dx2 + 10dy/dx + 9y = 0
//  = 0

// dy/dx = x - y
// dy/dx = -x/y
// dy/dx = -yxk^2

void setup() {
  size(600, 600);
  
  graphics = createGraphics(width, height);
  
  pHandler = new PartiParty();
  fHandler = new FieldManager(12) {
    void populate() {
      float maximumMagnitude = 30;
      for(int y = 0; y < colsY; y++) {
        for(int x = 0; x < colsX; x++) {
          PVector f;
          float px = x-colsX/2, py = y-colsY/2;
          
          field[x][y] = slopeVector(px * scale, py * scale);
          f = field[x][y];
          
          if(sqMag(f.x, f.y) > sq(maximumMagnitude)) {
            field[x][y].setMag(maximumMagnitude);
            println("shortened");
          }
        }
      }
      findMax();
      findAvgMag();
    }
  };
  
  lay = pHandler.addLayer(new Layer(pHandler, 0, 0) {
    void show() {
       //<>//
    }
  });
  
  particles = lay.setCount(5000);
  
  lay.setSetting(p.SpawnVelMagMin, 0);
  lay.setSetting(p.SpawnVelMagMax, 0);
  lay.setSetting(p.MaxSpeed, 2);
  lay.setSetting(p.MaxForce, 1);
  lay.setSetting(p.MassMin, 1);
  lay.setSetting(p.MassMax, 1);
  lay.setSetting(p.Lifetime, 10);
  lay.setSetting(p.LifetimeVariance, 2);
  lay.setSetting(p.Separate, false);
  lay.setSetting(p.Expire, true);
  lay.setSetting(p.RandomizeMaxSpeed, false);
  lay.setSetting(p.RandomizeMaxForce, false);
  lay.setSetting(p.Tracer, true);
  lay.setSetting(p.TracerVerticeCount, 10);
  lay.setSetting(p.TracerExpireTime, 0.01);
  
  /*pHandler.addSpawnpoints(spawnPadding, spawnPadding,
                          width - spawnPadding, height - spawnPadding,
                          spawnPadding, height - spawnPadding,
                          width - spawnPadding, spawnPadding);
  */
  
  for(int x = 0; x <= width; x += width/50) {
    for(int y = 0; y <= height; y += height/50) {
      pHandler.addSpawnpoint(x, y);
    }
  }
                          
  fHandler.populate();
}

PGraphics graphics;
void draw() {
  background(0);
  
  for(var par : particles) {
    PVector force = fHandler.getVectorClosestTo(par.x, par.y); //<>//
    float sqMag = sqMag(force.x, force.y);
    float maxMag = fHandler.getMagMax();
    float avgMag = fHandler.getAvgMag();
    float ms = par.maxspeed;
    
    if(sqMag == Double.NaN || sqMag == Double.POSITIVE_INFINITY) sqMag = maxMag;
    float newMag = maxMag/sqMag;
    
    force.setMag(newMag);
    par.setVel(force);
  }
  
  //fHandler.show();
  
  pHandler.run();
  
  strokeWeight(1);
  stroke(#FF0000);
  
  pHandler.show();
}

class FieldManager {
  PVector[][] field;
  int colsX, colsY, res;
  float magMax = 0, avgMag = 0;
  
  FieldManager(int res) {
    this.res = res;
    colsX = width/res + 1;
    colsY = height/res + 1;
    
    field = new PVector[colsX][colsY];
  }
  
  float getMagMax() {
    return magMax;
  }
  
  float getAvgMag() {
    return avgMag;
  }
  
  void show() {
    for(int y = 0; y < colsY; y++) {
      for(int x = 0; x < colsX; x++) {
        PVector vec = field[x][y].copy();
        float vox = x * res, voy = y * res, sqmag = sqMag(vec.x, vec.y);
            
        
        stroke(map(sqmag, 0, magMax, 0, 255),
               map(sqmag, 0, magMax/1.5f, 255, 0),
               0);
               
        vec.setMag(5);
        
        line(vox, voy, vox + vec.x, voy + vec.y);
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
  
  void findMax() {
    magMax = 0; 
    for(var c : field) 
      for(var r : c) {
        float mag = sqMag(r.x, r.y);
        if(mag > magMax) magMax = mag; 
      }
  }
  void findAvgMag() {
    avgMag = 0;
    int count = 0;
    for(var c : field) {
      for(var r : c) {
        avgMag += sqMag(r.x, r.y);
        count++;
      }
    }
    avgMag /= count;
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
    
    findMax();
  }
}
