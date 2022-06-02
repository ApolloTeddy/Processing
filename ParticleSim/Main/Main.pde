PartiParty party;

int partySize = 50;

void setup() {
  size(600, 600);
  party = new PartiParty();
}


boolean spawning = true;
void draw() {
  if(spawning) {
    party.pushPati(width/2, height/2, 5);
    if(party.patiCount > partySize) {
      println("Done spawning.");
      spawning = false;
    }
  }
  
  background(50);
  
  
  party.updatePositions();
  party.showParty();
}
