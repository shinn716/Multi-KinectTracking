import blobDetection.*;

class Blobing {

  BlobDetection theBlobDetection;
  OSCmanager osc;
  PImage blobimg;


  Blobing() {
    // Blank image
    blobimg = new PImage(80, 60);
    theBlobDetection = new BlobDetection(blobimg.width, blobimg.height);
    theBlobDetection.setPosDiscrimination(false);

    // OSC
    osc = new OSCmanager();
    //osc.init();
  }


  void SetThreshold(float blobthres) {
    theBlobDetection.setThreshold(blobthres);
  }

  // ==================================================
  // drawBlobsAndEdges()
  // ==================================================
  void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
  {
    noFill();
    Blob b;
    EdgeVertex eA, eB;
    ArrayList<float[]> sendDataArray = new ArrayList<float[]>();
    
    for (int n=0; n<theBlobDetection.getBlobNb(); n++)
    {
      b=theBlobDetection.getBlob(n);
      if (b!=null)
      {
        // Edges
        if (drawEdges)
        {
          strokeWeight(3);
          stroke(0, 255, 0);
          for (int m=0; m<b.getEdgeNb(); m++)
          {
            eA = b.getEdgeVertexA(m);
            eB = b.getEdgeVertexB(m);
            if (eA !=null && eB !=null)
              line(
                eA.x*width, eA.y*height, 
                eB.x*width, eB.y*height
                );
          }
        }

        // Blobs
        if (drawBlobs)
        {
          pushMatrix();
          noFill();
          strokeWeight(1);
          stroke(255, 0, 0);
          strokeWeight(1);
          stroke(255, 0, 0);

          rect(
            b.xMin*width, b.yMin*height, 
            b.w*width, b.h*height
            );

          fill(255, 0, 0);
          textSize(12);
          text(round(b.xMin*width)+","+round(b.yMin*height), (b.xMin*width), (b.yMin*height)-1);

          float[] temp = new float[2];
          temp[0] = b.xMin*width;
          temp[1] = b.yMin*height;
          sendDataArray.add(temp);

          //----OSC
          if (oscauto) {

            for (int k=0; k<sendDataArray.size(); k++) {
              float t1 = sendDataArray.get(k)[0];
              float t2 = sendDataArray.get(k)[1];
              osc.Send("/position", t1, t2);
              
              for(int l=0; l<5; l ++)
                text(osc.Show(), 1280-250, 20+30*(23+l)+10);
            }
            //osc.Send("/position", b.xMin*width, b.yMin*height);
            //text(osc.Show(), 1280-250, 20+30*23+10);
          }

          popMatrix();
          
          
        }
      }
    }
    
    sendDataArray.clear();
  }

  // ==================================================
  // Super Fast Blur v1.1
  // by Mario Klingemann 
  // <http://incubator.quasimondo.com>
  // ==================================================
  void fastblur(PImage img, int radius)
  {
    if (radius<1) {
      return;
    }
    int w=img.width;
    int h=img.height;
    int wm=w-1;
    int hm=h-1;
    int wh=w*h;
    int div=radius+radius+1;
    int r[]=new int[wh];
    int g[]=new int[wh];
    int b[]=new int[wh];
    int rsum, gsum, bsum, x, y, i, p, p1, p2, yp, yi, yw;
    int vmin[] = new int[max(w, h)];
    int vmax[] = new int[max(w, h)];
    int[] pix=img.pixels;
    int dv[]=new int[256*div];
    for (i=0; i<256*div; i++) {
      dv[i]=(i/div);
    }

    yw=yi=0;

    for (y=0; y<h; y++) {
      rsum=gsum=bsum=0;
      for (i=-radius; i<=radius; i++) {
        p=pix[yi+min(wm, max(i, 0))];
        rsum+=(p & 0xff0000)>>16;
        gsum+=(p & 0x00ff00)>>8;
        bsum+= p & 0x0000ff;
      }
      for (x=0; x<w; x++) {

        r[yi]=dv[rsum];
        g[yi]=dv[gsum];
        b[yi]=dv[bsum];

        if (y==0) {
          vmin[x]=min(x+radius+1, wm);
          vmax[x]=max(x-radius, 0);
        }
        p1=pix[yw+vmin[x]];
        p2=pix[yw+vmax[x]];

        rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
        gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
        bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
        yi++;
      }
      yw+=w;
    }

    for (x=0; x<w; x++) {
      rsum=gsum=bsum=0;
      yp=-radius*w;
      for (i=-radius; i<=radius; i++) {
        yi=max(0, yp)+x;
        rsum+=r[yi];
        gsum+=g[yi];
        bsum+=b[yi];
        yp+=w;
      }
      yi=x;
      for (y=0; y<h; y++) {
        pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
        if (x==0) {
          vmin[y]=min(y+radius+1, hm)*w;
          vmax[y]=max(y-radius, 0)*w;
        }
        p1=x+vmin[y];
        p2=x+vmax[y];

        rsum+=r[p1]-r[p2];
        gsum+=g[p1]-g[p2];
        bsum+=b[p1]-b[p2];

        yi+=w;
      }
    }
  }
}
