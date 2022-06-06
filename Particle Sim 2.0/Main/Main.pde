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
      colorMode(HSB, 360, 100, 100, 100);
      
      for(var mem : party) {
        int countNeighbors = queryRadius(mem.x, mem.y, 3).length - 1;
        
        strokeWeight(2.75);
        
        stroke(33,
               82, 
               100, 
               30 + 9 * countNeighbors);
        
        point(mem.x, mem.y);
      }
      pop();
    } 
  });
    
  lay.Separate = true;
  lay.SepRadius = 50;
  lay.setCount(500);
  lay.MassMin = 2;
  lay.MassMax = 2.5;  
  lay.Expire = false;
  
  lay = party.addLayer(new Layer(party) {
    void show() {
      push();
      colorMode(RGB, 100);
      
      for(var mem : party) {
        int countNeighbors = queryRadius(mem.x, mem.y, 4).length - 1;
        
        stroke(30 + 9 * countNeighbors, 15);
        strokeWeight(3);
        point(mem.x, mem.y);
      }
      pop();
    } 
  });
  
  lay.Separate = true;
  lay.setCount(1800);
  lay.MassMin = 3;
  lay.MassMax = 4;
  lay.Expire = false;
  
  lay = party.addLayer(new Layer(party) {
    void show() {
      push();
      colorMode(HSB, 360, 100, 100, 100);
      
      for(var mem : party) {
        int countNeighbors = queryRadius(mem.x, mem.y, 1.6).length - 1;
        
        stroke(8, 88, 97, 30 + 9 * countNeighbors);
        strokeWeight(3);
        point(mem.x, mem.y);
      }
      pop();
    } 
  });
  
  lay.Separate = true;
  lay.setCount(2200);
  lay.MassMin = 1.5;
  lay.MassMax = 3;
  lay.Expire = false;
  
  lay = party.addLayer(new Layer(party) {
    void show() {
      push();
      colorMode(HSB, 360, 100, 100, 100);
      
      for(var mem : party) {
        int countNeighbors = queryRadius(mem.x, mem.y, 1).length - 1;
        
        stroke(16, 100, 100, 30 + 9 * countNeighbors);
        strokeWeight(3);
        point(mem.x, mem.y);
      }
      pop();
    } 
  });
  
  lay.Separate = true;
  lay.SepRadius = 2;
  lay.SepStrength = 0.2;
  lay.setCount(1500);
  lay.MaxSpeed = 9;
  lay.MaxForce = 0.8;
  lay.MassMin = 1.5;
  lay.MassMax = 3.5;
  lay.Expire = false;
  
  lay = party.addLayer(new Layer(party) {
    void show() {
      push();
      colorMode(HSB, 360, 100, 100, 100);
      
      for(var mem : party) {
        int countNeighbors = queryRadius(mem.x, mem.y, 2).length - 1;
        
        stroke(16, 100, 100, 8.46153 + 0.76923 * countNeighbors);
        strokeWeight(3);
        point(mem.x, mem.y);
      }
      pop();
    } 
  });
  
  lay.Separate = true;
  lay.SepRadius = 2;
  lay.SepStrength = 2;
  lay.setCount(200);
  lay.MaxSpeed = 8.5;
  lay.MaxForce = 2;
  lay.MassMin = 2;
  lay.MassMax = 2.3;
  lay.Expire = true;
}

void draw() {
  background(40); //<>//
  text(frameRate, 10, 10);
  
  party.goTo(mouseX, mouseY);
  party.run();
  
  party.show(); //<>//
}
