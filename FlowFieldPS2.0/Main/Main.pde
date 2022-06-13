PartiParty pHandler;
Layer lay;
ArrayList<Particle> particles;

void setup() {
  size(700, 700);
  pHandler = new PartiParty();
  
  lay = pHandler.addLayer(new Layer(pHandler, 0, 0) {
    void show() {
      for(var mem : party) {
        point(mem.x, mem.y);
      }
    }
  });
}

void draw() {
  background(70);
}
