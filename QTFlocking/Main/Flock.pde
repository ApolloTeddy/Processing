class Flock {
  int size = 0;
  ArrayList<Boid> boids;
  boolean drawTree = true;
  QuadTree boidTree = new QuadTree(new Rect(width / 2, height / 2, width / 2, height / 2), 7);
  
  Flock() {
    this.boids = new ArrayList<Boid>();
  }
  
  void push() {
    this.boids.add(new Boid());
    this.size++;
  }
  
  void pop() {
    this.boids.remove(this.boids.size() - 1);
  }
  
  void flock(float cP, float cS, float sP, float sS, float aP, float aS) {
    this.boidTree.buildTree(this.boids.toArray(new Boid[this.boids.size()]));
    if(this.drawTree) {
        this.boidTree.show();
    }

    for(int i = 0; i < this.boids.size(); i++) {
        Boid boid = this.boids.get(i);
        boid.flock(this.boidTree, cP, cS, sP, sS, aP, aS);
        boid.run();
    }
  }
  
  void treeCap(int newCap) {
    if(this.boidTree.capacity != newCap) {
        this.boidTree.setCapacity(newCap);
    }
  }
  
  void flockSize(int newSize) {
    if(this.size != newSize) {
        if(this.size > newSize) {
            while(this.size > newSize) {
                this.pop();
            }
        } else {
            while(this.size < newSize) {
                this.push();
            }
        }
    }
  }
  
  void showTree(boolean bool) {
    this.drawTree = bool;
  }
}
