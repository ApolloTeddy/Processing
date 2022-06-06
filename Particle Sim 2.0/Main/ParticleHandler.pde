class PartiParty {
  ArrayList<Particle> party = new ArrayList();
  ArrayList<float[]> spawnPoints = new ArrayList();
  int memberCount = 0;
  
  PQTree tree = new PQTree(width/2, height/2, width/2, 75*2);
  
  float ParticleLifetime = 7, LifetimeVariance = 3,
        MaxSpeed = 7, MaxForce = 0.6, 
        SpawnRadius = 50,
        SpawnVelMagMin = 1, SpawnVelMagMax = 2.5,
        MassMin = 0.5, MassMax = 2,
        SepRadius = 3, SepStrength = 0.3;
  boolean Expire = true, RespawnOnExpire = true, Separate = true;
  
  void show() {
    for(var mem : party) point(mem.x, mem.y);
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
  
  void addSpawnpoint(float px, float py) {
    spawnPoints.add(new float[] {px, py});
  }
  void addSpawnpoints(float... points) {
    if(points.length % 2 != 0) return;
    for(int i = 0; i < points.length-1; i += 2) {
      spawnPoints.add(new float[] {points[i], points[i+1]}); 
    }
  }
  
  void goTo(float x, float y) {
    for(var mem : party) {
      float fx = x - mem.x, fy = y - mem.y;
      
      mem.addForce(fx, fy);
    }
  }
  
  void run() {
    for(int i = 0; i < memberCount; i++) {
      Particle mem = party.get(i);
      
      switch(mem.state){
        case ALIVE:
          mem.updatePosition();
          break;
        case RESPAWNING:
          float spawnPoint[] = spawnPoints.get(int(random(spawnPoints.size()))),
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
  
  Particle[] queryRadius(float x, float y, float r) {
    return tree.queryRadius(x, y, r);
  }
}

class Layer {
  
}

class Particle {
  float x, y,
        vx, vy,
        ax, ay;
        
  long spawnTime,
       expireTime;
  
  float mass;
  
  PartiParty party;
  P_STATES state = P_STATES.RESPAWNING;
  
  Particle(PartiParty parent) {
    party = parent;
  }
  
  void init() {
    vx = 0; vy = 0;
    ax = 0; ay = 0;
    
    state = P_STATES.ALIVE;
    spawnTime = System.nanoTime();
  }
  
  void addForce(float fx, float fy) {
    if(!validVector(fx, fy, party.MaxForce)) {
      float newMag = setMagCoef(fx, fy, party.MaxForce);
      
      fx *= newMag; fy *= newMag;
    }
    ax += fx/mass; ay += fy/mass;
  }
  void addForce(float fx, float fy, float amp) {
    if(!validVector(fx, fy, party.MaxForce)) {
      float newMag = setMagCoef(fx, fy, party.MaxForce);
      
      fx *= newMag; fy *= newMag;
    }
    ax += (amp*fx)/mass; ay += (amp*fy)/mass;
  }
  
  void setVel(float fx, float fy) {
    if(!validVector(fx, fy, party.MaxSpeed)) {
      float newMag = setMagCoef(fx, fy, party.MaxSpeed);
      
      fx *= newMag; fy *= newMag;
    }
    vx = fx; vy += fy;
  }
  
  void expiry() {
    if(System.nanoTime() > expireTime) {
      if(party.RespawnOnExpire) state = P_STATES.RESPAWNING;
      else state = P_STATES.DELETE;
    }
  }
  
  void accelerationForces() {
    if(party.Separate) { //<>//
      Particle[] others = party.queryRadius(x, y, party.SepRadius);
      if(others.length < 2) return;
      
      float avx = 0, avy = 0;
      
      for(var other : others) {
        if(other == this) continue;
        float dx = x - other.x, dy = y - other.y,
              sqdist = dx*dx + dy*dy;
        
        dx /= sqdist; dy /= sqdist;
        avx += dx; avy += dy;
      }
      float d = setMagCoef(avx, avy, party.MaxForce);
      
      avx *= d; avy *= d;
      
      addForce(avx, avy, party.SepStrength);
    }
  }
  
  void updatePosition() {
    accelerationForces();
    
    vx += ax; vy += ay;
    
    if(!validVector(vx, vy, party.MaxSpeed)) {
      float newMag = setMagCoef(vx, vy, party.MaxSpeed);
      
      vx *= newMag; vy *= newMag;
    }
    
    x += vx; y += vy;
    ax = 0; ay = 0;
    
    if(party.Expire) expiry();
  }
}
