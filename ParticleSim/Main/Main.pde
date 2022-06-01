PartiParty party;

void setup() {
  size(600, 600);
  party = new PartiParty();
}


boolean spawning = true;
void draw() {
  if(spawning) {
    party.pushPati(width/2, height/2, 5);
    if(party.patiCount > 1000) spawning = false;
  }
  
  background(50);
  
  party.followCursor(1);
  
  party.updatePositions();
  party.showParty();
}
