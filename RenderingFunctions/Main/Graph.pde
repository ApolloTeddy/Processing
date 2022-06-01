class Graph {
  float start, end;
  
  Graph(float start, float end) {
    this.start = start;
    this.end = end;
  }
  
  private void drawFunc(Func f, color c) {
    push();
    translate(width/2, height/2);
    
    strokeWeight(2);
    stroke(c);
    noFill();
    beginShape();
    for(float i = start/scl; i < end/scl; i += width/scl/points) {
      vertex(i*scl, -f.of(i)*scl);
    }
    endShape();
    pop();
  }
  
  void tanLine(Func f, Func f_d, float point, color c) {
    this.drawFunc((x) -> f_d.of(point)*(x-point)+f.of(point), c);
  }
  
  void show() {
    push();
    translate(width/2, height/2);
    strokeWeight(1);
    line(start, 0, end, 0);
    line(0, start, 0, end);
    pop();
  }
}
