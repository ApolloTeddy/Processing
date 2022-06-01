static boolean validVector(float Fx, float Fy, float check) {
    return Fx*Fx + Fy*Fy < check*check;
}

class Particle {
  float Tx, Ty; // Temp values to store the original x and y positions of a particle for the reset.
  
  float x, y; // Position values
  float vx = 0, vy = 0; // Velocity values
  float ax = 0, ay = 0; // Acceleration values
  
  long spawnTime = System.nanoTime(), 
       expireTime;
  
  //Settings
  boolean SpawnPositionJitter = true,
          LifetimeJitter = true,
          StartingVelocity = true,
          RespawnAfterExpire = true,
          LimitParticleForce = true; // Makes it so you cant pull something to terminal velocity instantly (caps acceleration).
          
  float LowerSpawnVelAmpBound = 1, HigherSpawnVelAmpBound = 3,
  
        LowerLifetimeBound = 2, HigherLifetimeBound = 5,
        
        PositionJitterRadius = 30,
        
        ParticleDampening = .01,
        ParticleLifetime = 3,
        ParticleMass = 1,
        ParticleMaxSpeed = 10,
        ParticleMaxForce = 10; // Terminal velocity
  
  
  Particle(float x, float y) {
    Tx = x; Ty = y;
    
    this.x = x; this.y = y;

    if(StartingVelocity) {
      float t = random(TAU), a = random(LowerSpawnVelAmpBound, HigherSpawnVelAmpBound);
      
      vx = a * cos(t); vy = a * sin(t);
    }
    
    expireTime = spawnTime + (long)(ParticleLifetime * pow(10, 9));
    
    if(LifetimeJitter) ParticleLifetime = random(LowerLifetimeBound, HigherLifetimeBound);
  }
  Particle() {
    Tx = x; Ty = y;
    
    x = random(width); y = random(height);

    if(StartingVelocity) {
      float t = random(TAU), a = random(LowerSpawnVelAmpBound, HigherSpawnVelAmpBound);
      
      vx = a * cos(t); vy = a * sin(t);
    }
    
    expireTime = spawnTime + (long)(ParticleLifetime * pow(10, 9));
    
    if(LifetimeJitter) ParticleLifetime = random(LowerLifetimeBound, HigherLifetimeBound);
  }
  
  void reset() {
    float t = random(TAU), a = random(LowerSpawnVelAmpBound, HigherSpawnVelAmpBound);
    
    if(SpawnPositionJitter) {
      x = Tx - PositionJitterRadius * sin(t);
      y = Ty + PositionJitterRadius * cos(t);
      Tx = x;
      Ty = y;
    } else {
      x = Tx;
      y = Ty;
    }
    
    ax = 0; ay = 0;
    if(StartingVelocity) vx = a * cos(t); vy = a * sin(t);
    
    if(LifetimeJitter) ParticleLifetime = random(LowerLifetimeBound, HigherLifetimeBound);
    
    spawnTime = System.nanoTime();
    expireTime = spawnTime + (long)(ParticleLifetime * pow(10, 9));
  }
  
  void addForce(float Fx, float Fy) {
    ax += Fx / ParticleMass;
    ay += Fy / ParticleMass;
  }
  void addForce(float Fx, float Fy, float amp) { //<>// //<>//
    ax += (Fx * amp) / ParticleMass;
    ay += (Fy * amp) / ParticleMass;
  }
}

class PartiParty {
  ArrayList<Particle> party = new ArrayList();
  int patiCount = 0;
  
  void showParty() {
    push();
    strokeWeight(5);
 
    for(var pati : party) {
      stroke(map(pati.x, 0, width/2, 0, 255),
             map(pati.y, 0, height/2, 0, 255),
             map(pati.y, 0, height/2, 255/2, 0));
      point(pati.x, pati.y);
    }
    
    pop();
  }
  
  void followCursor(float strength) {
    for(var pati : party) {
      float Fx = mouseX - pati.x, // From pati, to the mouseX.
            Fy = mouseY - pati.y; // Same for the mouseY.
      
      pati.addForce(Fx, Fy, strength);
    }
  }
  
  void follow(float Px, float Py) {
    for(var pati : party) {
      float Dx = Px - pati.x,
            Dy = Py - pati.y;
      
      if(!validVector(Dx, Dy, pati.ParticleMaxForce)) {
        float t = atan(Dy / Dx);
      
        Dy = pati.ParticleMaxForce * cos(t);
        Dx = pati.ParticleMaxForce * sin(t);
      }
      
      pati.addForce(Dx, Dy);
    }
  }
  
  void printAverageHeading() {
    int size = party.size();
    if(size < 1) return;
    
    float Vx = 0, Vy = 0,
          Ax = 0, Ay = 0;
    for(var pati : party) {
      Vx += pati.vx;
      Vy += pati.vy;
      Ax += pati.ax;
      Ay += pati.ay;
    }
    Vx /= size;
    Vy /= size;
    Ax /= size;
    Ay /= size;
    
    println("\n\n\nV: (" + Vx + ", " + Vy + ")\nA: (" + Ax + ", " + Ay + ")");
  }
  
  void updatePositions() {
    for(var pati : party) {
      pati.vx += pati.ax; 
      pati.vy += pati.ay;
      
      if(!validVector(pati.vx, pati.vy, pati.ParticleMaxSpeed)) {
        float t = atan(pati.vy / pati.vx);
      
        pati.vx = pati.ParticleMaxSpeed * cos(t);
        pati.vy = pati.ParticleMaxSpeed * sin(t);
      }
      
      pati.vx *= (1-pati.ParticleDampening);
      pati.vy *= (1-pati.ParticleDampening);
      
      pati.x += pati.vx; 
      pati.y += pati.vy;
      
      pati.ax = 0; 
      pati.ay = 0;
      
      if(System.nanoTime() > pati.expireTime) {
        if(pati.RespawnAfterExpire) pati.reset();
        else pati = null;
      }
    }
  }
  
  void pushPati(float x, float y, int count) {
    for(var i = 0; i < count; i++) {
      party.add(new Particle(x, y));
      patiCount++;
    }
  }
  void pushPati(int count) {
    for(var i = 0; i < count; i++) {
      party.add(new Particle());
      patiCount++;
    }
  }
}
