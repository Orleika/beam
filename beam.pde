import processing.video.*;

/**
* 目からビーム
* copyrights 2014 Orleika All rights reserved.
*/
Capture cam;
PImage img;
int white_toler = 5;
int skin_red = 120;
int skin_toler = 10;
boolean wink = true;  // opened eyes
int num = 0;
int wink_x = 0;
int wink_y = 0;
int life = 100;

void setup() {
  size(320, 240);
  imageMode(CENTER);
  img = loadImage("sprite.png");
  cam = new Capture(this, width, height);
  cam.start();
}

void draw() {
  println(wink + ", " + getWink() + ", " + num);
  if (cam.available() == true) {
    cam.read();
    set(0, 0, cam);
  }
  if (wink && !getWink()) {
    wink = false;
  } else if (!wink && getWink()) {
    wink = true;
    num++;
    image(img, wink_x, wink_y);
  }
}

boolean getWink() {  // open eyes
  boolean skin = false;
  boolean white = false;
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      if (skin) {
        if (white) {
          if (getBlack(get(x, y))) {
            wink_x = x;
            wink_y = y;
            return true;
          }
        }
        if (getWhite(get(x, y))) {
          white = true;
          continue;
        } else {
          white = false;
        }
      }
      if (getSkin(get(x, y))) {
        skin = true;
      } else {
        skin = false;
      }
    }
  }
  return false;
}

boolean getWhite(color c) {
  if (90 < red(c) && 90 < green(c) && 90 < blue(c)) {  // over rgb 100 maybe white
    if (getPer(green(c), red(c)) < white_toler && getPer(blue(c), green(c)) < white_toler && getPer(red(c), blue(c))< white_toler) {  // tolerancean: under 5%
      return true;
    }
  }
  return false;
}

boolean getBlack(color c) {
  if (red(c) < 60 && green(c) < 60 && blue(c) < 60) {  // under rgb 60 maybe black
    return true;
  }
  return false;
}

boolean getSkin(color c) {
  if (skin_red < red(c)) {  // over red 120 maybe skin
    if (blue(c) < green(c) && green(c) + skin_toler < red(c)) {  // blue < green < red
      return true;
    }
  }
  return false;
}

int getPer(float x, float a) {
  int per = (int)((x - a) / a * 100);
  return per;
}

