PartiParty party;

int partySize = 1250;

boolean input = true;

void setup() {
  size(800, 800);
  
  party = new PartiParty();
  party.MaxForce = 1.75;
  party.MaxSpeed = 17;
  party.Expire = false;
  party.Dampening = false;
  party.RandomSpawnVel = false;
  party.SpawnPosJitter = true;
  party.DampeningPercent = .5;
  party.SepRadius = 10;
  party.SepStrength = 1;
  party.LowSpawnMassBound = 4.75;
  party.HighSpawnMassBound = 6.2;
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
  
  //party.follow(width/2 + r*cos(theta), height/2 + r*sin(theta));
  
  party.run();
  party.showParty();
  
  theta += dx;
}

void input() {
  if(mouseButton == LEFT) party.followCursor(1);
  if(mouseButton == RIGHT) party.followCursor(-1);
  if(mouseButton == CENTER) party.pushMembers(mouseX, mouseY, 1);
}
