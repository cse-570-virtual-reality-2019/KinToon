import KinectPV2.*;
import java.lang.*;
KinectPV2 kinect;

Button b1;
Button b2;
Button b3;

int selectedID;

PImage img1; //rainbowBlush
PImage img2; //rainbowBlush
PImage img3; //rainbowBlush

PImage img4; //rudolph
PImage img5; //rudolph
PImage img6; //rudolph

PImage img7; //dog
PImage img8; //dog
PImage img9; //dog

PVector mouthCornerLeft = new PVector();

PVector mouthCornerRight = new PVector();

int button = 0;

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
  
  b1 = new Button(1800, 20, 1,"1");
  b2 = new Button(1800, 130, 2, "2");
  b3 = new Button(1800, 240, 3, "3" );
  img1 = loadImage("rainbowTongue.png");
  img2 = loadImage("rainbowBlush.png");
  img3 = loadImage("rudolph.png");
  img4 = loadImage("cat.png");
  

  
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

  pushMatrix();
 // scale(0.5f);
 kinect.getColorImage();
 //image(kinect.getColorImage(), 0,0,1920,1080);
 background(255, 255, 255, 128);
  getFaceData();
  
 b1.drawButton();
 b2.drawButton();
 b3.drawButton();
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
      PVector eyeRight = new PVector();
       PVector eyeLeft = new PVector();
      
      noStroke();

      
      for (int j = 0; j < facePointsColor.length; j++) {
        System.out.println("4");
        if (j == KinectPV2.Face_Nose)
          nosePos.set(facePointsColor[j].x, facePointsColor[j].y);
        else if (j == KinectPV2.Face_LeftMouth)
        {
          mouthCornerLeft.set(facePointsColor[j].x, facePointsColor[j].y);
        }
        else if (j == KinectPV2.Face_RightMouth)
          mouthCornerRight.set(facePointsColor[j].x, facePointsColor[j].y);
        else if (j == KinectPV2.Face_RightEye)
          eyeRight.set(facePointsColor[j].x, facePointsColor[j].y);
        else if (j == KinectPV2.Face_LeftEye)
          eyeLeft.set(facePointsColor[j].x, facePointsColor[j].y);
       ellipse(facePointsColor[j].x, facePointsColor[j].y, 15, 15);
        
      }
      
       System.out.println("width:"+ (abs(eyeLeft.x - eyeRight.x)));
        System.out.println("height: "+(abs(eyeLeft.y - nosePos.y)));
//System.exit(0);
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
         //ellipse(tongueIDX, tongueIDY, 25, 25);
         if (selectedID == 1)
          image(img1, tongueIDX-40, tongueIDY,80, 100);  

          
      }
          fill(255);
          text(str, nosePos.x + 150, nosePos.y - 70 + j*25);
          
          if (selectedID == 1)
          {
             //image(img2,nosePos.x-40,nosePos.y-15,80,30);
             image(img2,nosePos.x-75,nosePos.y-20,150,40);
             
          }
          else if (selectedID == 2)
          {  
             //imageMode(CENTER);
             //image(img3,nosePos.x-(abs(eyeLeft.x - eyeRight.x)+50)/2,nosePos.y-(abs(eyeLeft.y - nosePos.y)+50)/2 ,abs(eyeLeft.x - eyeRight.x)+50,abs(eyeLeft.y - nosePos.y)+50);
             image(img3, nosePos.x-100, nosePos.y-50, 200, 100);
             
          }
          else if(selectedID == 3)
          {
            //image(img4,nosePos.x-50,nosePos.y-75 ,100 ,100);
            image(img4,nosePos.x-75,nosePos.y-150 ,150 ,200);
          }
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


void mousePressed() {

  if (b1.rectOver) {
    b1.currentColor = b1.rectColor;
    selectedID = b1.id;
  }
   if (b2.rectOver) {
    b2.currentColor = b2.rectColor;
    selectedID = b2.id;
  }
   if (b3.rectOver) {
    b3.currentColor = b3.rectColor;
    selectedID = b3.id;
  }
}
