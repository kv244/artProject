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
  private String movieFile = null;
  private Movie movie = null;
  private contentsType contents;
  private processContents action;
  private int actionAge;
  private int maxActionAge;
  private boolean tintFx; 
  private driver drv;
   
  public imageContainer(int i, driver d){
    this.me = i;
    this.drv = d;
    this.actionAge = 0;
    this.maxActionAge = (int)(Math.random() * 10);
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
  
  public void setMovie(String s){
    System.out.println("in set movie " + this.toString());
    this.movieFile = s;
    this.contents = contentsType.AVIDEO;
    try{
      if(this.movieFile == null) 
        throw new Exception("Movie file is null for " + this.toString());

      System.out.println("ctor+ set movie " + this.toString());
      this.movie = new Movie(d.parent, this.movieFile);
      System.out.println("ctor+1 set movie " + this.toString());
       
      if(this.movie!=null){
        //this.movie.loop(); this one is causing the blocks
      }else{ 
        throw new Exception("Movie not found: " + this.movieFile); 
     }
    }catch(Exception x){
       System.out.println("video CASE error " + x.toString());
       this.movie = null;
    }
    System.out.println("ctorX set movie " + this.toString());
  }
  
  public void setXY(int x, int y){ xPos = x; yPos = y; oldXPos = xPos; oldYPos = yPos; } 
  
  public boolean canChangeAction(){
    System.out.println(this.toString() + " current action " + this.action.toString());
    System.out.println(this.actionAge >= this.maxActionAge);
    return (this.actionAge >= this.maxActionAge);
  }
  
  public void stopVideo(){
    if(this.movie!=null){
      this.movie.stop();
      this.movie = null;
    }
  }
  
  public void setAction(processContents a){
    System.out.println(this.toString() + " set action to "  + a.toString());
    // only triggered after age has reached max
    // also sets the max age per action type
    this.action = a;
    this.actionAge = 0;
    if(a == processContents.NEWIMAGE)
      this.maxActionAge = (int)(Math.random() * 10);
    else
    if(a == processContents.KEEPIMAGE){}
      //this.maxActionAge = (int)(Math.random() * 100); // nothing here
    if(a == processContents.VIDEO){
      //if(this.movie.time() < this.movie.duration())
      //this.maxActionAge = actionAge + 1;
    }
     else
       this.maxActionAge = (int)(Math.random() * 20); // favor images
  } 
  
  public void randomEffect(){
    if(this.contents != contentsType.AIMAGE) return;
    this.tintFx = true;
    tint(random(255), random(255), random(255));
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
    
public Movie getMovie(){
  return this.movie; 
}

public void processContents(){
    System.out.println(this.toString() + " entering process contents " + this.action.toString());
    /* this should process image and also modify the age, 
       decide which effects are canceled
       TODO this is where you can combine effects */
    this.actionAge++;
    switch(this.action){
      case DRAW: 
        this.setTv(false);
        this.stopVideo();
        this.setDraw();
        break;
      case NEWIMAGE:
        this.cancelEffect();
        this.stopVideo();
        this.initPos();
        this.setTv(false);
        this.setText(null);
        this.openImage();
        break;
      case FX:
        this.randomEffect();
        this.stopVideo();
        break;
      case SHAKE:
        //this.actionAge = 0; // should this be here?
        //this.maxActionAge = 10;
        this.imageShake();
        this.stopVideo();
        break;
      case KEEPIMAGE:
        this.stopVideo(); // TODO this really should only follow NEW IMAGE so this doesnt make sense here
        break;
      case SCROLLTEXT:
        this.initPos();
        this.stopVideo();
        this.setTv(false);
        break;
      case KEEPTV:
        this.initPos();
        this.stopVideo();
        this.setText(null);
        this.setTv(true);
        break;
      case VIDEO:
        if(this.movie != null){
          if(this.movie.available()) 
            this.movie.read();
          }
        //this.movie.play();
        break;
    }
  }
 
 /* TODO decide if this should be here 
    or where the name is set */
 private void videoAction(){
   if(this.movie==null){
     System.out.println("videoAction null movie for " + this.toString());
     return;
   }
  System.out.println("render video " + this.toString());
  this.movie.play();
  System.out.println("render+ video " + this.toString());
  image(this.movie, this.xPos, this.yPos, this.xSize, this.ySize);
  System.out.println("render+1 video " + this.toString());
  /*
  if(this.movie.time() < this.movie.duration()){
    this.maxActionAge = actionAge + 1;
    System.out.println("Movie still running" + this.toString());
  }
  else{
    this.maxActionAge = actionAge - 1;
    System.out.println("Movie age expired " + this.toString());
  } */
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
   
   // TODO change so that it always draws a line and only random if circle or square 
   
   if(choose < 0.5)
     line(this.xPos + x1, this.yPos + y1, this.xPos + x2, this.yPos + y2);
   else if(this.drv.getNoSquare() == false && choose < 0.7){
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
      this.img = this.drv.getImage(this.imageName);
      this.contents = contentsType.AIMAGE;
      if(this.img == null){
        System.out.println("openImage has null " + this.imageName + " " + this.toString());
      }
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
        if((this.imageName != null) && (this.img != null)){
         image(this.img, this.xPos, this.yPos, this.xSize, this.ySize);
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
        if(this.movie != null){
          videoAction();
        }else{
          System.out.println("No movie file for " + this.movieFile);
        }
        break;
    }
    if(this.tintFx == true)noTint();
  }
}