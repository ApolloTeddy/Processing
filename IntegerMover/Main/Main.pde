IntV v;
int toSeek = 0;
void setup() {
  size(200, 200);
  v = new IntV();
}

void show() {
  background(0);
  v.applyForce(v.seek(toSeek));
  v.show();
}
