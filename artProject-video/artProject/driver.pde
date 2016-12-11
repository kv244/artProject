/**
 * Driver
 */
 
import java.util.*; 
 
public class driver{
  private int screenX, screenY;
  private int noImagesX = 0, noImagesY = 0;
  private int imgSizeX = 0, imgSizeY = 0;
  private List<imageContainer> images = null;
  private String[] imageNames = {};
  private String[] videoNames = {};
  private HashMap<String, PImage> imageBinaries = null;
  private String[] texts = {};
  private processContents[] actions = {
    processContents.SHAKE, 
    processContents.FX,
    processContents.KEEPTV, 
    processContents.KEEPIMAGE,
    processContents.SCROLLTEXT,
    processContents.NEWIMAGE,
    processContents.DRAW
    , processContents.VIDEO
  };
  private boolean noSquare = false;
  private boolean noCircle = false;
  private PApplet parent;

  public driver(int x, int y, PApplet p){
     this.screenX = x;
     this.screenY = y;
     this.parent = p;
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
    if(images == null){
      println("No images");
      return;
    }
    for(imageContainer i:images){
      System.out.println("driver next " + i.toString());
      if(i.canChangeAction()) { 
        action = (int)Math.floor(Math.random() * actions.length);
        
        if(actions[action] == processContents.NEWIMAGE){
          n = (int)Math.floor(Math.random() * imageNames.length); 
          i.setImageName(this.imageNames[n]);
        }
        
        if(actions[action] == processContents.VIDEO){
          n = (int)Math.floor(Math.random() * videoNames.length);
          System.out.println("set movie name...");
          if(n >= this.videoNames.length)
           println(n + " too big"); 
          else
            i.setMovie(this.videoNames[n]);
        }
        
        if(actions[action] == processContents.SCROLLTEXT){
          n = (int)Math.floor(Math.random() * texts.length);
          i.setText(texts[n]);
        }
        System.out.println("set action...");
        i.setAction(actions[action]);
      }
      System.out.println("process contents...");
      i.processContents();
    }
  }
  
  public void setImageNames(String[] s){
    imageNames = s;
    initializeImages();
  }
  
  public void setVideoNames(String[] s){
    videoNames = s;
    /* TODO similar initialize()? */
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
    
    int xPos = 0; 
    int yPos = 0;
    int xCount = 0; 
    int yCount = 0;
    
    if(yCount == 0) yCount = 0;  
   
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
        xPos = 0; 
        xCount = 0;
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
    if(images==null){
      println("showImages -- no images");
      return;
    }
     for(imageContainer i:images)
       i.renderImage();
  }
  
  public List<Movie> getMovies(){
    List<Movie> retMovies = new ArrayList<Movie>();
    Movie m = null;
    
    for(imageContainer i:images){
      if((m = i.getMovie()) != null)
        retMovies.add(m);
    }
    return retMovies;
  }
}