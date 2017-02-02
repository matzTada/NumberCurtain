//2017/1/31 TadaMatz 
//movie https://youtu.be/9VwcQIYnuX8
//inspired by Kokuritsu Shin Bijutsukan's 10th aniversary's work
//NACT Colors insteration by Emmanuelle Moureaux http://www.emmanuelle.jp/

int cnt = 0;
int loopCnt = 0;
float dim = 50;

ArrayList<MyBox> boxes = new ArrayList<MyBox>();

import processing.serial.*;
Serial myPort;  // Create object from Serial class
//this is kind of stupid way. but... hum...
int phase = 0; 
int lenH = 0;
int lenL = 0;
int packetLen = 0;
String payload = "";


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

  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  println(Serial.list());
}

void draw() {
  background(0);

  pushMatrix();
  //camera
  ambientLight(63, 31, 31);
  directionalLight(255, 255, 255, -1, 0, 0);
  pointLight(63, 127, 255, mouseX, mouseY, 200);
  spotLight(100, 100, 100, mouseX, mouseY, 200, 0, 0, -1, PI, 2);
  camera(mouseX, mouseY, 200, width/2.0, height/2.0, 0, 0, 1, 0);  //カメラを定義、マウスの位置でカメラの位置が変化する

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

  popMatrix();

  //get average angleIncrease
  float aveAngleIncrease = 0;
  for (MyBox tempBox : boxes) {
    aveAngleIncrease += tempBox.angleIncrease;
  }
  aveAngleIncrease /= boxes.size();
  fill(255);  
  text(aveAngleIncrease, width * 7 / 8, height * 7 / 8);
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

  void updateAngleIncrease(float _increase) {
    angleIncrease += _increase;
  }
  
    void resetAngleIncrease(float _increase) {
    angleIncrease = _increase;
  }
}

void keyPressed() {
  switch(key) {
  case 'a':
    for (MyBox tempBox : boxes) {
      tempBox.updateAngleIncrease(2);
    }
    break;
  case 'A':
    for (MyBox tempBox : boxes) {
      tempBox.updateAngleIncrease(-2);
    }  
    break;
  }
}

void mouseClicked() {
  for (MyBox tempBox : boxes) {
    tempBox.updateAngleIncrease(random(-5, 5));
  }
}

void serialEvent(Serial myPort) {
  int c = myPort.read();
  if (c == 0x7E) { 
    phase = 1;
    payload = "";
  } else if (phase == 1) {
    phase = 2; 
    lenH = c;
  } else if (phase == 2) {
    phase = 3; 
    lenL = c;
    packetLen = lenH * 256 + lenL;
  } else if (phase == 3) {
    payload += char(c);
    if (payload.length() >= packetLen) {
      println(payload);
      for (int i = 1; i < 1 + 5; i++) { 
        print(hex(byte(payload.charAt(i))) + " ");
      }
      println("");
      int addrLItr = 6;
      int addrL = payload.charAt(addrLItr);
      print(hex(byte(payload.charAt(addrLItr))) + " ");
      for (int i = addrLItr + 1; i < addrLItr + 1 + 3; i++) { 
        addrL *= 256;
        addrL += int(payload.charAt(i));
        print(hex(byte(payload.charAt(i))) + " ");
      }
      println("");
      println(hex(addrL));

      if (addrL == 0x40AB9752) { //with LEGO
        println("LEGO");
        for (MyBox tempBox : boxes) {
          tempBox.updateAngleIncrease(2);
        }
      } else if (addrL == 0x40B0AE0A) { //without Arduino
        println("No-duino");
        for (MyBox tempBox : boxes) {
          tempBox.updateAngleIncrease(-2);
        }
      }

      phase = 0;
    }
  }
}