class Xml {

  XML myxml;
  String filepath = "data/setting.xml";

  int x_maxDepth;
  int x_minDepth;
  float x_blobthres;
  int x_blur;
  boolean x_oscauto;
  int x_row1;
  int x_row2;
  int x_row3;
  int x_row4;

  public void SetupXml() {
    myxml = loadXML(filepath);
  }

  public void LoadXml() {

    XML xml_c1 = myxml.getChild("depthmax");
    XML xml_c2 = myxml.getChild("depthmin");
    XML xml_c3 = myxml.getChild("blobthreshold");
    XML xml_c4 = myxml.getChild("blur");
    XML xml_c5 = myxml.getChild("oscAutoStart");

    XML xml_c6 = myxml.getChild("row1");
    XML xml_c7 = myxml.getChild("row2");
    XML xml_c8 = myxml.getChild("row3");
    XML xml_c9 = myxml.getChild("row4");

    x_maxDepth = int(trim(xml_c1.getContent()));
    x_minDepth = int(trim(xml_c2.getContent()));
    x_blobthres = float(trim(xml_c3.getContent()));
    x_blur = int(trim(xml_c4.getContent()));
    x_oscauto = boolean(trim(xml_c5.getContent()));

    x_row1 = int(trim(xml_c6.getContent()));
    x_row2 = int(trim(xml_c7.getContent()));
    x_row3 = int(trim(xml_c8.getContent()));
    x_row4 = int(trim(xml_c9.getContent()));

    maxDepth = x_maxDepth;
    minDepth = x_minDepth;
    blobthres = x_blobthres;
    blur = x_blur;
    oscauto = x_oscauto;

    row1 = x_row1;
    row2 = x_row2;
    row3 = x_row3;
    row4 = x_row4;
  }


  public void SaveXml() {

    x_maxDepth = maxDepth;
    x_minDepth = minDepth;
    x_blobthres = blobthres;
    x_blur = blur;
    x_row1 = row1;
    x_row2 = row2;
    x_row3 = row3;
    x_row4 = row4;

    XML xml_c1 = myxml.getChild("depthmax");
    XML xml_c2 = myxml.getChild("depthmin");
    XML xml_c3 = myxml.getChild("blobthreshold");
    XML xml_c4 = myxml.getChild("blur");

    XML xml_c6 = myxml.getChild("row1");
    XML xml_c7 = myxml.getChild("row2");
    XML xml_c8 = myxml.getChild("row3");
    XML xml_c9 = myxml.getChild("row4");

    xml_c1.setContent(str(x_maxDepth));
    xml_c2.setContent(str(x_minDepth));
    xml_c3.setContent(str(x_blobthres));
    xml_c4.setContent(str(x_blur));
    
    xml_c6.setContent(str(x_row1));
    xml_c7.setContent(str(x_row2));
    xml_c8.setContent(str(x_row3));
    xml_c9.setContent(str(x_row4));

    saveXML(myxml, filepath);
  }
}