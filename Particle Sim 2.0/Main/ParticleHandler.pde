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
      
        lay = addLayer(new Layer(party, 175, 4) {
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
        lay.MaxSpeed = 15;
        lay.MaxForce = 2.5;
        lay.Separate = true;
        lay.SepRadius = 10;
        lay.setCount(1750);
        lay.MassMin = 1.75;
        lay.MassMax = 2.5;  
        lay.Expire = false;
        
        lay = addLayer(new Layer(party, 75, 3) {
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
        lay.MaxSpeed = 15;
        lay.MaxForce = 2.5;
        lay.Separate = true;
        lay.SepRadius = 50;
        lay.setCount(750);
        lay.MassMin = 1.75;
        lay.MassMax = 2.5;  
        lay.Expire = false;
        break;
      case 2:
        int dx = width/25, dy = height/25;
        for(int x = dx; x < width; x += dx) for(int y = dy; y < height; y += dy) party.addSpawnpoint(x, y);
      
        lay = party.addLayer(new Layer(party, 15, 3) {
          void show() {
            push();
            colorMode(RGB, 100);
            strokeCap(ROUND);
            
            for(var mem : party) {
              //strokeWeight(4.25);
              
              //stroke(100, 20); 
              //point(mem.x, mem.y);
              
              for(var n : queryRadius(mem.x, mem.y, 100)) {
                if(n == mem) continue;
                float sqdist = sq(mem.x - n.x) + sq(mem.y - n.y);
                
                strokeWeight(4 - 0.0003 * sqdist);
                stroke(100, 30 - 0.003 * sqdist);
                
                line(mem.x, mem.y, n.x, n.y);
              }
            }
            pop();
          }
        });
        lay.setCount(125);
        lay.Separate = false;
        lay.MaxSpeed = 1.25;
        lay.SpawnVelMagMax = 3.5;
        lay.SpawnVelMagMin = 3.5;
        lay.MassMin = 1;
        lay.MassMax = 1;
        lay.ParticleLifetime = 8;
        lay.LifetimeVariance = 5;
        break;
    }
  }
  
  void goTo(float x, float y, float... amp) {
    for(var lay : layers) lay.goTo(x, y, amp); 
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
  
  float ParticleLifetime = 7, LifetimeVariance = 3,
        MaxSpeed = 7, MaxForce = 0.6, 
        SpawnRadius = 50,
        SpawnVelMagMin = 1, SpawnVelMagMax = 2.5,
        MassMin = 0.5, MassMax = 2,
        SepRadius = 3, SepStrength = 0.3;
  boolean Expire = true, RespawnOnExpire = true, Separate = true;
  
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
    
  }
  
  void goTo(float x, float y, float... amp) {
    for(var mem : party) {
      float fx = x - mem.x, fy = y - mem.y;
      
      if(amp.length < 1) mem.addForce(fx, fy); else mem.addForce(fx, fy, amp[0]);
    }
  }
  
  void updateLayer() {
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
        
  long spawnTime,
       expireTime;
  
  float mass;
  
  Layer par;
  P_STATES state = P_STATES.RESPAWNING;
  
  Particle(Layer parent) {
    par = parent;
  }
  
  void init() {
    vx = 0; vy = 0;
    ax = 0; ay = 0;
    
    state = P_STATES.ALIVE;
    spawnTime = System.nanoTime();
  }
  
  void addForce(float fx, float fy) {
    if(!validVector(fx, fy, par.MaxForce)) {
      var newMag = setMagCoef(fx, fy, par.MaxForce);
      
      fx *= newMag; fy *= newMag;
    }
    ax += fx/mass; ay += fy/mass;
  }
  void addForce(float fx, float fy, float amp) {
    if(!validVector(fx, fy, par.MaxForce)) {
      var newMag = setMagCoef(fx, fy, par.MaxForce);
      
      fx *= newMag; fy *= newMag;
    }
    ax += (amp*fx)/mass; ay += (amp*fy)/mass;
  }
  
  void setVel(float fx, float fy) {
    if(!validVector(fx, fy, par.MaxSpeed)) {
      var newMag = setMagCoef(fx, fy, par.MaxSpeed);
      
      fx *= newMag; fy *= newMag;
    }
    vx = fx; vy += fy;
  }
  
  void expiry() {
    if(System.nanoTime() > expireTime) {
      if(par.RespawnOnExpire) state = P_STATES.RESPAWNING;
      else state = P_STATES.DELETE;
    }
  }
  
  void accelerationForces() {
    if(par.Separate) { //<>//
      Particle[] others = par.queryRadius(x, y, par.SepRadius);
      if(others.length < 2) return;
      
      float avx = 0, avy = 0;
      
      for(var other : others) {
        if(other == this) continue;
        float dx = x - other.x, dy = y - other.y,
              sqdist = dx*dx + dy*dy;
        
        dx /= sqdist; dy /= sqdist; //<>//
        avx += dx; avy += dy;
      }
      var d = setMagCoef(avx, avy, par.MaxForce);
      
      avx *= d; avy *= d;
      
      addForce(avx, avy, par.SepStrength);
    }
  }
  
  void updatePosition() {
    accelerationForces();
    
    vx += ax; vy += ay;
    
    if(!validVector(vx, vy, par.MaxSpeed)) {
      var newMag = setMagCoef(vx, vy, par.MaxSpeed);
      
      vx *= newMag; vy *= newMag;
    }
    
    x += vx; y += vy;
    ax = 0; ay = 0;
    
    if(par.Expire) expiry();
  }
}
