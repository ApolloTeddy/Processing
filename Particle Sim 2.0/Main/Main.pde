PartiParty party;

void setup() {
  size(800, 800);
  rectMode(RADIUS);
  noFill();
  party = new PartiParty();
  
  for(float t = 0; t < TAU; t += TAU/12) party.addSpawnpoint(width/2 + 300 * cos(t), height/2 + 300 * sin(t));
  
  Layer lay = party.addLayer(new Layer(party) {
    void show() {
      push();
      colorMode(HSB, 100);
      
      for(var mem : party) {
        int countNeighbors = queryRadius(mem.x, mem.y, 1.2).length - 1;
        
        // 57.5 - 1.5 * countNeighbors
        // 37.5 + 2.5 * countNeighbors
        // 105 - countNeighbors
        // 30 + 9 * countNeighbors
        
        strokeWeight(2.75);
        stroke(50 - 7.5 * countNeighbors,
               50 + 12.5 * countNeighbors, 
               100 - 5 * countNeighbors, 
               30 + 9 * countNeighbors);
        
        point(mem.x, mem.y);
      }
      pop();
    } 
  });
    
  lay.Separate = true;
  lay.setCount(4000);
  lay.MassMax = 1.6;  
  lay.Expire = false;
  
  lay = party.addLayer(new Layer(party) {
    void show() {
      push();
      colorMode(RGB, 100);
      
      for(var mem : party) {
        int countNeighbors = queryRadius(mem.x, mem.y, 0.9).length - 1;
        
        stroke(30 + 9 * countNeighbors, 8);
        strokeWeight(3);
        point(mem.x, mem.y);
      }
      pop();
    } 
  });
  
  lay.Separate = true;
  lay.setCount(3200);
  lay.MassMin = 0.2;
  lay.MassMax = 1.2;
  lay.Expire = false;
}

void draw() {
  background(0, 200, 200); //<>//
  text(frameRate, 10, 10);
  
  if(mouseButton == LEFT) party.goTo(mouseX, mouseY);
  party.run();
  
  party.show(); //<>//
}
