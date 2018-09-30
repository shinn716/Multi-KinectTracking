import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

public int port = 12036;
public String ip = "127.0.0.1";
public String show = "null";

class OSCmanager {

  OSCmanager() {
    oscP5 = new OscP5(ip, 9999);
    myRemoteLocation = new NetAddress(ip, port);
  }
  
  //public void init(){
  //    oscP5 = new OscP5(ip, 9999);
  //  myRemoteLocation = new NetAddress(ip, port);
  //}

  public void Send(String address, float px, float py) {
    OscMessage myMessage = new OscMessage(address);
    myMessage.add(px);
    myMessage.add(py);
    oscP5.send(myMessage, myRemoteLocation);
    show = address+" "+round(px)+" "+round(py);
  }

  public void Dispose() {
    oscP5.dispose();
  }

  public String Show() {
    return show;
  }
}
