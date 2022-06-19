PartiParty party;

PGraphics pg;

void setup() {
  size(900, 900);
  
  pg = createGraphics(width, height);
  
  rectMode(RADIUS);
  noFill();
  party = new PartiParty();
  
  party.preset(2);
  
  Layer lay = party.layers.get(0);
  
  lay.setCount(10);
  lay.setSetting(p.Tracer, true);
  lay.setSetting(p.TracerVerticeCount, 25);
}

void draw() {
  pg.beginDraw();
  pg.background(#240155, 25);
  pg.endDraw();
  text(frameRate, 10, 10);
  
  party.run();
  
  party.show();
  image(pg, 0, 0);
}
