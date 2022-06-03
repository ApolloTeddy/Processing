/* -- SETTINGS GUIDE -- *\
  LimitPhysForce, boolean, Limits the magnitude of force vectors to be at most of length MaxForce.
    MaxForce, float
  LimitPhysSpeed, boolean, Limits the maximum speed particles can travel at to MaxSpeed.
    MaxSpeed, float
  Mass, float
    RandomSpawnMass, boolean, Spawns particles with a random mass in the range [LowSpawnMassBound - HighSpawnMassBound].
      LowSpawnMassBound, float
      HighSpawnMassBound, float
  Dampening, boolean, Slowly slows down particles. Every update, the velocity vector is shortened by DampeningPercent percent, with the formula (1-DampeningPercent*0.01).
    DampeningPercent, float, given in the range [0 - 100]. The value put into the dampening formula is the actual percent value (i.e. 1 -> 0.01).
  RandomSpawnVel, boolean, Spawns particles with a random velocity with a magnitude in the range [LowSpawnVelMagBound - HighSpawnVelMagBound].
    LowSpawnVelMagBound, float 
    HighSpawnVelMagBound, float
  Expire, boolean, Sets particles to expire after Lifetime is exceeded.
    Lifetime, float
      RandomLifetime, boolean, Spawns particles with a random lifetime in the range [LowLifetimeBound - HighLifetimeBound].
        LowLifetimeBound, float
        HighLifetimeBound, float
    RespawnAfterExpire, boolean, Respawns particles after expiry.
      SpawnPosJitter, boolean, Spawn location of particles is slightly altered in the radius of SpawnPosJitterRadius every spawn.
        SpawnPosJitterRadius, float
      DelayRespawn, boolean, Delays respawning the particle until after RespawnTime has elapsed.
        RespawnDelay, float
        RandomRespawnDelay, boolean, Respawns particles after a random amount of time in the range [LowRespawnTimeBound - HighRespawnTimeBound] each expiry.
          LowRespDelayBound, float
          HighRespDelayBound, float
  Separate, boolean, Tries to separate the particles from each other a distance SepRadius apart with strength SepStrength.
    SepStrength, float
    SepRadius, float
\*                      */

// Particle class

class Particle {
  float Tx, Ty; // Temp values to store the original x and y positions of a particle for the reset.
  
  float x, y; // Position values
  float vx, vy; // Velocity values
  float ax, ay; // Acceleration values
  
  PartiParty Party;
  
  long spawnTime, 
       expireTime;
  boolean expire = false;
  float mass, lifetime;
  
  Particle(PartiParty parent, float x, float y) {
    Party = parent;
    if(Party.SpawnPosJitter) {
      float r = Party.SpawnPosJitterRadius;
      
      this.x = x + random(-r, r);
      this.y = y + random(-r, r);
    } else {
      this.x = x;
      this.y = y;
    }
    Tx = x; Ty = y;
    init();
  }
  Particle(PartiParty parent) {
    Party = parent;
    x = random(width); y = random(height);
    Tx = x; Ty = y;
    init();
  }
  
  private void init() {
    vx = 0; vy = 0;
    ax = 0; ay = 0;
    
    if(Party.RandomSpawnVel) {
      float t = random(TAU), a = random(Party.LowSpawnVelMagBound, Party.HighSpawnVelMagBound);
      
      vx = a * cos(t); vy = a * sin(t);
    }
    
    
    if(Party.RandomSpawnMass) mass = random(Party.LowSpawnMassBound, Party.HighSpawnMassBound);
    else mass = Party.Mass;
    
    if(Party.Expire) {
      if(Party.RandomLifetime) lifetime = random(Party.LowLifetimeBound, Party.HighLifetimeBound);
      else lifetime = Party.Lifetime; 
      
      spawnTime = System.nanoTime();
      expireTime = spawnTime + (long)(lifetime * pow(10, 9));
    }
  }
  
  private void reset() { //<>//
    if(Party.SpawnPosJitter) {
      float r = Party.SpawnPosJitterRadius;
      
      x = Tx + random(-r, r);
      y = Ty + random(-r, r);
    } else {
      x = Tx;
      y = Ty;
    }
    
    init();
  }
  
  void forces() {
    if(Party.Separate) { // This has to stop, needs to be fixed big time //<>//
      Particle[] others = Party.query(x, y, Party.SepRadius);
      if(others.length == 0) return;
      
      float avx = 0, avy = 0;
      for(var other : others) {
        float dx = x - other.x, dy = y - other.y,
              sqdist = dx*dx + dy*dy;
        
        dx /= sqdist; dy /= sqdist;
        avx += dx; avy += dy;
      }
      float d = invSqrt(avx*avx + avy*avy) * Party.MaxForce;
      
      avx *= d; avy *= d;
      avx -= vx; avy -= vy;
      
      addForce(avx, avy);
    }
  }
  
  void updatePosition() {
    forces();
    
    vx += ax; vy += ay;
    
    if(Party.LimitPhysSpeed && !validVector(vx, vy, Party.MaxSpeed)) {
      float d = invSqrt(vx*vx + vy*vy) * Party.MaxSpeed;
      
      vx *= d; vy *= d;
    }
    
    if(Party.Dampening) {
      float d = (1-Party.DampeningPercent*0.01);
      
      vx *= d; vy *= d;
    }
    
    x += vx; y += vy;
    ax = 0; ay = 0;
    
    if(Party.Expire && System.nanoTime() > expireTime) {
        if(Party.RespawnAfterExpire) reset();
        else Party.destroy(this);
      }
  }
  
  void addForce(float fx, float fy) {
    if(Party.LimitPhysForce && !validVector(fx, fy, Party.MaxForce)) {
      float d = invSqrt(fx*fx + fy*fy) * Party.MaxForce;
      
      fx *= d;
      fy *= d;
    }
    
    ax += fx / mass;
    ay += fy / mass;
  }
  void addForce(float fx, float fy, float amp) { //<>//
    if(Party.LimitPhysForce && !validVector(fx, fy, Party.MaxForce)) { //<>//
      float d = invSqrt(fx*fx + fy*fy) * Party.MaxForce;
      
      fx *= d;
      fy *= d;
    }
    
    ax += (fx * amp) / mass;
    ay += (fy * amp) / mass;
  }
}

// Party Handler

class PartiParty {
  boolean LimitPhysForce = true,
          LimitPhysSpeed = true,
          Dampening = false,
          Expire = true,
          RespawnAfterExpire = true,
          SpawnPosJitter = false,
          DelayRespawn = false,
          RandomLifetime = true,
          RandomRespawnDelay = false,
          RandomSpawnMass = true,
          RandomSpawnVel = true,
          Separate = true;
  float MaxForce = 1,
        MaxSpeed = 10,
        Mass = 5,
        DampeningPercent = 1,
        LowSpawnVelMagBound = 2,
        HighSpawnVelMagBound = 5,
        Lifetime = 0.1,
        LowLifetimeBound = 1,
        HighLifetimeBound = 5,
        SpawnPosJitterRadius = 25,
        RespawnDelay = 0.2,
        LowRespDelayBound = 0,
        HighRespDelayBound = 1,
        LowSpawnMassBound = 4,
        HighSpawnMassBound = 15,
        SepStrength = 1,
        SepRadius = 10;
  
  ArrayList<Particle> party = new ArrayList<Particle>();
  int members = 0;
  
  void showParty() {
    push();
    strokeWeight(5);
 
    for(var member : party) {
      stroke(map(member.x, 0, width/2, 0, 255),
             map(member.y, 0, height/2, 0, 255),
             map(member.y, 0, height/2, 255/2, 0));
      point(member.x, member.y);
    }
    
    pop();
  }
  
  void destroy(Particle member) {
    if(!party.contains(member)) return;
    
    party.get(party.indexOf(member)).expire = true;
  }
  
  void run() {
    for(int i = 0; i < party.size(); i++) {
      Particle member = party.get(i);
      member.updatePosition();
      
      if(member.expire) {
        party.remove(i);
        i--;
      }
    }
  }
  
  void followCursor(float strength) {
    for(var member : party) {
      float Fx = mouseX - member.x,
            Fy = mouseY - member.y;
      
      member.addForce(Fx, Fy, strength);
    }
  }
  
  void follow(float Px, float Py) {
    for(var member : party) {
      float Fx = Px - member.x,
            Fy = Py - member.y;
      
      member.addForce(Fx, Fy);
    }
  }
  
  void printAverageHeading() {
    int size = party.size();
    if(size < 1) return;
    
    float Vx = 0, Vy = 0,
          Ax = 0, Ay = 0;
    for(var member : party) {
      Vx += member.vx; Vy += member.vy;
      Ax += member.ax; Ay += member.ay;
    }
    Vx /= size; Vy /= size;
    Ax /= size; Ay /= size;
    
    System.out.printf("\n\n\nV: (%d, %d)\nA: (%d, %d)", Vx, Vy, Ax, Ay);
  }
  
  Particle[] query(float x, float y, float r) {
    ArrayList<Particle> tmp = new ArrayList<Particle>();
    Particle[] out;
    
    for(var member : party) {
      float dx = abs(x - member.x), dy = abs(y - member.y);
      if(dx + dy == 0) continue;
      
      if(validVector(dx, dy, r)) tmp.add(member);
    }
    
    out = new Particle[tmp.size()];
    for(int i = 0; i < tmp.size(); i++) {
      out[i] = tmp.get(i);
    }
    
    return out;
  }
  
  // Implement key spawn locations eventually
  void pushMembers(float x, float y, int count) {
    for(var i = 0; i < count; i++) {
      party.add(new Particle(this, x, y));
      members++;
    }
  }
  void pushMembers(int count) {
    for(var i = 0; i < count; i++) {
      party.add(new Particle(this));
      members++;
    }
  }
}
