class Threshold extends PImage {

  private float[] thresholdH;
  private float[] thresholdS;
  private float[] thresholdB;

  private PImage image;
  private Range range[];

  private int imageSize;

  private final color WHITE = color(255, 255, 255);
  private final color BLACK = color(0, 0, 0);
  private final int H = 0;
  private final int S = 1;
  private final int B = 2;

  public Threshold(PImage image, Range range[]) {
    super(image.width, image.height);

    this.image = image;
    this.range = range;    

    imageSize = image.width * image.height;

    thresholdH = new float[2];
    thresholdS = new float[2];
    thresholdB = new float[2];

    initThresholds();
  }

  public void processThreshold() {
    image.loadPixels();
    //this.loadPixels();

    color currentColor;
    
    thresholdH = range[H].getArrayValue();
    thresholdS = range[S].getArrayValue();
    thresholdB = range[B].getArrayValue();

    for (int i = 0; i < imageSize; i++) {
      currentColor = image.pixels[i];

      int hue = (int) hue(currentColor);
      int saturation = (int) saturation(currentColor);
      int brightness = (int) brightness(currentColor);

      if (isInRange(hue, thresholdH) &&
        isInRange(saturation, thresholdS) &&
        isInRange(brightness, thresholdB)) {
        this.pixels[i] = WHITE;
      } else {
        this.pixels[i] = BLACK;
      }
    }

    this.updatePixels();
  }

  private void initThresholds() {
    thresholdH[0] = 0;
    thresholdS[0] = 0;
    thresholdB[0] = 0;

    thresholdH[1] = 360;
    thresholdS[1] = 100;
    thresholdB[1] = 100;
  }

  private boolean isInRange(int val, float threshold[]) {
    return (val > threshold[0] && val < threshold[1]);
  }
}


class Range{
  private float lowValue;
  private float highValue;
  private float arrayValue[];
  
  public Range(){
    arrayValue = new float[2];
  }
  
  public float[] getArrayValue(){
   return arrayValue; 
  }
  
  public void setArrayValue(float[] arrayValue){
   this.arrayValue = arrayValue; 
   this.lowValue = arrayValue[0];
   this.highValue = arrayValue[1];
  }
}