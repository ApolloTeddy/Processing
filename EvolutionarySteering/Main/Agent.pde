class Agent {
  PVector pos, vel, acc;
  float health = 100;
  float maxspeed = 12;
  float maxforce = 0.35;
  int r = 10;
  
  float[] dna = new float[] {
    random(-5, 5),
    random(-5, 5)
  };
  Agent() {
    this.pos = new PVector(random(width), random(height));
    this.vel = PVector.random2D();
    this.acc = new PVector(0, 0);
  }
  
  void run() {
    this.update();
    this.edges();
    this.show();
  }
  
  void update() {
    this.vel.add(this.acc);
    this.vel.limit(this.maxspeed);
    this.pos.add(this.vel);
    this.acc.mult(0);
  }
  
  void show() {
    push();
    stroke(40);
    fill(50);
    strokeWeight(1);
    translate(this.pos.x, this.pos.y);
    rotate(this.vel.heading() - radians(90));
    triangle(-r / 2, 0, r / 2, 0, 0, r * 2);
    pop();
  }
  
  void edges() {
    if(this.pos.x - r > width) {
      this.pos.x = 0;
    }
    if(this.pos.x + r < 0) {
      this.pos.x = width;
    }
    if(this.pos.y - r > height) {
      this.pos.y = 0;
    }
    if(this.pos.y + r < 0) {
      this.pos.y = height;
    }
  }
  
  void eat(ArrayList<PVector> food) {
    float record = width * 2;
    int cInd = -1;
    for(int i = 0; i < food.size(); i++) {
      PVector f = food.get(i);
      float dist = PVector.dist(this.pos, f);
      if(dist < record) {
        record = dist;
        cInd = food.indexOf(f);
      }
    }
    
    if(cInd > -1 && food.size() != 0) this.seek(food.get(cInd));
    if(record < r / 2) {
      food.remove(cInd);
    }
  }
  
  void applyF(PVector f) {
    this.acc.add(f);
  }
  
  void seek(PVector trg) {
    PVector des, str;
    des = PVector.sub(trg, this.pos);
    des.setMag(maxspeed);
    str = PVector.sub(des, this.vel);
    str.limit(this.maxforce);
    this.applyF(str);
  }
}
