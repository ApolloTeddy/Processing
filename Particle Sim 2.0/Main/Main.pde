PartiParty party;

void setup() {
  size(900, 900);
  rectMode(RADIUS);
  noFill();
  party = new PartiParty();
  
  for(float t = 0; t < TAU; t += TAU/12) party.addSpawnpoint(width/2 + 300 * cos(t), height/2 + 300 * sin(t));
  
  Layer lay = party.addLayer(new Layer(party) {
    void show() {
      push();
      colorMode(RGB, 100);
      
      for(var mem : party) {
        int countNeighbors = queryRadius(mem.x, mem.y, 10.25).length - 1;
        
        strokeWeight(2.75);
        
        stroke(#D38735, 
               100 - 50 * countNeighbors); // 0 - 4 -> 100 - 0 -> 100 + -25 * countNeighbors
        
        point(mem.x, mem.y);
      }
      pop();
    }
  });
  lay.MaxSpeed = 15;
  lay.MaxForce = 2.5;
  lay.Separate = true;
  lay.SepRadius = 50;
  lay.setCount(750);
  lay.MassMin = 1.75;
  lay.MassMax = 2.5;  
  lay.Expire = false;
  
  lay = party.addLayer(new Layer(party) {
    void show() {
      push();
      colorMode(RGB, 100);
      
      for(var mem : party) {
        int countNeighbors = queryRadius(mem.x, mem.y, 10.25).length - 1;
        
        strokeWeight(2.75);
        
        stroke(#DB570B, 
               4 * countNeighbors); 
        
        point(mem.x, mem.y);
      }
      pop();
    }
  });
  lay.MaxSpeed = 15;
  lay.MaxForce = 2.5;
  lay.Separate = true;
  lay.SepRadius = 10;
  lay.setCount(1750);
  lay.MassMin = 1.75;
  lay.MassMax = 2.5;  
  lay.Expire = false;
}

void draw() {
  background(40); //<>//
  text(frameRate, 10, 10);
  
  party.goTo(mouseX, mouseY);
  party.run();
  
  party.show(); //<>//
}
