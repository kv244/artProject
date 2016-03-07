/**
 * Driver
 */
 
import java.util.*; 
 
public class driver{
  private int screenX, screenY, offset;
  private int noImagesX = 0, noImagesY = 0;
  private int imgSizeX = 0, imgSizeY = 0;
  private List<imageContainer> images = null;
  private String[] imageNames = {};
  private HashMap<String, PImage> imageBinaries = null;
  private String[] texts = {};
  private int currentLine = 0, offsetLine = 0;
  private boolean noSquare = false;
  private boolean noCircle = false;
  
  private processContents[] actions = {
    processContents.SHAKE, 
    processContents.FX,
    processContents.KEEPTV, 
    processContents.KEEPIMAGE,
    processContents.SCROLLTEXT,
    processContents.NEWIMAGE,
    processContents.DRAW,
    processContents.NEWIMAGE // favor new images
  };
  
  public driver(int x, int y, int offset){
     this.screenX = x;
     this.screenY = y;
     this.offset = offset;
  }
  
  public void setNoSquare(){
    this.noSquare = true;
  };
  
  public void setNoCircle(){
    this.noCircle = true;
  }
  
  public boolean getNoCircle(){ return this.noCircle; }
  public boolean getNoSquare(){ return this.noSquare; }
  
  private void initializeImages(){
    /* loads images from current directory into image storage */
    if(imageNames.length == 0){
      System.out.println("Initialize images: no image names found.");
      return;
    }
    try{
      imageBinaries = new HashMap<String, PImage>(imageNames.length);
      for(String s:imageNames){
        imageBinaries.put(s, loadImage(s));
        System.out.println("Loaded: " + s);
      }
    }catch(Exception x){
      System.out.println("Initialize images: error " + x.toString());
    }
  }
  
  public void setTexts(ArrayList<String> texts){
    this.texts = new String[texts.size()];
    int n = 0;
    for(String s:texts){
      this.texts[n++] = s;
    }
  }
  
  public void next(){
    int action, n;
    
    for(imageContainer i:images){
      if(i.canChangeAction()) { 
        action = (int)Math.floor(Math.random() * actions.length);
       
        if(actions[action] == processContents.NEWIMAGE){
          n = (int)Math.floor(Math.random() * imageNames.length); 
          i.setImageName(this.imageNames[n]);
        }
        
        if(actions[action] == processContents.SCROLLTEXT){
          n = (int)Math.floor(Math.random() * texts.length);
          i.setText(texts[n]);
        }
        
        i.setAction(actions[action]);
      }
      i.processContents();
    }
  }
  
  public void setImageNames(String[] s){
    imageNames = s;
    initializeImages();
  }
  
  public void scrambleNames(){
    int n;
    for(int i = 0; i < d.getNoImages(); i++){
      n = (int)Math.floor(Math.random() * imageNames.length);
      this.setImageName(i, imageNames[n]);
    }
  }
  
  public int getNoImages(){
    return noImagesX * noImagesY;
  }
  
  public PImage getImage(String s){
    PImage i = this.imageBinaries.get(s);
    if(i == null){
      System.out.println("Driver cannot find image " + s);
    }
    return i;
  }
  
  public void initialize(int noImagesX, int noImagesY){
    /* builds the locations for the imageContainers and their sizes 
       this potentially supports various size cells */
    
    int xPos = 0; int yPos = 0;
    int xCount = 0; int yCount = 0;
    this.noImagesX = noImagesX;
    this.noImagesY = noImagesY; 
    this.imgSizeX = (int)(screenX / noImagesX);
    this.imgSizeY = (int)(screenY / noImagesY);
    
    this.images = new ArrayList<imageContainer>(getNoImages());
    
    for(int i=0; i < getNoImages(); i++){
      imageContainer ic = new imageContainer(i, this);
      ic.setSize(imgSizeX, imgSizeY);
      ic.setXY(xPos, yPos);
      xPos += imgSizeX;
      xCount++;
      
      if(xCount >= noImagesX){
        yCount++;
        xPos = 0; xCount = 0;
        yPos += imgSizeY;
      }
      //ic.setAction(processContents.NEWIMAGE); // trigger loading of images, names set below ?
      images.add(ic);
    }   
    scrambleNames();
  }
  
  public void setImageName(int n, String s){
    if(images.size() > n){
      imageContainer i = images.get(n);
      i.setImageName(s);
    }else{
      System.out.println("setImageName error: can't set image# " + Integer.toString(n));
    }
  }
  
  public void setImageNames(String s){
    for(int i = 0; i < getNoImages(); i++){
      setImageName(i, s);
    }
  }
  
  public void setImageText(int i, String s){
    if(i < images.size()){
      imageContainer ic = images.get(i);
      ic.setText(s);
    }
  }
  
  public void showImages(){
     for(imageContainer i:images)
       i.renderImage();
  }
  
  public void bottom(){
    // draws the bottom of the screen
    // if defined
    if(this.offset == 0)return;
    float textSize = textAscent() + textDescent();
    int noLines = (int)(this.offset / textSize);  /* TODO use? */
    
    stroke(0);
    rect(0, this.screenY, this.screenX, this.offset);
    text(texts[currentLine++], 0, this.screenY + offsetLine, this.screenX, this.offset);
    offsetLine += textSize;
    // System.out.println(currentLine);
    // System.out.println(textAscent() + textDescent());
    if(this.screenY + offsetLine > height){  
      offsetLine = 0;
      fill(0, 0, 128);
      rect(0, this.screenY, this.screenX, this.offset);
      noFill();
    }
    if(currentLine >= texts.length){
      currentLine=0;
      fill(0, 0, 128);
      rect(0, this.screenY, this.screenX, this.offset);
      noFill();
    }else
      noFill();
    noStroke();
  }
}