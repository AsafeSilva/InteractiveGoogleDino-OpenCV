
// LIBRARIES
import processing.video.Capture;
import gab.opencv.*;
import java.awt.Robot;
import java.awt.AWTException;
import java.awt.event.KeyEvent;

// Variable that stores camera frames
Capture camera;

// OpenCV variables
OpenCV opencv;
ArrayList<Contour> contours;

// Variables that store images for processing
// 'Threshold' is a project class. [Extends PImage] {Located in "Threshold" file}
Threshold threshInt;
Threshold threshExt;

// 'Range' variables [project class], stores the thresholds of the HSB (Hue, Saturation, Brightness)
// {Located in "Threshold" file}
Range[] threshIntHSB;
Range[] threshExtHSB;


// Height
int positionY;
int lastPositionY;
int playerHeight;
int jumpHeight;

Robot robot;

public void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}

public void setup() {
  background(COLOR_BACKGROUND);

  frameRate(200);

  // 'Range' array instanciate
  threshIntHSB = new Range[3];
  threshExtHSB = new Range[3];
  for (int i = 0; i < 3; i++) {
    threshIntHSB[i] = new Range();
    threshExtHSB[i] = new Range();
  }

  // 'OpenCV' instanciate
  opencv = new OpenCV(this, CAMERA_WIDTH, CAMERA_HEIGHT);
  contours = new ArrayList<Contour>();

  // 'Capture' instanciate
  camera = new Capture(this, CAMERA_WIDTH, CAMERA_HEIGHT, EXTERNAL_CAM);
  camera.start();

  // 'PImage' and 'Threshold' instanciate
  threshInt  = new Threshold(camera, threshIntHSB);
  threshExt = new Threshold(camera, threshExtHSB);

  // Load parameters saved in 'txt' file
  loadParams();

  // Sets color mode to HSB
  colorMode(HSB, 360, 100, 100);

  try {
    robot = new Robot();
  }
  catch(AWTException e) {
    e.printStackTrace();
  }
  
  Thread stability = new Thread() {
    public void run() {
      while (true) {

        if (abs(positionY - lastPositionY) < 3) {
          println("UPDATE PLAYER HEIGHT");
          playerHeight = positionY;
        }

        lastPositionY = positionY;

        try {
          Thread.sleep(250);
        }
        catch(InterruptedException e) {
          e.printStackTrace();
        }
      }
    }
  };

  stability.start();
}

public void draw() {
  background(COLOR_BACKGROUND);

  // Shows the captured images in the window.
  // Frames are read in event funcition [captureEvent(Capture c)], located in "Camera" file.
  // {Located in "Camera" file}
  drawCamera();


  // Filters the camera image according with threshold values.
  // {Located in "ImageProcess" file}
  thresholdProcess();

  // Uses filtered images to follow objects and detect their position (x, y)
  // Uses algorithm with 'OpenCV' library
  // {Located in "ImageProcess" file}
  trackObjects();

  if (playerHeight != 0)
    jumpHeight = positionY * 100/ playerHeight;


  fill(360, 100, 100);
  textSize(50);
  text(jumpHeight, 50, 50);

  //Checks if the player jumped High or normal height or if the player get down 
  if (jumpHeight > 125) {

    text("UP", 500, 50);
    robot.keyPress(KeyEvent.VK_UP);
  } else if (jumpHeight > 110 && jumpHeight <= 125) {

    text("JUMP", 500, 50);
    robot.keyPress(KeyEvent.VK_UP);
    robot.keyRelease(KeyEvent.VK_UP);
  } else if (jumpHeight < 70) {

    text("DOWN", 500, 50);
    robot.keyPress(KeyEvent.VK_DOWN);
  } else {

    text("---", 500, 50);
    robot.keyRelease(KeyEvent.VK_UP);
    robot.keyRelease(KeyEvent.VK_DOWN);
  }
}