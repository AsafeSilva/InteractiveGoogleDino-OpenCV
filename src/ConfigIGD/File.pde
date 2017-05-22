
// This event function is called when the button 'save' is clicked
public void saveParams() {

  // Creates a new file
  outputFile = createWriter("..\\InteractiveGoogleDino\\params.txt");

  // Writes in the created file
  outputFile.println("INT");
  outputFile.print(threshIntHSB[H].getLowValue() + "*" + threshIntHSB[H].getHighValue() + "|");
  outputFile.print(threshIntHSB[S].getLowValue() + "*" + threshIntHSB[S].getHighValue() + "|");
  outputFile.println(threshIntHSB[B].getLowValue() + "*" + threshIntHSB[B].getHighValue());
  outputFile.println("EXT");
  outputFile.print(threshExtHSB[H].getLowValue() + "*" + threshExtHSB[H].getHighValue() + "|");
  outputFile.print(threshExtHSB[S].getLowValue() + "*" + threshExtHSB[S].getHighValue() + "|");
  outputFile.println(threshExtHSB[B].getLowValue() + "*" + threshExtHSB[B].getHighValue());

  outputFile.flush(); // Write the remaining data
  outputFile.close(); // Finish the file
}


// This event function is called when the button 'load' is clicked
public void loadParams() {
  String[] lines = loadStrings("..\\InteractiveGoogleDino\\params.txt");
  String param = new String();

  for (int i = 0; i < lines.length; i++) {
   if (lines[i].trim().equals("INT")) {
     param = "int";
   } else if (lines[i].trim().equals("EXT")) {
     param = "ext";
   } else {
     if (param.equals("int")) {

       String[] hsbInt = split(lines[i], '|');

       for (int hsb = 0; hsb < hsbInt.length; hsb++) {
         String[] values = split(hsbInt[hsb], '*');

         try {
          threshIntHSB[hsb].setArrayValue(StringArrayToFloatArray(values));
         }
         catch(Exception e) {
          e.printStackTrace();
         }
       }
        
     } else if (param.equals("ext")) {
        
       String[] hsbExt = split(lines[i], '|');

       for (int hsb = 0; hsb < hsbExt.length; hsb++) {
        String[] values = split(hsbExt[hsb], '*');

        try {
         threshExtHSB[hsb].setArrayValue(StringArrayToFloatArray(values));
        }
        catch(Exception e) {
         e.printStackTrace();
        }
       }

     }
   }
  }
}


private float[] StringArrayToFloatArray(String[] str) throws Exception { 
  if (str != null) { 
    float floatarray[] = new float[str.length]; 

    for (int i = 0; i < str.length; i++) 
      floatarray[i] = Float.parseFloat(str[i]);

    return floatarray;
  } 
  return null;
}