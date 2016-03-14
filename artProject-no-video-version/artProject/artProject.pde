/**
 * TODO
 * check error fixed image: no, to fix
 */

import java.io.*;

driver d;
String[] imageNames;
ArrayList<String> texts;
String file = "art.ini";
int rows, cols;
boolean noCircle = false;
boolean noSquare = false;

void setup(){
  try{
    String current = new java.io.File( "." ).getCanonicalPath();
    System.out.println("Using directory: " + current);
  }catch(Exception x){ 
    System.out.println("Error reading directory: " + x.toString()); 
    return;
  }
  int sizeX = 1000;
  int sizeY = 500; 
  size(1000, 600);   // 100 for bottom window
  background(255, 255, 255);
  
  d = new driver(sizeX, sizeY, height - sizeY);
  texts = new ArrayList<String>();
  parseIniFile();
  buildImageList();  
   
  if(imageNames.length > cols * rows){
    System.out.println("Too few cells to accomodate all images.");
    return;
  }
  
  if(noCircle)d.setNoCircle();
  if(noSquare)d.setNoSquare();
  
  d.setImageNames(imageNames);
  d.setTexts(texts);
  d.initialize(cols, rows);
}

void buildImageList() {
  FilenameFilter imageList = new FilenameFilter() {
      public boolean accept(File dir, String name) {
        if (name.toLowerCase().endsWith(".jpg")) {
          return true;
        } else {
          return false;
        }
      }
    }; 
  
  File imageFiles = new File(".");
  imageNames = imageFiles.list(imageList);
  if(imageNames.length == 0){
    System.out.println("No *.jpg files in current directory");
  }else{
    System.out.println("Images: " + Integer.toString(imageNames.length));
  }
}

void parseIniFile(){
  /* reads size, image names and text from file
     Format:
        cols 10
        rows 5
        nocircle
        nosquare
        text
        text
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
        }else
          texts.add(line);   
      }
      br.close();
    }catch(Exception x){
      System.out.println("Error reading ini file: " + x.toString());
  }
}

void draw(){
 d.next();
 d.showImages();
 d.bottom();
}
 