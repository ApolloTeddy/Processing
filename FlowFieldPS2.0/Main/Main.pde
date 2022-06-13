PartiParty pHandler;
ArrayList<Particle> particles;
Layer lay;
FieldManager fHandler;

int spawnPadding = 200;

void setup() {
  size(700, 700);
  graphics = createGraphics(width, height);
  
  pHandler = new PartiParty();
  fHandler = new FieldManager(25);
  
  lay = pHandler.addLayer(new Layer(pHandler, 0, 0) {
    void show() {
      for(var mem : party) {
        graphics.point(mem.x, mem.y);
      }
    }
  });
  
  particles = lay.setCount(2500);
  
  lay.setSetting(p.SpawnVelMagMax, 15);
  lay.setSetting(p.MaxSpeed, 3);
  lay.setSetting(p.MaxForce, 1);
  lay.setSetting(p.LoopEdges, true);
  lay.setSetting(p.Expire, false);
  /*pHandler.addSpawnpoints(spawnPadding, spawnPadding,
                          width - spawnPadding, height - spawnPadding,
                          spawnPadding, height - spawnPadding,
                          width - spawnPadding, spawnPadding);
  */pHandler.addSpawnpoint(width/2, height/2);
  fHandler.populate();
  
  noiseDetail(12, 0.5);
}

PGraphics graphics;
void draw() {
  background(20);
  
  for(var p : particles) {
    p.addForcePV(fHandler.getVectorClosestTo(p.x, p.y));
  }
  
  pHandler.run();
  
  //strokeWeight(1);
  //stroke(50);
  //fHandler.show();
  
  graphics.beginDraw();
  graphics.strokeWeight(1);
  graphics.stroke(#FFE600, 10);
  pHandler.show();
  graphics.endDraw();

  image(graphics, 0, 0);
}

class FieldManager {
  PVector[][] field;
  int resW, resH;
  
  FieldManager(int res) {
    resW = width/res;
    resH = height/res;
    
    field = new PVector[resW][resH];
  }
  
  void show() {
    for(int y = 0; y < resH; y++) {
      for(int x = 0; x < resW; x++) {
        PVector vec = field[x][y];
        float vox = x * resW, voy = y * resH;
        
        line(vox, voy, vox + vec.x * 25, voy + vec.y * 25);
      }
    }
  }
  
  PVector getVectorClosestTo(float x, float y) {
    float normX = x / resW, normY = y / resH;
    
    int roundedX = floor(normX + 0.5f), roundedY = floor(normY + 0.5f);
    
    roundedX = constrain(roundedX, 0, resW - 1);
    roundedY = constrain(roundedY, 0, resH - 1);
    
    return field[roundedX][roundedY];
  }
  
  PVector generateVector(float x, float y) {
    return PVector.fromAngle(noise(x / 300, y / 300) * TAU);
  }
  
  void populate() {
    for(int y = 0; y < resH; y++) {
      for(int x = 0; x < resW; x++) {
        field[x][y] = generateVector(x * resW, y * resH);
      }
    }
  }
}
