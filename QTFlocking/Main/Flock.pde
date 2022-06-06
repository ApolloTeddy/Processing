class Flock {
  int size = 0;
  ArrayList<Boid> boids;
  boolean drawTree = true;
  QuadTree boidTree = new QuadTree(width / 2, height / 2, width / 2, 10);
  
  Flock() {
    boids = new ArrayList<Boid>();
  }
  
  void push() {
    boids.add(new Boid());
    size++;
  }
  
  void pop() {
    boids.remove(boids.size() - 1);
  }
  
  void flock(float cP, float cS, float sP, float sS, float aP, float aS) {
    boidTree.buildTree(boids);

    for(int i = 0; i < boids.size(); i++) {
      Boid boid = boids.get(i);
      boid.flock(boidTree, cP, cS, sP, sS, aP, aS);
      boid.run();
    }
  }
  
  void flockSize(int newSize) {
    if(size != newSize) {
        if(size > newSize) {
          while(size > newSize) {
            pop();
          }
        } else {
          while(size < newSize) {
            push();
          }
        }
    }
  }
}
