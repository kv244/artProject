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
  }
  
  public void setImageName(String s){ 
    this.imageName = s;
    this.contents = contentsType.AIMAGE; 
  }
  
  public void setXY(int x, int y){ xPos = x; yPos = y; oldXPos = xPos; oldYPos = yPos; } 
  
  public boolean canChangeAction(){
    return (this.actionAge >= this.maxActionAge);
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
  
  /**
   * this randomly tints image (photo only)
   */
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

  /**
   * the actual image rendering
   */
  public void renderImage(){
    switch(this.contents){
      case AIMAGE: 
        this.paintImage();
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
      case AMELT:
        this.startMelt();
        break;
    }
    //if(this.tintFx == true)noTint();
  }
  
  private void paintImage(){
    if(this.imageName == null){
      System.out.println("\tNo image name for " + this.toString());
      return;
    }
    if(this.img == null){ 
      System.out.println("\tNo image file for " + this.imageName + " " + this.toString());
      return;
    }
    image(this.img, xPos, yPos, this.xSize, this.ySize);
  }
  
  /**
   * processContents
   * processes image and also modify the age, 
   * decides which effects are canceled
   */
  public void processContents(){
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
      this.openImage(); //?
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
      case MELT:
        this.initPos();
        this.contents = contentsType.AMELT;
        break;
    }
  }
  
 /** 
  * the "melt" processor
  */
 private void startMelt(){
   int xx, yy;
   color cc;
   float r;
   for(xx = xPos; xx < xPos + xSize; xx++)
     for(yy = yPos; yy < yPos + ySize; yy++){
       cc = get(xx, yy);
       r = random(10);
       if(r<2)
        set(xx, yy, cc+1);
      else if(r<4)
        set(xx, yy, cc-1);
      else if(r<6)
        set(xx, yy, xx<xPos-1?get(xx+1, yy):0); 
      else if(r<8)
        set(xx, yy, yy<yPos-1?get(xx, yy+1):0);
      else if(r<9)
        set(xx, yy, xx>0?get(xx-1, yy):0);
      else
        set(xx,yy,yy>0?get(xx,yy-1):0);
     }
 }
 
 private void erase(){
   // erase the previous image (black)
   noStroke();
   fill(0);
   rect(xPos, yPos, xSize, ySize); 
   noFill();
 }
 
 /**
  * this draws a pixellated random "TV" effect
  */
 public void drawTv(){
   erase(); 
   for(int x = this.xPos; x < this.xPos + this.xSize; x++){
      for(int y = this.yPos; y < this.yPos + this.ySize; y++){
          set(x, y, 
            color((int)(random(255)), 
              (int)(random(255)), 
              (int)(random(255))
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
     erase();
     textSize(16); /*TODO this should be function of windows size and length of text */
     fill(random(255), random(255), random(255));
     text(this.text, this.xPos, this.yPos, this.xSize, this.ySize);
     noFill();
 }
 
 private void setDraw(){
   erase();
   this.contents = contentsType.ADRAW;
 }
 
 /**
  * this draws a random shape
  * line, circle, or ellpise (if allowed)
  */
 public void randomDraw(){
   stroke((int)random(255));
   int x1 = (int)random(xSize);
   int x2 = (int)random(xSize);
   int y1 = (int)random(ySize);
   int y2 = (int)random(ySize);

   double choose = Math.random();

   if(choose < 0.5){ //line
     if(Math.random() > 0.7) stroke(0,255,0);
     line(this.xPos + x1, this.yPos + y1, this.xPos + x2, this.yPos + y2);
   } // square
   else if(this.drv.getNoSquare() == false && choose < 0.7) {
     
     if(random(1) > 0.5)
       fill(random(255));
     else
       fill(random(255), random(255), random(255));
     if(this.xPos + x1 + x2 > this.xPos + this.xSize)
       x2 = this.xSize - x1;
     if(this.yPos + y1 + y2 > this.yPos + this.ySize)
       y2 = this.ySize - y1;
       
     rect(this.xPos + x1, this.yPos + y1, x2, y2);
   }
   else{ // ellipse
    if(this.drv.getNoCircle() == true) return;
    
    if(random(1) > 0.5)
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
}