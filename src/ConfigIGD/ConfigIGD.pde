import processing.video.Capture;
import controlP5.*;
import gab.opencv.*;
import java.awt.Rectangle;


Capture camera;

OpenCV opencv;
ArrayList<Contour> contours;

Threshold threshInt;
Threshold threshExt;

ControlP5 views;
Range[] threshIntHSB;
Range[] threshExtHSB;
Button btnSave, btnLoad;

PrintWriter outputFile;

public void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}

public void setup() {
  background(COLOR_BACKGROUND);

  views = new ControlP5(this);
  threshIntHSB = new Range[3];
  threshExtHSB = new Range[3];

  initViews();

  camera = new Capture(this, CAMERA_WIDTH, CAMERA_HEIGHT, EXTERNAL_CAM);
  camera.start();

  threshInt  = new Threshold(camera, threshIntHSB);
  threshExt = new Threshold(camera, threshExtHSB);

  opencv = new OpenCV(this, CAMERA_WIDTH, CAMERA_HEIGHT);
  contours = new ArrayList<Contour>();

  colorMode(HSB, 360, 100, 100);
}

public void draw() {
  background(COLOR_BACKGROUND);

  threshExt.processThreshold();
  threshInt.processThreshold();

  drawImages();

  // Load the new frame for OpenCV
  opencv.loadImage(threshExt);

  // Find contours in threshold image
  contours = opencv.findContours(true, true);

  if (contours.size() > 0) {
    Contour ExtContour = contours.get(0);

    Rectangle rectExt = ExtContour.getBoundingBox();

    noFill(); 
    strokeWeight(2); 
    stroke(#FF0000);
    rect(rectExt.x + MARGIN, rectExt.y + MARGIN, rectExt.width, rectExt.height);

    // Load the new frame for OpenCV
    opencv.loadImage(threshInt);

    // Find contours in threshold image
    contours = opencv.findContours(true, true);

    if (contours.size() > 0) {
      Contour IntContour = contours.get(0);

      Rectangle rectInt = IntContour.getBoundingBox();

      noFill(); 
      strokeWeight(2); 
      stroke(#FF0000);
      rect(rectInt.x + 10, rectInt.y + 10, rectInt.width, rectInt.height);

      if (rectExt.contains(rectInt)) {
      }
    }
  }
}


// This event function is called when a new camera frame is available
public void captureEvent(Capture camera) {
  // Reading new frame
  camera.read();
}


// This function draws the images in window
public void drawImages() {
  fill(#FFFFFF);
  smooth();
  textSize(15);
  textAlign(CENTER);
  text("Threshold Internal", WINDOW_WIDTH*5/8, WINDOW_HEIGHT/4);
  text("Threshold External", WINDOW_WIDTH*7/8, WINDOW_HEIGHT/4);

  image(camera, MARGIN, MARGIN, CAMERA_WIDTH, CAMERA_HEIGHT);
  pushMatrix();
  scale(0.5);
  image(threshInt, 660*2, 250*2, CAMERA_WIDTH, CAMERA_HEIGHT);
  image(threshExt, 990*2, 250*2, CAMERA_WIDTH, CAMERA_HEIGHT);
  popMatrix();
}


// This function setups and draws the ControlP5 objects in window
public void initViews() {
  int xPuck = 660, yPuck = 130;
  int xRobot = 990, yRobot = 130;  
  int w = 310, h = 30;

  // ********** Range Puck ******************
  threshIntHSB[H] = views.addRange("Hp")
    .setCaptionLabel("H")
    .setPosition(xPuck, yPuck)
    .setSize(w, h)
    .setHandleSize(20)
    .setRange(0, 360)
    .setRangeValues(0, 360);

  threshIntHSB[S] = views.addRange("Sp")
    .setCaptionLabel("S")
    .setPosition(xPuck, yPuck+h+10)
    .setSize(w, h)
    .setHandleSize(20)
    .setRange(0, 100)
    .setRangeValues(0, 100);

  threshIntHSB[B] = views.addRange("Bp")
    .setCaptionLabel("B")
    .setPosition(xPuck, yPuck+2*h+2*10)
    .setSize(w, h)
    .setHandleSize(20)
    .setRange(0, 100)
    .setRangeValues(0, 100);
  // =========================================    

  // ********** Range Robot ******************
  threshExtHSB[H] = views.addRange("Hr")
    .setCaptionLabel("H")
    .setPosition(xRobot, yRobot)
    .setSize(w, h)
    .setHandleSize(20)
    .setRange(0, 360)
    .setRangeValues(0, 360);

  threshExtHSB[S] = views.addRange("Sr")
    .setCaptionLabel("S")
    .setPosition(xRobot, yRobot+h+10)
    .setSize(w, h)
    .setHandleSize(20)
    .setRange(0, 100)
    .setRangeValues(0, 100);

  threshExtHSB[B] = views.addRange("Br")
    .setCaptionLabel("B")
    .setPosition(xRobot, yRobot+2*h+2*10)
    .setSize(w, h)
    .setHandleSize(20)
    .setRange(0, 100)
    .setRangeValues(0, 100);
  // =========================================

  // ********** Buttons ******************
  btnSave = views.addButton("saveParams")
    .setLabel("SAVE")
    .setPosition(935, 30)
    .setSize(100, 30)
    ;

  btnLoad = views.addButton("loadParams")
    .setLabel("LOAD")
    .setPosition(935, 70)
    .setSize(100, 30);
  // =========================================
}