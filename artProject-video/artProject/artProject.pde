/**
 *   Assigned to images from above, otherwise text or paint
 *   If image is being modified, copy and append to array
 *   fix image not loaded
 *   figure out cumulative fixes, and ages
 *   add scrolling text
 *   decide if current text is ok or if there should be specialized window below
 *   add melting and other effects
 *   get images and texts from web services based on tags in ini file
 * TODO add video
 *   The way this is now, movies doesnt work - I need to clarify the library and to see
 *   The Syphon send does not work
 */

import processing.video.*;
import java.io.*;
import codeanticode.syphon.*;

SyphonServer server;

driver d;
String[] imageNames;
String[] videoNames;
ArrayList<String> texts;
String file = "art.ini";
int rows, cols;
boolean noCircle = false;
boolean noSquare = false;
//Movie myMovie;

void setup(){
  try{
    String current = new java.io.File( "." ).getCanonicalPath();
    System.out.println("Using directory: " + current);
  }catch(Exception x){ 
    System.out.println("Error reading directory: " + x.toString()); 
    return;
  }
  int sizeX = 1000;
  int sizeY = 600;
  size(1000, 600, P3D);
  PJOGL.profile = 1;
  server = new SyphonServer(this, "processingImages");
  background(255, 255, 255);
  
  d = new driver(sizeX, sizeY, this);
  
  texts = new ArrayList<String>();
  parseIniFile();
  imageNames = buildImageList(".jpg"); // animated gifs not supported
  videoNames = buildImageList(".mov");
 
  if(noCircle)d.setNoCircle();
  if(noSquare)d.setNoSquare();
  
  if(imageNames.length > cols * rows){
    System.out.println("Too few cells to accomodate all images.");
    return;
  } 
  
  d.setImageNames(imageNames);
  d.setVideoNames(videoNames);
  d.setTexts(texts);
  d.initialize(cols, rows);
  //myMovie = new Movie(this, "img.mov");
  //myMovie.noLoop(); /* loop works here too *1* */
}

String[] buildImageList(final String extension) {
  /* .jpg, .mov */
  String[] ret;
  FilenameFilter imageList = new FilenameFilter() {
      public boolean accept(File dir, String name) {
        if (name.toLowerCase().endsWith(extension)) {
          return true;
        } else {
          return false;
        }
      }
    }; 
  
  File imageFiles = new File(".");
  ret = imageFiles.list(imageList);
  if(ret.length == 0){
    System.out.println("No " + extension +" files in current directory");
  }else{
    System.out.println("Images of type:" + extension);
    System.out.println(ret.length);
  }
  return ret;
}

void parseIniFile(){
  /* reads size, image names and text from file
     Format:
        cols 10
        rows 5
        text
        text 
        nocircle
        nosquare
  */
         
  try{
      BufferedReader br = new BufferedReader(new FileReader(file));
      String line;
  
      while ((line = br.readLine()) != null) {
        System.out.println("Read: " + line);
        if(line.startsWith("cols ")){
          cols = Integer.parseInt(line.substring(line.indexOf(" ") + 1));
        }else
        if(line.startsWith("rows ")){
          rows = Integer.parseInt(line.substring(line.indexOf(" ") + 1));
        }else
        if(line.startsWith("nocircle")){
          noCircle = true;
        }else
        if(line.startsWith("nosquare")){
          noSquare = true;
        }
        else
          texts.add(line);   
      }
      br.close();
    }catch(Exception x){
      System.out.println("Error reading ini file: " + x.toString());
  }
}

void draw(){
 // if(myMovie.available())myMovie.read();
  
 d.next();
 d.showImages(); 
 try{
   server.sendScreen();
   println("Syphon clients: " + server.hasClients());
 }catch(Exception x){
   println("Error ");
   println(x.getMessage());
 }
 /*
 List<Movie> pMovies = d.getMovies();
 if(pMovies != null){
   for(Movie m:pMovies){
     if(m.available()) m.read();
     m.play();
     image(m, 0, 0, 200, 200);
   }
 } */
 // myMovie.play(); this works, or *1*
 //image(myMovie, 0, 0, 100, 100);
}
 