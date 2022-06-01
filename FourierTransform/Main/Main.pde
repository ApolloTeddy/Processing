import java.util.LinkedList;
import java.util.Arrays;

float time, dx, accel = 1, spacing = 20; // increase accel if you want. if you decrease it you'll get bad results.
int maxH = 1; // maximum number of harmonics to generate the fourier series

boolean start = false, paint = false, trace = false;
ArrayList<PVector> input;
LinkedList<PVector> tracer;
fCoef[] path;

class fCoef { // class to store frequency of the coefficients.
  float x, y, am, ph;
  int fr;
  fCoef(PVector c, int freq) {
    x = c.x;
    y = c.y;
    fr = freq;
  }
  void add(PVector c) {
    x += c.x;
    y += c.y;
  }
  void div(int k) {
    x /= k;
    y /= k;
  }
  void upd(int freq) {
    am = sqrt(x*x + y*y);
    ph = atan2(y, x);
    fr = freq;
  }

  public String toString() {
    return String.format("fr: %d | (%.3f + %.3fi) | am: %.3f | ph: %.3f", fr, x, y, am, ph);
  }
}

fCoef[] DFT(ArrayList<PVector> x) { // https://en.wikipedia.org/wiki/Discrete_Fourier_transform
  int N = x.size();
  fCoef[] f = new fCoef[N];

  for (int k = 0; k < N; k++) {
    fCoef next = new fCoef(v(0, 0), 0);

    for (int j = 0; j < N; j++) {
      float theta = (TAU*k*j)/N;
      PVector a = x.get(j), b = v(cos(theta), -sin(theta)); // X_n = sum_[N-1:n=0]x_n*e^-2PIkn
      next.add(v(a.x*b.x - a.y*b.y, a.x*b.y + a.y*b.x)); // complex number multiplication
    }
    next.div(N);
    next.upd(k);
    f[k] = next;
  }
  return f;
}

PVector v(float x, float y) {
  return new PVector(x, y);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    if (!paint) {
      path = DFT(input);
      sortA(path, 0, path.length-1);

      println(path.length);
      for (fCoef f : path) println(f);

      dx = TAU/path.length;
      time = 0;
      tracer.clear();
      start = true;
    }
  }
  if (mouseButton == RIGHT) {
    start = false;
    time = 0;
    tracer.clear();
    input.clear();
  }
  if (mouseButton == CENTER) {
    start = false;
    time = 0;
    tracer.clear();
  }
}
void mouseWheel(MouseEvent e) {
  if (e.getCount() < 0 && maxH < path.length) {
    maxH++;
  } else if (e.getCount() > 0 && maxH > 1) {
    maxH--;
  }
}
void mouseDragged() {
  PVector c = v(mouseX-width/2, mouseY-width/2), prev;
  if(input.size() > 1) {
    prev = input.get(input.size()-1);
    if (mouseButton == CENTER && dist(prev.x, prev.y, c.x, c.y) > spacing) {
      input.add(c);
    }
  } else if(mouseButton == CENTER) {
    input.add(c);
  }
}
void mouseReleased() {
  if(mouseButton == CENTER) {
    input.add(input.get(0));
  }
}

void paint() { // handle drawing input
  if (mouseButton == LEFT) {
    PVector pos = v(mouseX-width/2, mouseY-height/2);
    input.add(pos);
  }
}

void fourier() { // rendering the fourier series
  if (start) {
    int N = path.length;
    float x = 0, y = 0;
    for (int i = 0; i < N && i < maxH; i++) {
      float dx = x, dy = y;
      fCoef c = path[i];
      float amp = c.am, pha = c.ph, fr = c.fr;

      x += amp*cos(pha+accel*fr*time);
      y += amp*sin(pha+accel*fr*time);

      strokeWeight(1);
      circle(dx, dy, amp*2);
      
      strokeWeight(4);
      point(dx, dy);
    }

    push();
    fill(0);
    text(maxH + " Harmonics", 0, -height/2+20);
    text(String.format("Path length: %d\nTime: %.3f\ndx: 2π/%d", N, time, N), -width/2+10, -height/2+20);
    pop();

    
    if(trace) {
      tracer.push(new PVector(x, y));
      strokeWeight(4);
      beginShape();
      for (PVector p : tracer) {
        vertex(p.x, p.y);
      }
      endShape();
    }
    
    strokeWeight(3);
    beginShape();
    for (float t = 0; t < TAU; t += dx) {
      float x2 = 0, y2 = 0;
      for (int i = 0; i < N && i < maxH; i++) {
        fCoef c = path[i];
        float amp = c.am, pha = c.ph, fr = c.fr;

        x2 += amp*cos(pha+fr*t);
        y2 += amp*sin(pha+fr*t);
      }
      vertex(x2, y2);
    }
    endShape();
    
    push();
    stroke(255);
    strokeWeight(5);
    point(x, y);
    pop();

    if (time > TAU) {
      if (maxH < N) maxH++;
      time = 0;
      tracer.clear();
    }

    time += dx;
  } else {
    int N = input.size();
    
    push();
    strokeWeight(3);
    stroke(90);
    for(int x = -width/2; x < width/2; x+=width/20) {
      line(x, -height/2, x, height/2);
    }
    for(int y = -height/2; y < height/2; y+=height/20) {
      line(-width/2, y, width/2, y);
    }
    
    fill(0);
    text(maxH + " Harmonics", 0, -height/2+20);
    text(String.format("Path length: %d\nTime: %.3f\ndx: 2π/%d\nDrawing mode: %b", N, time, N, paint), -width/2+10, -height/2+20);

    stroke(255);
    strokeWeight(5);
    point(0, 0);
    
    pop();
  }
}

void setup() {
  size(900, 900);
  noFill();

  tracer = new LinkedList<PVector>();
  input = new ArrayList<>();
  path = new fCoef[0];

  //default circle
  /*
  for(float i = 0; i < TAU*4; i+=TAU/75) {
   float d = map(i, 0, TAU*4, 0, height/2);
   input.add(v(d*cos(i), d*sin(i)));
   }
   for(float i = TAU*4; i < TAU*8; i+=TAU/75) {
   float d = map(i, TAU*4, TAU*8, height/2, 0);
   input.add(v(d*cos(i), d*sin(i)));
   }
   */

  for (float x = -width/4; x < width/4; x+=10) {
    input.add(v(x, height/4));
  }
  for (float y = height/4; y > -height/4; y-=10) {
    input.add(v(width/4, y));
  }
  for (float x = width/4; x > -width/4; x-=10) {
    input.add(v(x, -height/4));
  }
  for (float y = -height/4; y < height/4; y+=10) {
    input.add(v(-width/4, y));
  }
}

void draw() {
  background(70);
  translate(width/2, height/2);

  if (paint) paint();

  fourier();

  if (!start) {
    strokeWeight(10);
    for (PVector p : input) {
      point(p.x, p.y);
    }
  }
}

//quicksort
void swap(fCoef[] arr, int a, int b) {
  fCoef tmp = arr[a];
  arr[a] = arr[b];
  arr[b] = tmp;
}
int partition(fCoef[] arr, int low, int high) {
  fCoef p = arr[high];

  int i = low-1;

  for (int j = low; j < high; j++) {
    if (arr[j].am > p.am) {
      i++;
      swap(arr, i, j);
    }
  }
  swap(arr, i+1, high);
  return i+1;
}
void sortA(fCoef[] arr, int low, int high) {
  if (low < high) {
    int ind = partition(arr, low, high);

    sortA(arr, low, ind-1);
    sortA(arr, ind+1, high);
  }
}
