/** 
 * imageContainer
 */
 
class imageContainer implements responder {
  
  private int xSize, oldXSize;
  private int ySize, oldYSize;
  private String imageName = null;
  private int me;
  private int xPos, yPos, oldXPos, oldYPos;
  private PImage img = null;
  private String text = null;
  private contentsType contents;
  private processContents action;
  private driver drv;
  private int actionAge;
  private int maxActionAge;
  private boolean tintFx; 
   
  // constructor, using ref to parent driver in case movie has to be added 
  public imageContainer(int i, driver d){
    this.me = i;
    this.drv = d;
    this.actionAge = 0;
    this.maxActionAge = (int)(Math.random() * 30);
    this.action = processContents.NEWIMAGE; /* TODO check with initialization and switch() */
  }
  
  public void setSize(int x, int y){ 
    this.xSize = x; this.oldXSize = x;
    this.ySize = y; this.oldYSize = y;
    //this.pg = createGraphics(xSize, ySize);
  }
  
  public void setImageName(String s){ 
    this.imageName = s;
    this.contents = contentsType.AIMAGE; 
  }
  
  public void setXY(int x, int y){ xPos = x; yPos = y; oldXPos = xPos; oldYPos = yPos; } 
  
  public boolean canChangeAction(){
    return ( this.actionAge >= this.maxActionAge );
  }
  
  public void setAction(processContents a){
    // only triggered after age has reached max
    // also sets the max age per action type
    this.action = a;
    this.actionAge = 0;
    
    if(a == processContents.NEWIMAGE)
      this.maxActionAge = (int)(Math.random() * 70);
    else
    if(a == processContents.KEEPIMAGE){}
      //this.maxActionAge = (int)(Math.random() * 100); // nothing here
     else
       this.maxActionAge = (int)(Math.random() * 50); // favor images
  } 
  
  public void randomEffect(){
    if(this.contents != contentsType.AIMAGE) return;
    this.tintFx = true;
    tint(random(255), random(255), random(255), random(128));
  }
  
  public void cancelEffect(){
    noTint();
    this.tintFx = false;
  }

  public void imageShake() {
    if(this.contents != contentsType.AIMAGE) return;
    
    int xShift = (int)(Math.random() * 5);
    int yShift = (int)(Math.random() * 5);
    this.xPos += xShift; this.xSize -= xShift;
    this.yPos += yShift; this.ySize -= yShift;
  }
  
  private void initPos(){
    this.xPos = this.oldXPos;
    this.yPos = this.oldYPos;
    this.xSize = this.oldXSize;
    this.ySize = this.oldYSize;
  }

  public void processContents(){
    /* this should process image and also modify the age, 
       decide which effects are canceled */
    this.actionAge++;
    switch(this.action){
      case DRAW: 
        this.setTv(false);
        this.setDraw();
        break;
      case NEWIMAGE:
        this.cancelEffect();
        this.initPos();
        this.setTv(false);
        this.setText(null);
        this.openImage();
        break;
      case FX:
        this.randomEffect();
        break;
      case SHAKE:
        //this.actionAge = 0; // should this be here?
        //this.maxActionAge = 10;
        this.imageShake();
        break;
      case KEEPIMAGE:
        break;
      case SCROLLTEXT:
        // all it does is turn off the pixels and reset the position
        this.initPos();
        this.setTv(false);
        break;
      case KEEPTV:
        this.initPos();
        this.setText(null);
        this.setTv(true);
        break;
    }
  }
  
 private void erase(){
   // erase the previous image
   noStroke();
   fill(0);
   rect(xPos, yPos, xSize, ySize); 
 }
 
 public void drawTv(){
   erase(); 
   for(int x = this.xPos; x < this.xPos + this.xSize; x++){
      for(int y = this.yPos; y < this.yPos + this.ySize; y++){
          set(x, y, 
            color((int)(Math.random() * 255), 
              (int)(Math.random() * 255), 
              (int)(Math.random() * 255)
            )); 
      }
    }
  }
  
  public contentsType getContents() {
    return this.contents;
  }
 
  public void setTv(boolean tv){
    this.contents = (tv == true) ? contentsType.ATV : getContents();
  }
  
 public void setText(String t){
    this.contents = contentsType.ATEXT;
    this.text = t;
 }

 /**
  * this writes the assigned text to the window
  */
 public void write(){
     if(this.text == null) return; /* TODO should not be null! */
     int col = (int)(Math.random() * 255);
     boolean f1 = true, f2 = true, f3 = true;
     textSize(16); /*TODO this should be function of windows size and length of text */
     fill(f1 == true ? col : 0, f2 == true ? col : 0, f3 == true ? col : 0);
     noStroke();
     rect(this.xPos, this.yPos, this.xSize, this.ySize);
     fill(255-col, 255-col, 255-col);
     text(this.text, this.xPos, this.yPos, this.xSize, this.ySize);
     noFill();
 }
 
 private void setDraw(){
   erase();
   this.contents = contentsType.ADRAW;
 }
 
 public void randomDraw(){
   stroke((int)random(255));
   int x1 = (int)random(xSize);
   int x2 = (int)random(xSize);
   int y1 = (int)random(ySize);
   int y2 = (int)random(ySize);

   double choose = Math.random();

   if(choose < 0.5){
     if(Math.random() > 0.7) stroke(0,255,0);
     line(this.xPos + x1, this.yPos + y1, this.xPos + x2, this.yPos + y2);
   }
   else if(this.drv.getNoSquare() == false && choose < 0.7) {
     if(Math.random() > 0.5)
       fill(random(255));
     else
       fill(random(255), random(255), random(255));
     if(this.xPos + x1 + x2 > this.xPos + this.xSize)
       x2 = this.xSize - x1;
     if(this.yPos + y1 + y2 > this.yPos + this.ySize)
       y2 = this.ySize - y1;
     rect(this.xPos + x1, this.yPos + y1, x2, y2);
   }
   else{
    if(this.drv.getNoCircle() == true) return; 
    if(Math.random() > 0.5)
       fill(random(255));
     else
       fill(random(255), random(255), random(255));
     ellipseMode(CORNER);
     if(this.xPos + x1 + x2 > this.xPos + this.xSize)
       x2 = this.xSize - x1;
     if(this.yPos + y1 + y2 > this.yPos + this.ySize)
       y2 = this.ySize - y1;
     ellipse(this.xPos + x1, this.yPos + y1, x2, y2);   
   }
   noStroke();
   noFill();
 }
 
 public void openImage(){
    if(this.imageName != null) try{
      img = this.drv.getImage(this.imageName);
      this.contents = contentsType.AIMAGE;
    } catch(Exception x){
      System.out.println("openImage error: " + this.toString() + " " +  x.toString());
    }else{
      System.out.println("No image name for: " + this.toString() + " " + this.toString());
    }
  }
  
  public String toString(){
    return Integer.toString(me);
  }
  
  public void renderImage(){
    /* Needs to receive where to show itself on the main screen
    depending on sizes
    */
   
    switch(this.contents){
      case AIMAGE:
        if(this.imageName != null && this.img != null){
         image(this.img, xPos, yPos, this.xSize, this.ySize);
         }else{
           System.out.println("No image loaded by: " + this.toString()); 
           if(this.imageName == null)
             System.out.println("\tNo image name");
           else 
             System.out.println("\tNo image file for " + this.imageName);
         }
        break;
      case ADRAW:
        this.randomDraw();
        break;
      case ATEXT: 
       this.write();
       break;
      case ATV:
        this.drawTv();
        break;
      case AVIDEO:
        break;
    }
    if(this.tintFx == true)noTint();
  }
}