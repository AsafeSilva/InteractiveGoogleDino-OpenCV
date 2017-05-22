// Method for drawing mirror image in window
public void drawCamera(){
  image(camera, MARGIN, MARGIN, CAMERA_WIDTH, CAMERA_HEIGHT);
}

// This event function is called when a new camera frame is available
public void captureEvent(Capture camera) {

  // Reading new frame
  camera.read();

}