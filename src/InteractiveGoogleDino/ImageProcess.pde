
import java.awt.Rectangle;

public void thresholdProcess() {
  threshExt.processThreshold();
  threshInt.processThreshold();
}

public void trackObjects() {  
  // Load the new frame for OpenCV
  opencv.loadImage(threshExt);

  // Find contours in threshold image
  contours = opencv.findContours(true, true);

  if (contours.size() > 0) {
    Contour ExtContour = contours.get(0);

    Rectangle rectExt = ExtContour.getBoundingBox();

    // Load the new frame for OpenCV
    opencv.loadImage(threshInt);

    // Find contours in threshold image
    contours = opencv.findContours(true, true);

    if (contours.size() > 0) {
      Contour IntContour = contours.get(0);

      Rectangle rectInt = IntContour.getBoundingBox();

      if (rectExt.contains(rectInt)) {
        noFill(); 
        strokeWeight(2); 
        stroke(#FF0000);
        rect(rectInt.x + 10, rectInt.y + 10, rectInt.width, rectInt.height);
        
        positionY = CAMERA_HEIGHT - rectInt.y;
      }
    }
  }
}