void setup(){
    size(500,500);
}
float e = 0-100;
float s = 134;
float speed = 1;
float e2 = 0-100;
float s2 = 236;
float speed2 = 3;  
float e3 = 0-100;
float s3 = 426;
float speed3 = 2;
void draw(){
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
  print(speed);
  print(speed2);
  print(speed3);
  background(0);
  rect(e,s, 24, 12);
  fill(0,200,0);
  if (e >= width){
    e = 0;
    s = random(1,450);
    //speed = random(1,3);
  }
  rect(e2,s2, 24, 12);
  fill(200,0,0);
  if (e2 >= width){
    e2 = 0;
    s2 = random(1,450);
    //speed2 = random(1,3);
  }
  rect(e3,s3, 24, 12);
  fill(0,0,200);
  if (e3 >= width){
    e3 = 0;
    s3 = random(1,450);
    //speed3 = random(1,3);
  }
}
