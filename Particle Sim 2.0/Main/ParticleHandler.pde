static class p {
  static final int Expire = 0,
                   RespawnOnExpire = 1,
                   Separate = 2,
                   LoopEdges = 3,
                   
                   ParticleLifetime = 4,
                   LifetimeVariance = 5,
                   MaxSpeed = 6,
                   MaxForce = 7,
                   SpawnRadius = 8,
                   SpawnVelMagMin = 9,
                   SpawnVelMagMax = 10,
                   MassMin = 11,
                   MassMax = 12,
                   SepRadius = 13,
                   SepStrength = 14;
                   
  static final int NumBoolSettings = 4;
}
enum P_STATES {
  ALIVE,
  RESPAWNING,
  DELETE
}

/*



*/

class PartiParty {
  ArrayList<float[]> spawnPoints = new ArrayList();
  ArrayList<Layer> layers = new ArrayList();
  
  void addSpawnpoint(float px, float py) {
    spawnPoints.add(new float[] {px, py});
  }
  void addSpawnpoints(float... points) {
    if(points.length % 2 != 0) return;
    
    for(int i = 0; i < points.length-1; i += 2) addSpawnpoint(points[i], points[i+1]);
  }
  
  Layer addLayer(Layer lay) {
    layers.add(lay);
    return lay;
  }
  
  void preset(int index) {
    Layer lay;
    switch(index) {
      case 1:
        for(float t = 0; t < TAU; t += TAU/12) addSpawnpoint(width/2 + width/2.5 * cos(t), height/2 + width/2.5 * sin(t));
      
        lay = addLayer(new Layer(this, 175, 4) {
          void show() {
            push();
            colorMode(RGB, 100);
            
            for(var mem : party) {
              strokeWeight(2.75);
              
              stroke(#27E7FF, 
                     3 * (queryRadius(mem.x, mem.y, 10.25).length - 1)); 
              
              point(mem.x, mem.y);
            }
            pop();
          }
        });
        lay.setCount(1750);
        
        lay.setSetting(p.MaxSpeed, 15);
        lay.setSetting(p.MaxForce, 2.5);
        lay.setSetting(p.Separate, true);
        lay.setSetting(p.SepRadius, 10);
        lay.setSetting(p.MassMin, 1.75);
        lay.setSetting(p.MassMax, 2.5);  
        lay.setSetting(p.Expire, false);
        
        lay = addLayer(new Layer(this, 75, 3) {
          void show() {
            push();
            colorMode(HSB, 360, 100, 100, 100);
            
            for(var mem : party) {
              int countNeighbors = par.queryAllRadius(mem.x, mem.y, 10.25).length - 1;
              
              strokeWeight(2.75);
              
              stroke(195,
                     15 + 40.5 * countNeighbors, 
                     100, 
                     100 - 25 * countNeighbors); // 0 - 4 -> 100 - 0 -> 100 + -25 * countNeighbors
              
              point(mem.x, mem.y);
            }
            pop();
          }
        });
        lay.setCount(750);
        
        lay.setSetting(p.MaxSpeed, 15);
        lay.setSetting(p.MaxForce, 2.5);
        lay.setSetting(p.Separate, true);
        lay.setSetting(p.SepRadius, 50);
        lay.setSetting(p.MassMin, 1.75);
        lay.setSetting(p.MassMax, 2.5);  
        lay.setSetting(p.Expire, false);
        break;
      case 2:
        int dx = width/25, dy = height/25;
        for(int x = dx; x < width; x += dx) for(int y = dy; y < height; y += dy) addSpawnpoint(x, y);
      
        lay = addLayer(new Layer(this, 10, 4) {
          void show() {
            push();
            colorMode(RGB, 100);
            strokeCap(ROUND);
            
            for(var mem : party) {
              //strokeWeight(4.25);
              
              //stroke(100, 20); 
              //point(mem.x, mem.y);
              
              for(var n : queryRadius(mem.x, mem.y, 150)) { // 
                if(n == mem) continue;
                float sqdist = sq(mem.x - n.x) + sq(mem.y - n.y);
                
                strokeWeight(map(sqdist, 0, 22500, 4, 0));
                stroke(#FFFF00, map(sqdist, 0, 22500, 30, 0));
                
                line(mem.x, mem.y, n.x, n.y);
              }
            }
            pop();
          }
        });
        lay.setCount(60);
        
        lay.setSetting(p.MaxSpeed, 1.75);
        lay.setSetting(p.Separate, false);
        lay.setSetting(p.SpawnVelMagMin, 0.25);
        lay.setSetting(p.SpawnVelMagMax, 1.75);
        lay.setSetting(p.MassMin, 1);
        lay.setSetting(p.MassMax, 1);  
        lay.setSetting(p.ParticleLifetime, 2);
        lay.setSetting(p.LifetimeVariance, 3);
        break;
    }
  }
  
  void goTo(float x, float y, float... amp) {
    for(var lay : layers) lay.goTo(x, y, amp); 
  }
  
  ArrayList<Particle> partyOf(int index) {
    return layers.get(index).party;
  }
  
  void run() {
    for(var lay : layers) lay.updateLayer();
  }
  
  void show() {
    for(var lay : layers) lay.show();
  }
  
  void swapLayerOrder(int indA, int indB) {
    if(indA < 0 || indB < 0 || layers.size() < 1 || indA > layers.size()-1 || indB > layers.size() - 1) return;
    var tmp = layers.get(indA);
    
    layers.set(indA, layers.get(indB));
    layers.set(indB, tmp);
  }
  
  Particle[] queryLayersRadius(float x, float y, float r, int... layerIndices) {
    ArrayList<Particle> out = new ArrayList();
    
    for(int i = 0; i < layerIndices.length; i++) 
      for(var found : layers.get(layerIndices[i]).queryRadius(x, y, r)) out.add(found);
    
    return out.toArray(new Particle[out.size()]);
  }
  
  Particle[] queryAllRadius(float x, float y, float r) {
    ArrayList<Particle> out = new ArrayList();
    
    for(var lay : layers) for(var found : lay.queryRadius(x, y, r)) out.add(found);
    
    return out.toArray(new Particle[out.size()]);
  }
}

class Layer {
  ArrayList<Particle> party = new ArrayList();
  int memberCount = 0;
  
  PQTree tree;
  
  float[] floatSettings = { 7, 3,    // ParticleLifetime, LifetimeVariance
                            7, 0.6,  // MaxSpeed, MaxForce
                            50,      // SpawnRadius
                            1, 2.5,  // SpawnVelMagMin, SpawnVelMagMax
                            0.5, 2,  // MassMin, MassMax
                            3, 0.3 };// SepRadius, SepStrength
                            
  boolean[] boolSettings = { true,   // Expire
                             true,   // RespawnOnExpire
                             true,   // Separate
                             false}; // LoopEdges
 
  void setSetting(int Setting, float value) {
    floatSettings[Setting - p.NumBoolSettings] = value;
  }
  void setSetting(int Setting, boolean value) {
    boolSettings[Setting] = value;
  }
  
  float getSettingf(int Setting) {
    return floatSettings[Setting - p.NumBoolSettings];
  }
  boolean getSettingb(int Setting) {
    return boolSettings[Setting];
  }
  
  PartiParty par;
  
  Layer(PartiParty parent, int QTCap, int QTMaxdepth) {
    tree = new PQTree(width/2, height/2, width/2, QTCap, QTMaxdepth);
    par = parent;
  }
  
  Particle[] queryRadius(float x, float y, float r) {
    return tree.queryRadius(x, y, r);
  }
  
  void setCount(int count) {
    while(memberCount < count) {
      Particle p = new Particle(this);
      party.add(p);
      memberCount++;
      tree.insert(p);
    }
    while(memberCount > count) {
      party.remove(memberCount);
      memberCount--;
    }
  }
  
  void show() {
    for(var mem : party) {
      point(mem.x, mem.y);
    }
  }
  
  void goTo(float x, float y, float... amp) {
    for(var mem : party) {
      float fx = x - mem.x, fy = y - mem.y;
      
      if(amp.length < 1) mem.addForce(fx, fy); else mem.addForce(fx, fy, amp[0]);
    }
  }
  
  void updateLayer() {
    float SpawnRadius = getSettingf(p.SpawnRadius),
          SpawnVelMagMin = getSettingf(p.SpawnVelMagMin),
          SpawnVelMagMax = getSettingf(p.SpawnVelMagMax),
          MassMin = getSettingf(p.MassMin),
          MassMax = getSettingf(p.MassMax),
          ParticleLifetime = getSettingf(p.ParticleLifetime),
          LifetimeVariance = getSettingf(p.LifetimeVariance);
    
    for(int i = 0; i < memberCount; i++) {
      Particle mem = party.get(i);
      
      switch(mem.state){
        case ALIVE:
          mem.updatePosition();
          break;
        case RESPAWNING:
          float spawnPoint[] = par.spawnPoints.get(int(random(par.spawnPoints.size()))),
                t = random(TAU), d = random(SpawnRadius), d2 = rbou(SpawnVelMagMin, SpawnVelMagMax);
          
          mem.x = spawnPoint[0] + d * cos(t); mem.y = spawnPoint[1] + d * sin(t);
          mem.mass = rbou(MassMin, MassMax);
          
          mem.init();
          mem.setVel(d2 * cos(t), d2 * sin(t));
          mem.expireTime = mem.spawnTime + (long)((ParticleLifetime + rvar(LifetimeVariance)) * pow(10, 9));
          break;
        case DELETE:
          party.remove(i);
          i--;
          break;
      }
    }
    tree.buildTree(party);
  }
}

class Particle {
  float x, y,
        vx, vy,
        ax, ay;
        
  long spawnTime, //<>//
       expireTime;
  
  float mass;
  
  Layer par;
  P_STATES state = P_STATES.RESPAWNING;
  
  Particle(Layer parent) {
    par = parent;
  }
   //<>//
  void init() {
    vx = 0; vy = 0;
    ax = 0; ay = 0;
    
    state = P_STATES.ALIVE;
    spawnTime = System.nanoTime();
  }
  
  void addForce(float fx, float fy, float... amp) {
    float mF = par.getSettingf(p.MaxForce);
    if(!validVector(fx, fy, mF)) {
      var newMag = setMagCoef(fx, fy, mF);
      
      fx *= newMag; fy *= newMag;
    }
    if(amp.length == 0) { ax += fx/mass; ay += fy/mass; }
    else { ax += (amp[0]*fx)/mass; ay += (amp[0]*fy)/mass; }
  }
  
  void setVel(float fx, float fy) {
    float mS = par.getSettingf(p.MaxSpeed);
    if(!validVector(fx, fy, mS)) {
      var newMag = setMagCoef(fx, fy, mS);
      
      fx *= newMag; fy *= newMag;
    }
    vx = fx; vy += fy;
  }
  
  void expiry() {
    if(par.getSettingb(p.RespawnOnExpire)) state = P_STATES.RESPAWNING;
    else state = P_STATES.DELETE;
  }
  
  void accelerationForces() {
    if(par.getSettingb(p.Separate)) { //<>//
      Particle[] others = par.queryRadius(x, y, par.getSettingf(p.SepRadius));
      if(others.length < 2) return;
      
      float avx = 0, avy = 0;
      
      for(var other : others) {
        if(other == this) continue;
        float dx = x - other.x, dy = y - other.y,
              sqdist = dx*dx + dy*dy;
        
        dx /= sqdist; dy /= sqdist; //<>//
        avx += dx; avy += dy;
      }
      var d = setMagCoef(avx, avy, par.getSettingf(p.MaxForce));
      
      avx *= d; avy *= d;
      
      addForce(avx, avy, par.getSettingf(p.SepStrength));
    }
  }
  
  void updatePosition() {
    accelerationForces();
    
    vx += ax; vy += ay;
    
    float mS = par.getSettingf(p.MaxSpeed);
    if(!validVector(vx, vy, mS)) {
      var newMag = setMagCoef(vx, vy, mS);
      
      vx *= newMag; vy *= newMag;
    }
    
    x += vx; y += vy;
    ax = 0; ay = 0;
    
    if(par.getSettingb(p.LoopEdges)) {
      if(x > width) x = 1;
      if(x < 0) x = width-1;
      if(y > height) y = 1;
      if(y < 0) y = height-1;
    }
    
    if(System.nanoTime() > expireTime && par.getSettingb(p.Expire)) expiry();
  }
}
