PartiParty party;

PGraphics pg;

void setup() {
  size(900, 900);
  
  pg = createGraphics(width, height);
  
  rectMode(RADIUS);
  noFill();
  party = new PartiParty();
  
  party.preset(2);
  
  background(#200069);
}

void draw() {
  pg.beginDraw();
  pg.background(#200069, 25);
  pg.endDraw();
  text(frameRate, 10, 10);
  
  party.run();
  
  party.show();
  image(pg, 0, 0);
}
