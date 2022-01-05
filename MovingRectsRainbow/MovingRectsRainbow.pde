void setup(){
    size(500,500);
    background(0);
}
float e = 0-100, s = 134, speed = 1;
float e2 = 0-100, s2 = 236, speed2 = 3;  
float e3 = 0-100, s3 = 426, speed3 = 2;
float t = 0, h = 0, g = 0;
int val = 0;
void draw(){
  val = val + 1;
  print(val);
  if (val == 5){
    background(t,h,g);
    val = 0;
  }
  if (speed < 25){
    speed = speed + 0.2;
  }
  if (speed2 < 25){
    speed2 = speed2 + 0.2;
  }
  if (speed3 < 25){
    speed3 = speed3 + 0.2;
  }
  e =  e + speed;
  e2 = e2 + speed2;
  e3 = e3 + speed3;
  //print(speed);
  //print(speed2);
  //print(speed3);
  //background(0);
  rect(e,s, 24, 12);
  fill(random(0,255),random(0,255),random(0,255));
  if (e >= width){
    e = 0-10;
    s = random(1,450);
    speed = random(1,3);
  }
  rect(e2,s2, 24, 12);
  fill(random(0,255),random(0,255),random(0,255));
  if (e2 >= width){
    e2 = 0-10;
    s2 = random(1,450);
    speed2 = random(1,3);
  }
  rect(e3,s3, 24, 12);
  fill(random(0,255),random(0,255),random(0,255));
  if (e3 >= width){
    e3 = 0-10;
    s3 = random(1,450);
    speed3 = random(1,3);
  }
}
void mousePressed(){
  t = random(1,255);
  h = random(1,255);
  g = random(1,255);
}
