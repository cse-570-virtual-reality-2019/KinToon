import KinectPV2.*;
import java.lang.*;
KinectPV2 kinect;

PVector mouthCornerLeft = new PVector();

PVector mouthCornerRight = new PVector();

int mouthCenterY = 0;

int mouthTop = 0;

int mouthLeft = 0;

int mouthWidth = 0;

int mouthHeight = 0;

int showInfoTimeCount = 0;

final int REQUIRED_UPDATE_INFO_FRAME = 4;

int mouthClosedTimeCount = 0;

final int REQUIRED_MOUTH_CLOSED_FRAME = 4;

int mouthClosestDepth = 10000;

int mouthClosestDepthIndex = -1;

final int MapDepthToByte = 8000/256;

FaceData [] faceData;

int [] depth;

void setup() {
  
  size(1920, 1080, P2D);

  kinect = new KinectPV2(this);

  
  kinect.enableColorImg(true);

  kinect.enableFaceDetection(true);
  kinect.enableDepthImg(true);
  
    kinect.enableInfraredImg(true);
  
  

  kinect.init();
  
  
  
}

void draw() {
  
  background(0);
  depth = kinect.getRawDepthData();
  kinect.generateFaceData();

 /* //draw face information obtained by the infrared frame
  pushMatrix();
  //translate(1920*0.5f, 0.0f);
  image(kinect.getInfraredImage(), 0, 0);
  getFaceMapInfraredData();
  popMatrix();*/
  
   //draw face information obtained by the color frame
  pushMatrix();
 // scale(0.5f);
  image(kinect.getColorImage(), 0,0,1920,1080);
  getFaceData();
  

  popMatrix(); 


  
  text("frameRate "+frameRate, 50, 50);
}

public void getFaceMapInfraredData() {

  ArrayList<FaceData> faceData =  kinect.getFaceData();

  for (int i = 0; i < faceData.size(); i++) {
    FaceData faceD = faceData.get(i);

    if (faceD.isFaceTracked()) {
      //get the face data from the infrared frame
      PVector [] facePointsInfrared = faceD.getFacePointsInfraredMap();

      KRectangle rectFace = faceD.getBoundingRectInfrared();

      FaceFeatures [] faceFeatures = faceD.getFaceFeatures();

      //get the color of th user
      int col = faceD.getIndexColor();

      //for nose information
      PVector nosePos = new PVector();
      noStroke();

      fill(col);
      for (int j = 0; j < facePointsInfrared.length; j++) {
        //obtain the position of the nose
        if (j == KinectPV2.Face_Nose)
          nosePos.set(facePointsInfrared[j].x, facePointsInfrared[j].y);

        ellipse(facePointsInfrared[j].x, facePointsInfrared[j].y, 15, 15);
      }

      //Feature detection of the user
      if (nosePos.x != 0 && nosePos.y != 0)
        for (int j = 0; j < 8; j++) {
          int st   = faceFeatures[j].getState();
          int type = faceFeatures[j].getFeatureType();

          String str = getStateTypeAsString(st, type);

          fill(255);
          text(str, nosePos.x + 150, nosePos.y - 70 + j*25);
        }
      stroke(255, 0, 0);
      noFill();
      rect(rectFace.getX(), rectFace.getY(), rectFace.getWidth(), rectFace.getHeight());
    }
  }
}


public void getFaceData() {
  
 // System.out.println("1");
  //for (int h = 0; h < depth.length; h++)
  //{
  //  System.out.print(" "+depth[h]);
  //}
  ArrayList<FaceData> faceData =  kinect.getFaceData();

  for (int i = 0; i < faceData.size(); i++) {
    
    System.out.println("2");
    
    FaceData faceD = faceData.get(i);
    
    if (faceD.isFaceTracked()) {
      
      System.out.println("3");
      
      PVector [] facePointsColor = faceD.getFacePointsColorMap();

      KRectangle rectFace = faceD.getBoundingRectColor();

      FaceFeatures [] faceFeatures = faceD.getFaceFeatures();

      
      int col = faceD.getIndexColor();

      fill(col);

      
      PVector nosePos = new PVector();
      
      noStroke();

      
      for (int j = 0; j < facePointsColor.length; j++) {
        System.out.println("4");
        if (j == KinectPV2.Face_Nose)
          nosePos.set(facePointsColor[j].x, facePointsColor[j].y);
        else if (j == KinectPV2.Face_LeftMouth)
          mouthCornerLeft.set(facePointsColor[j].x, facePointsColor[j].y);
        else if (j == KinectPV2.Face_RightMouth)
          mouthCornerRight.set(facePointsColor[j].x, facePointsColor[j].y);
        ellipse(facePointsColor[j].x, facePointsColor[j].y, 15, 15);
      }
      
      

      mouthLeft = (int) mouthCornerLeft.x;
      System.out.println("mouthLeft "+mouthLeft);
      
      
      
      
      
      mouthWidth = (int) (mouthCornerRight.x - mouthCornerLeft.x);
       System.out.println("mouthWidth "+mouthWidth);
      
      mouthHeight = mouthWidth / 2;
      
      
      mouthCenterY =(int)(Math.min(mouthCornerRight.y,mouthCornerLeft.y))  + mouthHeight/2;
            System.out.println("mouthCenterY "+mouthCenterY);
            
            
      mouthTop = mouthCenterY - (mouthHeight / 2);
      System.out.println("mouthTop "+mouthTop);
     // rect(mouthLeft, mouthCenterY, 15, 15);
      
      //rect(mouthLeft, mouthCenterY, mouthWidth, mouthHeight);
      
      if (nosePos.x != 0 && nosePos.y != 0)
        
        for (int j = 0; j < 8; j++) {
        
          System.out.println("6");
          int st   = faceFeatures[j].getState();
          int type = faceFeatures[j].getFeatureType();

          String str = getStateTypeAsString(st, type);
          
          int tongueIDX = -1;
          int tongueIDY = -1;
         int ml = (int)map(mouthLeft, 0, 1920, 0, 512);
         int mw = (int)map(mouthWidth, 0, 1920, 0, 512);
         int mt = (int)map(mouthTop, 0, 1080, 0, 424);
         int mh = (int)map(mouthHeight, 0, 1080, 0, 424);
         

       for(int x = ml; x < ml + mw; x=x+4)
       {  
         System.out.println("100");
        
        for (int y = mt; y < mt + mh; y++)
        {
          System.out.println("len :"+depth.length);
          int offset = x + y * KinectPV2.WIDTHDepth;
         
          int d = depth[offset];
         System.out.println("d: "+d);
          if (d <10000 )
          {
            
            mouthClosestDepth = d;
            mouthClosestDepthIndex = offset;
            tongueIDX = x;
            tongueIDY = y;
            System.out.println("7");
          }
      
        }
       }
       tongueIDX = (int)map(tongueIDX, 0, 512, 0, 1920);
       tongueIDY = (int)map(tongueIDY, 0, 424, 0, 1080);
       
       System.out.println("8");
       System.out.println("mouthClosestDepthIndex: "+mouthClosestDepthIndex);
       System.out.println(str);
       System.out.println("tongueIDX: " + tongueIDX);
       System.out.println("tongueIDY: " + tongueIDY);
      if(mouthClosestDepthIndex != -1 && str.equals("MouthOpen: Yes") && tongueIDX != -1 && tongueIDY != -1)
      {
         mouthClosedTimeCount = 0;
         ellipse(tongueIDX, tongueIDY, 15, 15);
          
      }
          fill(255);
          text(str, nosePos.x + 150, nosePos.y - 70 + j*25);
        
      }
      
       
      stroke(255, 0, 0);
      noFill();
      rect(rectFace.getX(), rectFace.getY(), rectFace.getWidth(), rectFace.getHeight());
      //System.out.println("7");
    }
  }
}

//Face properties
// Happy
// Engaged
// LeftEyeClosed
// RightEyeClosed
// LookingAway
// MouthMoved
// MouthOpen
// WearingGlasses
// Each one can be  
//      Unknown
//      Yes
//      No
String getStateTypeAsString(int state, int type) {
  String  str ="";
  switch(type) {
  case KinectPV2.FaceProperty_Happy:
    str = "Happy";
    break;

  case KinectPV2.FaceProperty_Engaged:
    str = "Engaged";
    break;

  case KinectPV2.FaceProperty_LeftEyeClosed:
    str = "LeftEyeClosed";
    break;

  case KinectPV2.FaceProperty_RightEyeClosed:
    str = "RightEyeClosed";
    break;

  case KinectPV2.FaceProperty_LookingAway:
    str = "LookingAway";
    break;

  case KinectPV2.FaceProperty_MouthMoved:
    str = "MouthMoved";
    break;

  case KinectPV2.FaceProperty_MouthOpen:
    str = "MouthOpen";
    break;

  case KinectPV2.FaceProperty_WearingGlasses:
    str = "WearingGlasses";
    break;
  }

  switch(state) {
  case KinectPV2.DetectionResult_Unknown:
    str += ": Unknown";
    break;
  case KinectPV2.DetectionResult_Yes:
    str += ": Yes";
    break;
  case KinectPV2.DetectionResult_No:
    str += ": No";
    break;
  }

  return str;
}
