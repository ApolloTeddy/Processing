static boolean validVector(float Fx, float Fy, float check) {
    return Fx*Fx + Fy*Fy < check*check;
}

public static float invSqrt(float x) {
    float xhalf = 0.5f * x;
    int i = Float.floatToIntBits(x);
    
    i = 0x5f3759df - (i >> 1);
    x = Float.intBitsToFloat(i);
    
    x *= (1.5f - xhalf * x * x);
    return x;
}

class Particle {
  float Tx, Ty; // Temp values to store the original x and y positions of a particle for the reset.
  
  float x, y; // Position values
  float vx = 0, vy = 0; // Velocity values
  float ax = 0, ay = 0; // Acceleration values
  
  long spawnTime = System.nanoTime(), 
       expireTime;
  
  //Settings
  boolean SpawnPositionJitter = false,
          LifetimeJitter = true,
          StartingVelocity = true,
          RespawnAfterExpire = true,
          LimitParticleForce = true, 
          ExpireParticle = true; // Makes it so you cant pull something to terminal velocity instantly (caps acceleration).
          
  float LowerSpawnVelAmpBound = 2, HigherSpawnVelAmpBound = 4,
  
        LowerLifetimeBound = 2, HigherLifetimeBound = 5,
        
        PositionJitterRadius = 30,
        
        ParticleDampening = .01,
        ParticleLifetime = 3,
        ParticleMass = 4,
        ParticleMaxSpeed = 8,
        ParticleMaxForce = 3; // Terminal velocity
  
  
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
    x = random(width); y = random(height);

    Tx = x; Ty = y;

    if(StartingVelocity) {
      float t = random(TAU), a = random(LowerSpawnVelAmpBound, HigherSpawnVelAmpBound);
      
      vx = a * cos(t); vy = a * sin(t);
    }
    
    expireTime = spawnTime + (long)(ParticleLifetime * pow(10, 9));
    
    if(LifetimeJitter) ParticleLifetime = random(LowerLifetimeBound, HigherLifetimeBound);
  }
  
  void reset() {
    float t = random(TAU), a = random(LowerSpawnVelAmpBound, HigherSpawnVelAmpBound); //<>//
    
    if(SpawnPositionJitter) {
      x = Tx - random(-PositionJitterRadius, PositionJitterRadius) * sin(t);
      y = Ty + random(-PositionJitterRadius, PositionJitterRadius) * cos(t);
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
  void addForce(float Fx, float Fy, float amp) { //<>//
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
      
      if(!validVector(Fx, Fy, pati.ParticleMaxForce)) {
        float d = invSqrt(Fx*Fx + Fy*Fy);
        
        Fx *= d;
        Fy *= d;
      }
      
      pati.addForce(Fx, Fy, strength);
    }
  }
  
  void follow(float Px, float Py) {
    for(var pati : party) {
      float Dx = Px - pati.x,
            Dy = Py - pati.y;
      
      if(!validVector(Dx, Dy, pati.ParticleMaxForce)) {
        float d = invSqrt(Dx*Dx + Dy*Dy);
        
        Dx *= d;
        Dy *= d;
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
        float d = invSqrt(pati.vx*pati.vx + pati.vy*pati.vy);
        
        pati.vx *= d;
        pati.vy *= d;
      }
      
      //pati.vx *= (1-pati.ParticleDampening);
      //pati.vy *= (1-pati.ParticleDampening);
      
      pati.x += pati.vx; 
      pati.y += pati.vy;
      
      pati.ax = 0; 
      pati.ay = 0;
      
      if(pati.ExpireParticle && System.nanoTime() > pati.expireTime) {
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
