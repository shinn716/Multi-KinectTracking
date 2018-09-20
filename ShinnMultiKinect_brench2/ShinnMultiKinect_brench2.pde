import controlP5.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;
import blobDetection.*;

Cp5p1 p1;
Blobing myblobing = new Blobing();
Xml myxml = new Xml();

ArrayList<Kinect> multiKinect;
int numDevices = 0;
int kinectIndex = 0;

// Depth image
PImage depthImg;

// Blob
PGraphics pg;
boolean startTracking = false;
boolean ShowName = true;
boolean ShowKFrame = true;
boolean showload = false;
boolean showsave = false;
boolean selectp1 = false;
PVector captureLoc[] = new PVector[4];
int count1=0, count2=0; 

//----Kinect Data 
int maxDepth = 650;
int minDepth =  560;
float blobthres=.1f;
int blur = 2;
boolean oscauto;
int row1;
int row2;
int row3;
int row4;

void settings() {
  size(1280, 960);
  myxml.SetupXml();
}


void setup() {

  numDevices = Kinect.countDevices();
  multiKinect = new ArrayList<Kinect>();

  pg = createGraphics(1280, 960);

  for (int i  = 0; i < numDevices; i++) {
    Kinect tmpKinect = new Kinect(this);
    tmpKinect.activateDevice(i);
    tmpKinect.initDepth();
    multiKinect.add(tmpKinect);
    depthImg = new PImage(tmpKinect.width, tmpKinect.height);
  }

  myxml.LoadXml();

  p1 = new Cp5p1(this);
  p1.init(1280-250);
}

void draw() {

  background(0);


  if (startTracking) {

    myblobing.SetThreshold(blobthres);

    ShowDepth(0, captureLoc[0].x, captureLoc[0].y);
    ShowDepth(1, captureLoc[1].x, captureLoc[1].y);
    ShowDepth(2, captureLoc[2].x, captureLoc[2].y);
    ShowDepth(3, captureLoc[3].x, captureLoc[3].y);

    image(pg, 0, 0);

    pushMatrix();
    myblobing.blobimg.copy(pg, 0, 0, pg.width, pg.height, 
      0, 0, myblobing.blobimg.width, myblobing.blobimg.height);
    myblobing.fastblur(myblobing.blobimg, blur);
    myblobing.theBlobDetection.computeBlobs(myblobing.blobimg.pixels);
    myblobing.drawBlobsAndEdges(true, true);
    popMatrix();


    fill(255, 0, 0);
    textSize(12);
    text("THRESHOLD: [" + minDepth + ", " + maxDepth + "]", 10, 36);
    text("Blobthres: [" + blobthres +  "]", 10, 56);
  } else {
    ShowKinect(0, captureLoc[0].x, captureLoc[0].y);
    ShowKinect(1, captureLoc[1].x, captureLoc[1].y);
    ShowKinect(2, captureLoc[2].x, captureLoc[2].y);
    ShowKinect(3, captureLoc[3].x, captureLoc[3].y);
  }



  p1.Background(1280-250, 0, 250, height);
  p1.Config(1280-250);

  DrawGUI();

  // load and save hint
  if (showload) {
    count1++;
    if (count1>200) {
      count1 = 0;
      showload = false;
    }
  }

  if (showsave) {
    count2++;
    if (count2>200) {
      count2 = 0;
      showsave = false;
    }
  }
}

void keyPressed() 
{
  if (key == 'a') {
    minDepth = constrain(minDepth+2, 0, maxDepth);
  } else if (key == 's') {
    minDepth = constrain(minDepth-2, 0, maxDepth);
  } else if (key == 'q') {
    maxDepth = constrain(maxDepth+2, minDepth, 2047);
  } else if (key =='w') {
    maxDepth = constrain(maxDepth-2, minDepth, 2047);
  } else if (key =='t') {
    blobthres+=.01f;
  } else if (key =='y') {
    blobthres-=.01f;
  } else if (key=='c') {
    startTracking=!startTracking;
  } else if (key=='g') {
    blur++;
  } else if (key=='h') {
    blur--;
  }



  if (key == '1') {
    selectp1 =!selectp1;
    if (selectp1)
      p1.show();
    else
      p1.hide();
  }
}

void DrawGUI() {

  if (ShowKFrame) 
  {
    PVector kscreen = new PVector(640, 480);
    stroke(10, 255, 10);
    noFill();
    rect(2, 2, kscreen.x+2, kscreen.y+2);
    rect(2+kscreen.x, 2, kscreen.x+2, kscreen.y+2);
    rect(2, 2+kscreen.y, kscreen.x+2, kscreen.y+2);
    rect(2+kscreen.x, 2+kscreen.y, kscreen.x+2, kscreen.y+2);

    if (showload) {
      fill(100, 255, 100);
      textSize(12);
      text("Load Data Success", 1024+100, 20+30*8+35);
    }

    if (showsave) {
      fill(100, 255, 100);
      textSize(12);
      text("Save Data Success", 1024+100, 20+30*9+40);
    }
  }
}

public void ShowKinect(int index, float px, float py) {
  if (index<numDevices) {
    Kinect tmpKinect = (Kinect) multiKinect.get(index);
    image(tmpKinect.getDepthImage(), px, py, 640, 480);
  }

  if (ShowName) {
    fill(255);
    textSize(32);
    text("KCapture " + index, px + 640/2-100, py + 480/2);
  }
}

public void ShowDepth(int index, float px, float py) {
  pushMatrix();
  pg.beginDraw();
  if (index<numDevices) {
    Kinect tmpKinect = (Kinect) multiKinect.get(index);
    int[] rawDepth = tmpKinect.getRawDepth();
    for (int i=0; i < rawDepth.length; i++) {
      if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
        depthImg.pixels[i] = color(150);
      } else {
        depthImg.pixels[i] = color(0);
      }
    }
    depthImg.updatePixels();
    pg.image(depthImg, px, py, 512, 424);
  }
  pg.endDraw();
  popMatrix();

  if (ShowName) {
    fill(255);
    textSize(32);
    text("KCapture " + index, px + 640/2-100, py + 480/2);
  }
}

void quit() {
  exit();
}

//----Cp5
void kcloc1(int n) {
  PVector box1 = new PVector(2+0, 2+0);
  PVector box2 = new PVector(2+2+640, 2+0);
  PVector box3 = new PVector(2+0, 2+2+480);
  PVector box4 = new PVector(2+2+640, 2+2+480);
  
  row1 =n;

  if (n==0)
    captureLoc[0] = box1;
  else if (n==1)
    captureLoc[0] = box2;
  else if (n==2)
    captureLoc[0] = box3;
  else if (n==3)
    captureLoc[0] = box4;
}

void kcloc2(int n) {
  PVector box1 = new PVector(2+0, 2+0);
  PVector box2 = new PVector(2+2+640, 2+0);
  PVector box3 = new PVector(2+0, 2+2+480);
  PVector box4 = new PVector(2+2+640, 2+2+480);
  
  row2 =n;

  if (n==0)
    captureLoc[1] = box1;
  else if (n==1)
    captureLoc[1] = box2;
  else if (n==2)
    captureLoc[1] = box3;
  else if (n==3)
    captureLoc[1] = box4;
}

void kcloc3(int n) {
  PVector box1 = new PVector(2+0, 2+0);
  PVector box2 = new PVector(2+2+640, 2+0);
  PVector box3 = new PVector(2+0, 2+2+480);
  PVector box4 = new PVector(2+2+640, 2+2+480);
  
  row3 =n;

  if (n==0)
    captureLoc[2] = box1;
  else if (n==1)
    captureLoc[2] = box2;
  else if (n==2)
    captureLoc[2] = box3;
  else if (n==3)
    captureLoc[2] = box4;
}

void kcloc4(int n) {
  PVector box1 = new PVector(2+0, 2+0);
  PVector box2 = new PVector(2+2+640, 2+0);
  PVector box3 = new PVector(2+0, 2+2+480);
  PVector box4 = new PVector(2+2+640, 2+2+480);
  
  row4 =n;

  if (n==0)
    captureLoc[3] = box1;
  else if (n==1)
    captureLoc[3] = box2;
  else if (n==2)
    captureLoc[3] = box3;
  else if (n==3)
    captureLoc[3] = box4;
}


public int getMaxThreshold() {
  return maxDepth;
}

public void setMaxThreshold(int t) {
  maxDepth =  t;
}

public int getMinThreshold() {
  return minDepth;
}

public void setMinThreshold(int t) {
  minDepth =  t;
}

void LoadXML() {
  println("Load");
  showload = true;
  myxml.LoadXml();
}

void SaveXML() {
  println("Save");
  showsave = true;
  myxml.SaveXml();
}