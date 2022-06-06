PartiParty party;

void setup() {
  size(800, 800);
  rectMode(RADIUS);
  noFill();
 
  party = new PartiParty() {
    void show() {
      push();
      colorMode(HSB, 100);
      for(var mem : party) {
        int countNeighbors = queryRadius(mem.x, mem.y, 0.75).length - 1;
        // 0 - 4 -> 50 - 20 -> 50 - 7.5 * countNeighbors
        // 0 - 4 -> 50 - 100 -> 50 + 12.5 * countNeighbors
        // 0 - 4 -> 100 - 80 -> 100 - 5 * countNeighbors
        // 57.5 - 1.5 * countNeighbors
        // 37.5 + 2.5 * countNeighbors
        // 105 - countNeighbors
        // 30 + 9 * countNeighbors
        stroke(50 - 7.5 * countNeighbors,
               50 + 12.5 * countNeighbors, 
               100 - 5 * countNeighbors, 
               30 + 9 * countNeighbors);
        point(mem.x, mem.y);
      }
      pop();
    } 
  };
    
  party.Separate = true;
  party.setCount(4500);
  for(float t = 0; t < TAU; t += TAU/12) party.addSpawnpoint(width/2 + 300 * cos(t), height/2 + 300 * sin(t));
  party.MassMax = 1.6;  
  party.Expire = false;
}

void draw() {
  background(0, 200, 200); //<>//
  text(frameRate, 10, 10);
  
  party.goTo(mouseX, mouseY);
  party.run();
  
  strokeWeight(2.75);
  
  party.show(); //<>//
}
