/*
  LimitPhysForce, true/false, Limits the magnitude of force vectors to be at most of length MaxForce.
    MaxForce, float
  LimitPhysSpeed, true/false, Limits the maximum speed particles can travel at to MaxSpeed.
    MaxSpeed, float
  Mass, float
    RandomSpawnMass, true/false, Spawns particles with a random mass in the range [LowSpawnMassBound - HighSpawnMassBound].
      LowSpawnMassBound, float
      HighSpawnMassBound, float
  Dampening, true/false, Slowly slows down particles. Every update, the velocity vector is shortened by DampeningPercent percent, with the formula (1-DampeningPercent*0.01).
    DampeningPercent, float, given in the range [0 - 100]. The value put into the dampening formula is the actual percent value (i.e. 1 -> 0.01).
  RandomSpawnVel, true/false, Spawns particles with a random velocity with a magnitude in the range [LowSpawnVelMagBound - HighSpawnVelMagBound].
    LowSpawnVelMagBound, float
    HighSpawnVelMagBound, float
  Expire, true/false, Sets particles to expire after Lifetime is exceeded.
    Lifetime, float
      RandomLifetime, true/false, Spawns particles with a random lifetime in the range [LowLifetimeBound - HighLifetimeBound].
        LowLifetimeBound, float
        HighLifetimeBound, float
    RespawnAfterExpire, true/false, Respawns particles after expiry.
      SpawnPosJitter, true/false, Spawn location of particles is slightly altered in the radius of SpawnPosJitterRadius every spawn.
        SpawnPosJitterRadius, float
      DelayRespawn, true/false, Delays respawning the particle until after RespawnTime has elapsed.
        RespawnDelay, float
        RandomRespawnDelay, true/false, Respawns particles after a random amount of time in the range [LowRespawnTimeBound - HighRespawnTimeBound] each expiry.
          LowRespawnDelayBound, float
          HighRespawnDelayBound, float
*/

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
    this.x = x; this.y = y;
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
  
  private void reset() { //<>// //<>//
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
  
  void updatePosition() {
    vx += ax; vy += ay;
    
    if(Party.LimitPhysSpeed && !validVector(vx, vy, Party.MaxSpeed)) {
      float d = invSqrt(vx*vx + vy*vy) * Party.MaxSpeed;
      
      vx *= d; vy *= d;
    }
    
    x += vx; y += vy;
    ax = 0; ay = 0;
    
    if(Party.Dampening) {
      float d = (1-Party.DampeningPercent*0.01);
      
      vx *= d; vy *= d;
    }
    
    if(Party.Expire && System.nanoTime() > expireTime) {
        if(Party.RespawnAfterExpire) reset();
        else Party.destroy(this);
      }
  }
  
  void addForce(float Fx, float Fy) {
    if(Party.LimitPhysForce && !validVector(Fx, Fy, Party.MaxForce)) {
      float d = invSqrt(Fx*Fx + Fy*Fy) * Party.MaxForce;
      
      Fx *= d;
      Fy *= d;
    }
    
    ax += Fx / mass;
    ay += Fy / mass;
  }
  void addForce(float Fx, float Fy, float amp) { //<>// //<>//
    if(Party.LimitPhysForce && !validVector(Fx, Fy, Party.MaxForce)) {
      float d = invSqrt(Fx*Fx + Fy*Fy) * Party.MaxForce;
      
      Fx *= d;
      Fy *= d;
    }
    
    ax += (Fx * amp) / mass;
    ay += (Fy * amp) / mass;
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
          RandomRespawnTime = false,
          RandomSpawnMass = true,
          RandomSpawnVel = true;
  float MaxForce = 1,
        MaxSpeed = 10,
        Mass = 5,
        DampeningPercent = 5,
        LowSpawnVelMagBound = 2,
        HighSpawnVelMagBound = 5,
        Lifetime = 0.1,
        LowLifetimeBound = 1,
        HighLifetimeBound = 5,
        SpawnPosJitterRadius = 25,
        RespawnTime = 0.2,
        LowRespawnTimeBound = 0,
        HighRespawnTimeBound = 1,
        LowSpawnMassBound = 4,
        HighSpawnMassBound = 15;
  
  ArrayList<Particle> party = new ArrayList();
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
    
    println("\n\n\nV: (" + Vx + ", " + Vy + ")\nA: (" + Ax + ", " + Ay + ")");
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
