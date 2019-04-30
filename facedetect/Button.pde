
class Button 
{
 
int rectX, rectY;      // Position of square button
//int circleX, circleY;  // Position of circle button
int rectSize = 90;     // Diameter of rect
//int circleSize = 93;   // Diameter of circle
color rectColor, baseColor;
color rectHighlight;
color currentColor;
boolean rectOver = false;
String text;
//boolean circleOver = false;

int id;

Button(int X, int Y, int ID, String txt)
{
  rectColor = color(0);
  rectHighlight = color(51);
  baseColor = color(102);
  currentColor = baseColor;
  rectX = X;
  rectY = Y;
  id = ID;
  text = txt;
  //ellipseMode(CENTER);
}


void drawButton() {
  update(mouseX, mouseY);
  //background(currentColor);
  
  if (rectOver) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(rectX, rectY, rectSize, rectSize);
  
  fill(255);
  textSize(20);
  text(text,rectX+40,rectY+50);
  
  
}
void update(int x, int y) {
  if ( overRect(rectX, rectY, rectSize, rectSize) ) {
    rectOver = true;
  } else {
    rectOver = false;
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

}
