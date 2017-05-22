// This event function is called when the button 'load' is clicked
public void loadParams() {
  String[] lines = loadStrings("params.txt");
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