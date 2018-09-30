import controlP5.*;

class Cp5p1 {

  ControlP5 cp5;
  boolean hide = false;

  Cp5p1(PApplet pa) {
    cp5 = new ControlP5(pa);
  }

  public void init(float posx) {

    cp5.addTextlabel("label")
      .setText("Kinect capture location select." +'\n'+"Pressed 'C' Start tracking.('1' hide)")
      .setPosition(posx+20, 10+20*0)
      .setColorValue(0xffffffff)
      .setFont(createFont("", 13))
      ;

    cp5.addButtonBar("kcloc1")
      .setPosition(posx+20, 20+30*1)
      .setSize(200, 20)
      .setValue(row1)
      .addItems(split("block1 block2 block3 block4", " "))
      ;

    cp5.addButtonBar("kcloc2")
      .setPosition(posx+20, 20+30*2)
      .setSize(200, 20)
      .setValue(row2)
      .addItems(split("block1 block2 block3 block4", " "))
      ;

    cp5.addButtonBar("kcloc3")
      .setPosition(posx+20, 20+30*3)
      .setSize(200, 20)
      .setValue(row3)
      .addItems(split("block1 block2 block3 block4", " "))
      ;

    cp5.addButtonBar("kcloc4")
      .setPosition(posx+20, 20+30*4)
      .setSize(200, 20)
      .setValue(row4)
      .addItems(split("block1 block2 block3 block4", " "))
      ;

    cp5.addToggle("ShowName")
      .setPosition(posx+20, 20+30*6)
      .setSize(50, 20)
      .setValue(true)
      .setMode(ControlP5.SWITCH)
      ;

    cp5.addToggle("ShowKFrame")
      .setPosition(posx+20, 20+30*7+10)
      .setSize(50, 20)
      .setValue(true)
      .setMode(ControlP5.SWITCH)
      ;


    cp5.addBang("LoadXML")
      .setPosition(posx+20, 20+30*8+20)
      .setSize(50, 20)
      .setTriggerEvent(Bang.RELEASE)
      ;

    cp5.addBang("SaveXML")
      .setPosition(posx+20, 20+30*9+25)
      .setSize(50, 20)
      .setTriggerEvent(Bang.RELEASE)
      ;

    cp5.addToggle("oscauto")
      .setPosition(posx+20, 20+30*11+25)
      .setSize(50, 20)
      .setValue(oscauto)
      .setMode(ControlP5.SWITCH)
      ;

    cp5.addBang("quit")
      .setPosition(posx+20, 20+30*12+40)
      .setSize(50, 20)
      .setTriggerEvent(Bang.RELEASE)
      ;

    cp5.addFrameRate().setInterval(10).setPosition(width-20, height - 10);
  }

  void Background(float px, float py, float wid, float hei) {
    if (!hide) {
      noStroke();
      fill(0, 100);
      rect(px, py, wid, hei);
    }
  }

  void Config(float pos) {
    if (!hide) {
      int t = maxDepth;
      fill(255);
      textSize(12);
      text("'Q,W' Max_Threshold " + t, pos+20, 20+30*18+10 );

      int t2 = minDepth;
      text("'A,S' Min_Threshold " + t2, pos+20, 20+30*19+10 );
      text("'T,Y' blobThreshold " + blobthres, pos+20, 20+30*20+10 );
      text("'G,H' blur  "         + blur, pos+20, 20+30*21+10 );
    }
  }

  void hide() {
    hide = true;
    cp5.hide();
  }

  void show() {
    hide = false;
    cp5.show();
  }
}
