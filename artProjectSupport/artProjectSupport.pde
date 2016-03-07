import processing.video.*;
/* drawing, multiples, pauses
   text in other project 
   */

Movie[] myMovie = new Movie[5];
double len;
int yPos = 0;
int[] textArea = {5, 400, 590, 90};
String[] prints = {
  "this is a line",
  "another line",
  "testing is a problem", 
  "next line",
  "a cloud system is a situation never encountered",
  "terminatior is asa ldasda lpo p aspdoa dpao sdadapo aAs",
  "dasda asdaodi oinda asdano asda oinda dasdao rew"
};
int maxLines = 3;
int currentLine;

void setup(){
  size(600, 500);
  background(255);
  currentLine = 0;
  for(int i = 0; i < 5; i++){
    myMovie[i] = new Movie(this, "img.mov");
    len = myMovie[i].duration();
    myMovie[i].loop();
  }
}

void draw(){
  tint(random(255));
  for(int i = 0; i < 5; i++){
    if(myMovie[i].available())
      myMovie[i].read();
    image(myMovie[i], i * 5, i* 5, width / 2, textArea[1] - 10); // offset
    //image(myMovie, width / 2, 0, width / 2, height / 2); // offset
  }
  for( int x = 0; x < (int)random(100000); x++){ int j = x + 1;}
  line(random(width), random(height), random(width), random(height));
  stroke(0);
  
  fill(0, 128, 128);
  text(prints[currentLine], textArea[0] + 5, textArea[1] + yPos, textArea[2], textArea[3]); // offset
  noFill();
  yPos += 10; // size of font
  if(textArea[1] + yPos > 470){ // calculated
    fill(255);
    rect(textArea[0], textArea[1], textArea[2], textArea[3]);
    yPos = 0;
  }
  currentLine++;
  if(currentLine >= prints.length) {
    currentLine = 0;
  }
}

/*
void movieEvent(Movie m) {
  m.read();
  if(m.time() >= len)
    println("Reached end");
}
*/