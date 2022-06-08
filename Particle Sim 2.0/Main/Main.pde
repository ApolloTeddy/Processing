PartiParty party;

void setup() {
  size(900, 900);
  rectMode(RADIUS);
  noFill();
  party = new PartiParty();
 
  party.preset(2);
}

void draw() {
  background(27, 37, 90); //<>//
  text(frameRate, 10, 10);
  
  party.run();
  
  party.show(); //<>//
}
