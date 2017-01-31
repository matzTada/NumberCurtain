//2017/1/31 TadaMatz 
//movie https://youtu.be/9VwcQIYnuX8
//inspired by Kokuritsu Shin Bijutsukan's 10th aniversary's work
//NACT Colors insteration by Emmanuelle Moureaux http://www.emmanuelle.jp/

int cnt = 0;
int loopCnt = 0;
float dim = 50;

ArrayList<MyBox> boxes = new ArrayList<MyBox>();

void setup() {
  size(800, 800, P3D);
  noStroke();

  for (int i = -height/6; i < height/6; i += dim*1) {
    for (int j = -width/6; j < width/6; j += dim*1) {
      for (int k = -width/6; k < width/6; k += dim*1) {
        //boxes.add(new MyBox(i, j, k));
        boxes.add(new MyBox(i, j, k, random(-5, 5)));
      }
    }
  }
}

void draw() {
  background(0);

  ambientLight(63, 31, 31);
  directionalLight(255, 255, 255, -1, 0, 0);
  pointLight(63, 127, 255, mouseX, mouseY, 200);
  spotLight(100, 100, 100, mouseX, mouseY, 200, 0, 0, -1, PI, 2);

  //カメラを定義、マウスの位置でカメラの位置が変化する
  camera(mouseX, mouseY, 200, width/2.0, height/2.0, 0, 0, 1, 0);

  translate(width / 2, height / 2, -20);
  cnt++;
  loopCnt = 0;
  for (MyBox tempBox : boxes) {
    pushMatrix();
    translate(tempBox.x, tempBox.y, tempBox.z);
    //tempBox.update(random(-10, 10));
    tempBox.update();
    rotateY(radians(tempBox.angle));
    //box
    noFill();
    stroke(255, 100);
    box(dim*0.7, dim*0.8, dim*0.1);        
    //text
    textSize(dim);
    textMode(SHAPE);        
    textAlign(CENTER, CENTER);
    fill(255, 200);
    text(loopCnt++%10, 0, 0);
    popMatrix();
  }
}

class MyBox {
  float x, y, z;
  float angle;
  float angleIncrease;

  MyBox(float _x, float _y, float _z) {
    x = _x;
    y = _y;
    z = _z;
    angle = 0;
  }

  MyBox(float _x, float _y, float _z, float _angleIncrease) {
    x = _x;
    y = _y;
    z = _z;
    angle = 0;
    angleIncrease = _angleIncrease;
  }

  void update() {
    angle+= angleIncrease;
  }

  void update(float _angle) {
    angle += _angle;
  }
}