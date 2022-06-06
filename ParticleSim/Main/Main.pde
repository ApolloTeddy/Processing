PartiParty party;

int partySize = 10000;

boolean input = true;

void setup() {
  ellipseMode(RADIUS);
  rectMode(RADIUS);
  size(900, 900);
  party = new PartiParty();
  
  party.MaxForce = 1;
  party.MaxSpeed = 12;
  party.Separate = true;
  party.Expire = false;
  party.Dampening = true;
  party.RandomSpawnVel = true;
  party.LowSpawnVelMagBound = 0; // REOMOVE HIGH/LOW BOUNDS, ADD VARIANCE INSTEAD
  party.HighSpawnVelMagBound = 2;
  party.SpawnPosJitter = true;
  party.SpawnPosJitterRadius = 25;
  party.DampeningPercent = 0.05;
  party.SepRadius = 30;
  party.SepStrength = 4;
  party.LowSpawnMassBound = 2;
  party.HighSpawnMassBound = 4;
}


boolean spawning = true;
void spawn() {
  if(!spawning) return;
  
  party.pushMembers(width/2, height/2, 50);
    
  if(party.members > partySize) {
    println("Done spawning.");
    spawning = false;
  }
}

float theta = 0;
float dx = PI/pow(2, 6.75);
float r = 135*2;
void draw() {
  spawn();

  if(input) input();
  background(50);

  scale(0.5);
  translate(width/2, height/2);
  strokeWeight(5);
  point(width/2 + r*cos(theta), height/2 + r*sin(theta));
  
  //party.follow(width/2 + r*cos(theta), height/2 + r*sin(theta), 0.2);
  //party.follow(width/2, height/2, -0.5);
  
  party.run();
  party.showParty();
  
  theta += dx;
}

void input() {
  if(mouseButton == LEFT) party.followCursor(1.5);
  if(mouseButton == RIGHT) party.followCursor(-1.5);
  if(mouseButton == CENTER) party.pushMembers(mouseX, mouseY, 1);
}
