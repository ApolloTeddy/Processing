PartiParty party;

void setup() {
  size(600, 600);
  party = new PartiParty();
  
  party.pushPati(width/2, height/2, 600);
}

void draw() {
  background(50);
   
  party.follow(width/2, height/2);
  
  party.printAverageHeading();
  
  party.updatePositions();
  party.showParty();
}
