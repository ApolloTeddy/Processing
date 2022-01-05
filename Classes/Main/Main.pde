ArrayList<Obj> objs;

void setup() {
  size(700, 500);
  objs = new ArrayList<Obj>();

  for (int i = 0; i < 10; i++) {
    objs.add(new Obj(25) {
      void show() {
        rect(this.x, this.y, this.r, this.r);
      }
    }
    );
  }

  for (int i = 0; i < 10; i++) {
    objs.add(new Obj(25) {
      void show() {
        circle(this.x, this.y, this.r);
      }
    }
    );
  }
}

void draw() {
  background(100);
  objs.forEach(o -> {
    o.show();
  });
}
