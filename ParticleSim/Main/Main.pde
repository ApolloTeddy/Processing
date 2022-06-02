PartiParty party;

int partySize = 1000;

boolean input = false;

void setup() {
  size(600, 600);
  party = new PartiParty();
  party.LowSpawnMassBound = 10;
  party.HighSpawnMassBound = 20;
  party.LowSpawnVelMagBound = 3;
  party.HighSpawnVelMagBound = 7;
  party.MaxForce = 1;
}


boolean spawning = true;
void draw() {
  if(spawning) {
    party.pushMembers(width/2, height/2, 5);
    
    if(party.members > partySize) {
      println("Done spawning.");
      spawning = false;
    }
  }
  if(input) input();
  background(50);
  
  party.follow(width/2, height/2);
  
  party.run();
  party.showParty();
}

void input() {
  if(mouseButton == LEFT) party.followCursor(1);
  if(mouseButton == RIGHT) party.followCursor(-1);
  if(mouseButton == CENTER) party.pushMembers(mouseX, mouseY, 1);
}
