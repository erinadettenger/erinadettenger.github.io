String path = "redwinequality.csv";
String xName; 
String yName;
String [] names;
float [] values;
float numOfDimensions;

float startPointX;
float yLineMaxPosition;
float endPointX;
float endPointY;

float button_x;
float button_y;
float button_w;
float button_h;

float increment;

Table table;
PVector mouse;
PVector boundaryBox;
PVector p1;
PVector p2;

  boolean text = false;

float a , b , c = width*.07, d ;
float lastHeight;
float lastWidth;

float x = 0;
float y = 0;
float z = 0;
  float boundaryBoxMinValueForDimension = 0;
  float boundaryBoxMaxValueForDimension = 0;
  boolean isThereABoundaryBox = false;
  int boundaryBoxDimension = 0;

HashMap<Integer, dimension> dimensionMap = new HashMap<Integer, dimension>();

class dimension{
  String name;
  float [] values;
  float maxVal;
  float minVal;
  int dimensionNumber;
  boolean selected;
  boolean flipped;
  dimension(String cname, float [] cvalues, float cmaxVal, float cMinVal, int cdimensionNumber, boolean cselected, boolean cflipped){
    name = cname;
    values = cvalues;
    maxVal = cmaxVal;
    minVal = cMinVal;
    dimensionNumber = cdimensionNumber;
    selected = cselected;
    flipped = cflipped;
  }
  
}

void setup(){
 // surface.setResizable(true);
  size(500,500);
  //dimensionMap = new HashMap<Integer, dimension>();
  loadMyInput();
  mouse = new PVector();
  
  boundaryBox = new PVector();

}



void draw(){
 
  background(250);
  stroke(0);
  fill(0);
  mouse.set(mouseX, mouseY, 0);
 x = a*width/lastWidth;
 y=b*height/lastHeight;
 z = d*height/lastHeight;
 boundaryBox.set(a, b, 0);
 if (isThereABoundaryBox){
   rect(x, y, c, z);
 }
  
  
  
 button_x = width * .93;
 button_y = height * .3;
 button_w = width * .5;
 button_h =height * .06;


 //draw button
   fill(102,194,165, 150);
  rect(button_x, button_y, button_w, button_h);
   textSize((height + width)/2 * .012);
  fill(0);
   text("Clear", button_x * 1.01, button_y + button_y*.08);
   text("dimension", button_x * 1.01, button_y + button_y*.14);
   text("selection", button_x * 1.01, button_y + button_y*.19);
  
  
  
  text = false;
  isThereABoundaryBox = false;
  //DRAWS THE LINES FOR EACH DIMENSION ITSELF
  startPointX = width * 0.07;
  yLineMaxPosition = height * 0.9;
  endPointX = width  * 0.86;
  endPointY = height * 0.9;
  increment = (endPointX - startPointX)/(numOfDimensions-1);
  float increaseIncrement = 0;
  float yLineMinPosition = height*.1;

  
  float barLength  = yLineMaxPosition - yLineMinPosition;
  float actualBLForThisDim;
  //line(startPointX, startPointY, startPointX, height*0.1);
  fill(255, 105, 97);
   ellipse(startPointX/2.4, height * .95, width*.047, height*.03);
   fill(0);
   text("flip", startPointX/3, height * .95);
  
  for(int i = 0; i < numOfDimensions; i ++){
     dimension a = dimensionMap.get(i + 1);
     //vectors for this dimension
    p1 = new PVector(startPointX + increaseIncrement, yLineMaxPosition);
     p2 = new PVector(startPointX + increaseIncrement, yLineMinPosition);
     if(boundBoxNearDimension(p1, p2)){
       isThereABoundaryBox = true;
        actualBLForThisDim = a.maxVal - a.minVal;
       float w = (y-yLineMinPosition) * actualBLForThisDim / barLength;
        boundaryBoxMaxValueForDimension = a.maxVal  - w;
        float t = (y + z -yLineMinPosition) * actualBLForThisDim / barLength;
        boundaryBoxMinValueForDimension = a.maxVal - t;
        boundaryBoxDimension = i+1;
      
        
     }
      if(pointInsideLine(mouse, p1, p2, 2) && mousePressed){
        deselect();
       a.selected = true;
      }
       
      if(a.selected){
        strokeWeight(6);
            
          String myname = a.name;
        print(myname);
        stroke(0);
        text("dimension", button_x*.96 , button_y*1.5);
        text("selected:", button_x*.96, button_y*1.59);
        textSize((height + width)/2.4 * .014);
         text(myname, button_x*.96 , button_y*1.68);
   
        
      }
    line(startPointX + increaseIncrement, yLineMaxPosition, startPointX + increaseIncrement, yLineMinPosition);
    strokeWeight(1);
    textSize(((height + width)/2) * .015);
     text(a.name, startPointX + increaseIncrement - increment/2.5, height * .07);
  
   
   if(a.flipped){
     text(a.maxVal, startPointX + increaseIncrement - increment/3, height * .93);
      text(a.minVal, startPointX + increaseIncrement - increment/3, height*.095);
      fill(200,0,0);
   }
   else{
      text(a.minVal, startPointX + increaseIncrement - increment/3, height * .93);
      text(a.maxVal, startPointX + increaseIncrement - increment/3, height*.095);
      fill(0);
   }
  

   //FLIPPING
   ellipse(startPointX + increaseIncrement, height * .95, 10, 10);
   if(overCircle(startPointX + increaseIncrement, height * .95, 10) && mousePressed){
       a.flipped = !a.flipped;
  
   }
 
   increaseIncrement += increment;
    fill(0);
  }
  
  //drawing each items line
  //int dimNumber = 1;
  
  float maxMinusMinForThisDimension = 0;
  float itemValueForThisDimension = 0;
  float thisXPosition = startPointX;
  float lastXPosition = 0;
   float scaledYPosition;
  float lastYPosition = 0;
  boolean oneIsSelected = false;
  int selectedDim = 0;
   for(HashMap.Entry<Integer, dimension> entry : dimensionMap.entrySet()){
    dimension d = entry.getValue();
    if(d.selected == true){
      oneIsSelected = true;
      selectedDim = entry.getKey();
    }
  }
  
  if (oneIsSelected){
    gradientForDimensionSelected(selectedDim, yLineMinPosition);
   
  }
  else if (isThereABoundaryBox){
    gradientForBoundaryBox(boundaryBoxDimension, yLineMinPosition, boundaryBoxMinValueForDimension, boundaryBoxMaxValueForDimension);
      dimension thisDim = dimensionMap.get(boundaryBoxDimension);
    String thisname = thisDim.name;
    print(thisname);
    stroke(0);
      text("boundary", button_x*.96 , button_y*1.5);
        text("box:", button_x*.96, button_y*1.59);
        textSize((height + width)/2.4 * .014);
         text(thisname, button_x*.96 , button_y*1.68);
   
}
  else{
    for(TableRow row: table.rows()){
     stroke(0);
     strokeWeight(1);
     
     float z = 0;
         for(int dimNumber = 1; dimNumber <= numOfDimensions; dimNumber++){
           String toolkit = "";
           dimension thisOne = dimensionMap.get(dimNumber);
           maxMinusMinForThisDimension = thisOne.maxVal - thisOne.minVal;
           itemValueForThisDimension = row.getFloat(thisOne.name);
           if(thisOne.flipped){
              scaledYPosition = yLineMinPosition + (barLength*(itemValueForThisDimension - thisOne.minVal)/maxMinusMinForThisDimension);
           }
           else{
              scaledYPosition = endPointY - (barLength*(itemValueForThisDimension - thisOne.minVal)/maxMinusMinForThisDimension);
           }
          
           thisXPosition = startPointX + z;
           if(dimNumber == 1){
             lastXPosition = startPointX;
             lastYPosition = scaledYPosition;
           }
           
       
           else {//draw the line
             p1 = new PVector(thisXPosition, scaledYPosition);
             p2 = new PVector(lastXPosition, lastYPosition);
             if(pointInsideLine(mouse, p1, p2, 2)){
             
               stroke(0,255,0);
               strokeWeight(2);
               
               dimension first = dimensionMap.get(1);
                toolkit = first.name + ": " + row.getFloat(first.name) ;
                for(int i = 2; i <= numOfDimensions; i++){
                   dimension add = dimensionMap.get(i);
                   toolkit +=  ", " + add.name + ": " + row.getFloat(add.name);
                }
             
              
                 if(!text){//don't overlay text
                 textSize(((height + width)/2) * .014);
                 fill(0,0,200);
                    text(toolkit, width * .05, height * .03);
                    text = true;
                    fill(0);
                 }
                 else{
                  // fill(255);
                  // stroke(255);
                  // rect(width * .01, height * .01, 100, 10);
                  // stroke(0);
                 }
             } 
           
             line(lastXPosition, lastYPosition, thisXPosition, scaledYPosition);
          
             lastXPosition = thisXPosition;
             lastYPosition = scaledYPosition;
       
             //print("line");
           } 
           z +=increment;
         }
          
    }
    
    
    
    }
 
}



void loadMyInput(){
  table = loadTable(path, "header");
   numOfDimensions = table.getColumnCount() - 1;
   int numOfValues = table.getRowCount() - 1;
   print(numOfDimensions);
   
  String[] lines = loadStrings(path);
  String[] firstLine = split(lines[0], ",");
  
  //make our hashmap of dimension objects
  
  //first make all the dimension objects, create array of values, and add to hashmap
   for(int i = 1; i <= numOfDimensions ; i++){
     String dimName = firstLine[i];
     float[] dimValues = new float[numOfValues];
    // print("dimname: " + dimName);
    
     float dimMin = Float.MAX_VALUE;
     float dimMax = Float.MIN_VALUE;
      int dimValuesCounter = 0;
      for(TableRow row : table.rows()){
       // print(" " + row.getFloat(dimName));
        if(dimValuesCounter >= numOfValues){
          break;
        }
           dimValues[dimValuesCounter] = row.getFloat(dimName);
           dimMin = Math.min(dimMin, dimValues[dimValuesCounter]); //update min and max
           dimMax = Math.max(dimMax, dimValues[dimValuesCounter]);
           dimValuesCounter++;
       
     }
     
     //now we can create the dimension object
    // print("min: " + dimMin);
    // print("max: " + dimMax);
     dimension d = new dimension(dimName, dimValues, dimMax, dimMin, i, false, false);
     //then we add this one to the hashmap based on it's name
     dimensionMap.put(d.dimensionNumber, d);

     
   }
}




//GOT CODE FOR THIS FUNCTION pointInsideLine FROM https://processing.org/discourse/beta/num_1247920826.html
/**
  * PVector thePoint 
  * the point we will check if it is close to our line.
  *
  * PVector theLineEndPoint1 
  * one end of the line.
  *
  * PVector theLineEndPoint2
  * the second end of the line.
  *
  * int theTolerance 
  * how close thePoint must be to our line to be recogized.
  */
boolean pointInsideLine(PVector thePoint,
                        PVector theLineEndPoint1, 
                        PVector theLineEndPoint2, 
                        int theTolerance) {
                          
  PVector dir = new PVector(theLineEndPoint2.x,
                            theLineEndPoint2.y,
                            theLineEndPoint2.z);
  dir.sub(theLineEndPoint1);
  PVector diff = new PVector(thePoint.x, thePoint.y, 0);
  diff.sub(theLineEndPoint1);

  // inside distance determines the weighting 
  // between linePoint1 and linePoint2 
  float insideDistance = diff.dot(dir) / dir.dot(dir);

  if(insideDistance>0 && insideDistance<1) {
    // thePoint is inside/close to 
    // the line if insideDistance>0 or <1
   
    PVector closest = new PVector(theLineEndPoint1.x,
                                  theLineEndPoint1.y,
                                  theLineEndPoint1.z);
    dir.mult(insideDistance);
    closest.add(dir);
    PVector d = new PVector(thePoint.x, thePoint.y, 0);
    d.sub(closest);
     // println((insideDistance>0.5) ? "b":"a");
    float distsqr = d.dot(d);
    
    // check the distance of thePoint to the line against our tolerance. 
    return (distsqr < pow(theTolerance,2)); 
  }
  return false;
}

//make all dimensions not selected
void deselect(){
  for(HashMap.Entry<Integer, dimension> entry : dimensionMap.entrySet()){
    dimension d = entry.getValue();
    d.selected = false;
  }
  
}

boolean overCircle(float x, float y, float diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

void gradientForDimensionSelected(int dimensionSelected, float yLineMinPosition){
  
  float barLength  = yLineMaxPosition - yLineMinPosition;
  float maxMinusMinForThisDimension = 0;
  float itemValueForThisDimension = 0;
  float thisXPosition = startPointX;
  float lastXPosition = 0;
   float scaledYPosition;
  float lastYPosition = 0;
  float gradientState = 0;
  

  for(TableRow row: table.rows()){
   dimension lookAtMe = dimensionMap.get(dimensionSelected);
   float currentValue = row.getFloat(lookAtMe.name);
   float gradientInterval = (lookAtMe.maxVal - lookAtMe.minVal)/3;
   float selectedMin = lookAtMe.minVal;
   if(currentValue < selectedMin + gradientInterval){
     gradientState = 1;
   }
   else if(currentValue < selectedMin + 2*gradientInterval){
     gradientState = 2;
   }
   else{
     gradientState = 3;
   }
   
   stroke(0);
   strokeWeight(1);
   
   float z = increment*(dimensionSelected-1);
   //FOR ALL LINES TO THE RIGHT OF THE DIMENSION
       for(int dimNumber = dimensionSelected; dimNumber <= numOfDimensions; dimNumber++){
         String toolkit = "";
         dimension thisOne = dimensionMap.get(dimNumber);
         maxMinusMinForThisDimension = thisOne.maxVal - thisOne.minVal;
         itemValueForThisDimension = row.getFloat(thisOne.name);
         if(thisOne.flipped){
            scaledYPosition = yLineMinPosition + (barLength*(itemValueForThisDimension - thisOne.minVal)/maxMinusMinForThisDimension);
         }
         else{
            scaledYPosition = endPointY - (barLength*(itemValueForThisDimension - thisOne.minVal)/maxMinusMinForThisDimension);
         }
        
         thisXPosition = startPointX + z;
         if(dimNumber == dimensionSelected){
           lastXPosition = thisXPosition;
           lastYPosition = scaledYPosition;
         }
         
     
         else {//draw the line
           p1 = new PVector(thisXPosition, scaledYPosition);
           p2 = new PVector(lastXPosition, lastYPosition);
         
         if(gradientState == 1){
           
            stroke(128,0,0);
             }
           else if(gradientState == 2){
           stroke(204, 0,0);
           }
           else if(gradientState == 3){
            stroke(255,105,97);
           }
         
           
             if(pointInsideLine(mouse, p1, p2, 2)){
         
             stroke(0,255,0);
             strokeWeight(2);
             
             dimension first = dimensionMap.get(1);
              toolkit = first.name + ": " + row.getFloat(first.name) ;
              for(int i = 2; i <= numOfDimensions; i++){
                 dimension add = dimensionMap.get(i);
                 toolkit +=  ", " + add.name + ": " + row.getFloat(add.name);
              }
           
            
               if(!text){//don't overlay text
               textSize(((height + width)/2) * .014);
               fill(0,0,200);
                  text(toolkit, width * .05, height * .03);
                  text = true;
                  fill(0);
               }
               else{
                // fill(255);
                // stroke(255);
                // rect(width * .01, height * .01, 100, 10);
                // stroke(0);
               }
           } 
           
           line(lastXPosition, lastYPosition, thisXPosition, scaledYPosition);
        
           lastXPosition = thisXPosition;
           lastYPosition = scaledYPosition;
     
           //print("line");
         } 
         z +=increment;
       }
        
        float q = increment*(dimensionSelected-1);
        //FOR ALL LINES TO THE LEFT OF THE DIMENSION
       for(int dimNumber = dimensionSelected; dimNumber > 0; dimNumber--){
         String toolkit = "";
         dimension thisOne = dimensionMap.get(dimNumber);
         maxMinusMinForThisDimension = thisOne.maxVal - thisOne.minVal;
         itemValueForThisDimension = row.getFloat(thisOne.name);
         if(thisOne.flipped){
            scaledYPosition = yLineMinPosition + (barLength*(itemValueForThisDimension - thisOne.minVal)/maxMinusMinForThisDimension);
         }
         else{
            scaledYPosition = endPointY - (barLength*(itemValueForThisDimension - thisOne.minVal)/maxMinusMinForThisDimension);
         }
        
         thisXPosition = startPointX + q;
         if(dimNumber == dimensionSelected){
           lastXPosition = thisXPosition;
           lastYPosition = scaledYPosition;
         }
         
     
         else {//draw the line
           p1 = new PVector(thisXPosition, scaledYPosition);
           p2 = new PVector(lastXPosition, lastYPosition);
           
         if(gradientState == 1){
           
            stroke(128,0,0);
             }
           else if(gradientState == 2){
           stroke(204, 0,0);
           }
           else if(gradientState == 3){
            stroke(255,105,97);
           }
         
         if(pointInsideLine(mouse, p1, p2, 2)){
         
             stroke(0,255,0);
             strokeWeight(2);
             
             dimension first = dimensionMap.get(1);
              toolkit = first.name + ": " + row.getFloat(first.name) ;
              for(int i = 2; i <= numOfDimensions; i++){
                 dimension add = dimensionMap.get(i);
                 toolkit +=  ", " + add.name + ": " + row.getFloat(add.name);
              }
           
            
               if(!text){//don't overlay text
               textSize(((height + width)/2) * .014);
               fill(0,0,200);
                  text(toolkit, width * .05, height * .03);
                  text = true;
                  fill(0);
               }
               else{
                // fill(255);
                // stroke(255);
                // rect(width * .01, height * .01, 100, 10);
                // stroke(0);
               }
           } 
           
           line(lastXPosition, lastYPosition, thisXPosition, scaledYPosition);
        
           lastXPosition = thisXPosition;
           lastYPosition = scaledYPosition;
     
           //print("line");
         } 
         q -=increment;
       }
  }
  
}

void gradientForBoundaryBox(int dimensionSelected, float yLineMinPosition, float bbMin, float bbMax){
  
  float barLength  = yLineMaxPosition - yLineMinPosition;
  float maxMinusMinForThisDimension = 0;
  float itemValueForThisDimension = 0;
  float thisXPosition = startPointX;
  float lastXPosition = 0;
   float scaledYPosition;
  float lastYPosition = 0;
  float gradientState = 0;
  

  for(TableRow row: table.rows()){
   dimension lookAtMe = dimensionMap.get(dimensionSelected);
   float currentValue = row.getFloat(lookAtMe.name);
   float gradientInterval = (lookAtMe.maxVal - lookAtMe.minVal)/3;
   float selectedMin = lookAtMe.minVal;
   if(currentValue < bbMin || currentValue > bbMax){
     gradientState = 10;
   }
   else if(currentValue >=bbMin && currentValue <= bbMax){
       if(currentValue < selectedMin + gradientInterval){
         gradientState = 1;
       }
     else if(currentValue < selectedMin + 2*gradientInterval){
       gradientState = 2;
     }
     else{
       gradientState = 3;
     }
   }
     

   
   stroke(0);
   strokeWeight(1);
   
   float z = increment*(dimensionSelected-1);
   //FOR ALL LINES TO THE RIGHT OF THE DIMENSION
       for(int dimNumber = dimensionSelected; dimNumber <= numOfDimensions; dimNumber++){
         String toolkit = "";
         dimension thisOne = dimensionMap.get(dimNumber);
         maxMinusMinForThisDimension = thisOne.maxVal - thisOne.minVal;
         itemValueForThisDimension = row.getFloat(thisOne.name);
         if(thisOne.flipped){
            scaledYPosition = yLineMinPosition + (barLength*(itemValueForThisDimension - thisOne.minVal)/maxMinusMinForThisDimension);
         }
         else{
            scaledYPosition = endPointY - (barLength*(itemValueForThisDimension - thisOne.minVal)/maxMinusMinForThisDimension);
         }
        
         thisXPosition = startPointX + z;
         if(dimNumber == dimensionSelected){
           lastXPosition = thisXPosition;
           lastYPosition = scaledYPosition;
         }
         
     
         else {//draw the line
           p1 = new PVector(thisXPosition, scaledYPosition);
           p2 = new PVector(lastXPosition, lastYPosition);
         
        if(gradientState == 10){
           stroke(155,155,155);
         }
           if(gradientState == 1){
           
            stroke(128,0,0);
             }
           else if(gradientState == 2){
           stroke(204, 0,0);
           }
           else if(gradientState == 3){
            stroke(255,105,97);
           }
         
           
             if(pointInsideLine(mouse, p1, p2, 2)){
         
             stroke(0,255,0);
             strokeWeight(2);
             
             dimension first = dimensionMap.get(1);
              toolkit = first.name + ": " + row.getFloat(first.name) ;
              for(int i = 2; i <= numOfDimensions; i++){
                 dimension add = dimensionMap.get(i);
                 toolkit +=  ", " + add.name + ": " + row.getFloat(add.name);
              }
           
            
               if(!text){//don't overlay text
               textSize(((height + width)/2) * .014);
               fill(0,0,200);
                  text(toolkit, width * .05, height * .03);
                  text = true;
                  fill(0);
               }
               else{
                // fill(255);
                // stroke(255);
                // rect(width * .01, height * .01, 100, 10);
                // stroke(0);
               }
           } 
           line(lastXPosition, lastYPosition, thisXPosition, scaledYPosition);
        
           lastXPosition = thisXPosition;
           lastYPosition = scaledYPosition;
     
           //print("line");
         } 
         z +=increment;
       }
        
        float q = increment*(dimensionSelected-1);
        //FOR ALL LINES TO THE LEFT OF THE DIMENSION
       for(int dimNumber = dimensionSelected; dimNumber > 0; dimNumber--){
         String toolkit = "";
         dimension thisOne = dimensionMap.get(dimNumber);
         maxMinusMinForThisDimension = thisOne.maxVal - thisOne.minVal;
         itemValueForThisDimension = row.getFloat(thisOne.name);
         if(thisOne.flipped){
            scaledYPosition = yLineMinPosition + (barLength*(itemValueForThisDimension - thisOne.minVal)/maxMinusMinForThisDimension);
         }
         else{
            scaledYPosition = endPointY - (barLength*(itemValueForThisDimension - thisOne.minVal)/maxMinusMinForThisDimension);
         }
        
         thisXPosition = startPointX + q;
         if(dimNumber == dimensionSelected){
           lastXPosition = thisXPosition;
           lastYPosition = scaledYPosition;
         }
         
     
         else {//draw the line
           p1 = new PVector(thisXPosition, scaledYPosition);
           p2 = new PVector(lastXPosition, lastYPosition);
           
         if(gradientState == 10){
           stroke(155,155,155);
         }
           if(gradientState == 1){
           
            stroke(128,0,0);
             }
           else if(gradientState == 2){
           stroke(204, 0,0);
           }
           else if(gradientState == 3){
            stroke(255,105,97);
           }
         
         if(pointInsideLine(mouse, p1, p2, 2)){
         
             stroke(0,255,0);
             strokeWeight(2);
             
             dimension first = dimensionMap.get(1);
              toolkit = first.name + ": " + row.getFloat(first.name) ;
              for(int i = 2; i <= numOfDimensions; i++){
                 dimension add = dimensionMap.get(i);
                 toolkit +=  ", " + add.name + ": " + row.getFloat(add.name);
              }
           
            
               if(!text){//don't overlay text
               textSize(((height + width)/2) * .014);
               fill(0,0,200);
                  text(toolkit, width * .05, height * .03);
                  text = true;
                  fill(0);
               }
               else{
                // fill(255);
                // stroke(255);
                // rect(width * .01, height * .01, 100, 10);
                // stroke(0);
               }
           } 
           
           line(lastXPosition, lastYPosition, thisXPosition, scaledYPosition);
        
           lastXPosition = thisXPosition;
           lastYPosition = scaledYPosition;
     
           //print("line");
         } 
         q -=increment;
       }
  }
  
}

void mousePressed() {
   a=mouseX;
    b=mouseY;
  
 
}


void mouseDragged() {
  //c=mouseX-a;
  d=mouseY-b;
  rect(a, b, c, d);
  lastHeight = height;
  lastWidth = width;
 
}

boolean boundBoxNearDimension(PVector pa, PVector pb){
  if(pointInsideLine(boundaryBox, pa, pb, 40)){
    return true;
  }
 
  else return false;
  
}

void mouseClicked() {
  //if user clicks the button
  if (mouseX >= button_x 
  && mouseX <= button_x + button_w
  && mouseY >= button_y
  && mouseY <= button_y + button_h) {
  deselect();
  }
} 