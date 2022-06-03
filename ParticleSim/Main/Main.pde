PartiParty party;

int partySize = 800;

boolean input = true;

void setup() {
  size(900, 900);
  
  party = new PartiParty();
  party.MaxForce = 3;
  party.MaxSpeed = 12;
  party.Separate = true;
  party.Expire = false;
  party.Dampening = false;
  party.RandomSpawnVel = false;
  party.LowSpawnVelMagBound = 0; // REOMOVE HIGH/LOW BOUNDS, ADD VARIANCE INSTEAD
  party.HighSpawnVelMagBound = 2;
  party.SpawnPosJitter = true;
  party.SpawnPosJitterRadius = 8;
  party.DampeningPercent = .05;
  party.SepRadius = 1;
  party.SepStrength = 2;
  party.LowSpawnMassBound = 6.7;
  party.HighSpawnMassBound = 7.7;
}


boolean spawning = true;
void spawn() {
  if(!spawning) return;
  
  party.pushMembers(width/2, height/2, 5);
    
  if(party.members > partySize) {
    println("Done spawning.");
    spawning = false;
  }
}

float theta = 0;
float dx = PI/pow(2, 6.5);
float r = 135;
void draw() {
  spawn();
  
  if(input) input();
  background(50);
  
  strokeWeight(5);
  point(width/2 + r*cos(theta), height/2 + r*sin(theta));
  
  party.follow(width/2 + r*cos(theta), height/2 + r*sin(theta));
  
  party.run();
  party.showParty();
  
  theta += dx;
}

void input() {
  if(mouseButton == LEFT) party.followCursor(.5);
  if(mouseButton == RIGHT) party.followCursor(-.5);
  if(mouseButton == CENTER) party.pushMembers(mouseX, mouseY, 1);
}
