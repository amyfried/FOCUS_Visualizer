 //Used Noun Project for Icons
 //cluster icon created by Mani Amini
 //scatterplot icon by Anusha Narvekar
 //erase icon by Dan Hetteix
 //compare icon by Jonathan Higley
 //click icon created by Thomas Uebe
 //heatmap icon by Federico Panzano
 //scatterlineplot icon created by Eugen Belyakoff
 //eye used in logo created by Andy Santos-Johnson
 //images from http://hoopshabit.com/2014/12/30/fantasy-basketball-rudy-gobert-shining-utah-jazz/
//https://badgerherald.com/sports/2015/03/26/mens-basketball-dekker-koenig-see-familiar-face-in-uncs-j-p-tokoto/
//http://www.hawaiiarmyweekly.com/2011/04/28/94th-aamdc-captures-basketball-championship-69-64/
 
//Help from Multi Page Buttons (v1.6) by GoToLoop (2013/Oct) with buttons in program 
//forum.processing.org/two/discussion/558/creating-a-image2-page-button
//studio.processingtogether.com/sp/pad/export/ro.9eDRvB4LRmLrr/latest
//http://stackoverflow.com/questions/12532228/how-to-use-arraylist-in-processing
//Used for creating heatmap http://philippseifried.com/blog/2011/09/30/generating-heatmaps-from-code/
//IACD Amy Friedman copyright
//Special Thanks to Golan Levin, David Newbury
 
static final int MAX = 5, GAP = 25, DIM = 120, RAD = DIM >> 1;
int page;
int map=6;

float picdig=0;
PImage[] img;
int n=16;
//boolean photo1, photo2, photo3, photo4, photo5 = false;
//boolean test1, test2, test3, test4, test5 = false;
PImage logo;
Button image1, image2, image3, image4, image5, scatter, scatter2, heat, erased, cluster, compare,click;

PImage heatmapBrush; // radial gradient used as a brush. Only the blue channel is used.
PImage heatmapColors; // single line bmp containing the color gradient for the finished heatmap, from cold to hot
PImage gradientMap; // canvas for the intermediate map
PImage heatmap; // canvas for the heatmap
PImage clickmap; // canvas for the clickmap
float maxValue = 0; // variable storing the current maximum value in the gradientMap

PImage fossil;
int side = 20;//size of square 'brush'

ArrayList<Datapoint> dataCollected;// need for pic 
Table table;

 // Note the HashMap's "key" is a String and "value" is an Integer
  HashMap<Integer,ArrayList> hm = new HashMap<Integer,ArrayList>();
 
 boolean sketchFullScreen() {
  return true;
  //return false;
}

void setup() {
  size(displayWidth, displayHeight);
    //size(800, 600);
   //println(displayWidth);
  
  dataCollected = new ArrayList<Datapoint>(); // our intention to fill this ArrayList with datapoint objects

  //load all of the photos into the program 
  img=new PImage[n];
  String imgpath = sketchPath+"/images/";
  File imgdata = new File (imgpath);
  String [] imglist = imgdata.list();
  for(int i=0; i<imglist.length; i++){
    String[] m1 = match(imglist[i], "png");
    String[] m2 = match(imglist[i], "jpg");
    if (m1 != null || m2 != null) {
      img[i] = loadImage(imgpath+imglist[i]);
    }  
  }
 
  frameRate(50);
  noLoop();
  smooth();
 
  rectMode(CORNER);
  ellipseMode(CENTER);
  textAlign(CENTER, CENTER);
 
  stroke(200);
  strokeWeight(1.5);

  fossil = createImage(displayWidth, displayHeight, ARGB); //for deErased Sketch

 // create empty canvases:
  gradientMap = createImage(displayWidth, displayHeight, ARGB);
  heatmap = createImage(displayWidth, displayHeight, ARGB);
  // load pixel arrays for all relevant images
  gradientMap.loadPixels();
  for (int i=0; i<gradientMap.pixels.length; i++) {
    gradientMap.pixels[i] = 0;
  }
  heatmap.loadPixels();
  img[6].loadPixels();
  img[7].loadPixels();
  
  //load all of the tsv files into the program as tables
  String path = sketchPath+"/data/";
  File data = new File (path);
  String [] list = data.list();
  for(int i=0; i<list.length; i++){
      table = loadTable(path+list[i], "header"); //use arraylist to load tables
      println(table.getRowCount() + " total rows in table"); 
   
       //dataCollected = new ArrayList<float[]>(); // our intention to fill this ArrayList with datapoint objects
         table.addColumn("Participant_id");
         TableRow newRow = table.addRow();
        // newRow.setInt("Participant_id", i);
          for (TableRow row : table.rows()) {
               newRow.setInt("Participant_id", i);
              float x = row.getFloat("X Coordinate");
              float y = row.getFloat("Y Coordinate");
              float time = row.getFloat("Time Spent");
              float pic = row.getFloat("Image Viewed");
              float part = row.getInt( "Participant_id");
              //println(part);
//              float [] numbers = new float[4];
//              numbers[0] = x;
//              numbers[1] = y;
//              numbers[2] = time;
//              numbers[3] = pic;
//              println(numbers);
          // Do something with the data of each row
             dataCollected.add(new Datapoint(x, y, time, pic, part));
              //dataCollected.add(numbers);              
              //println(i);
          }                           
          //println(i);
         // println("The total number of data is: " + dataCollected.size());
          hm.put(i, dataCollected);
         // println(hm);
    }
  // The size() method returns the current number of items in the list
  int total = dataCollected.size(); 
 println("The total number of data is: " + total);
  //println(dataCollected);
  
  image1 = new Button("Image 1", GAP,  GAP, 200, 50);
  image2 = new Button("Image 2", Button.W + GAP*2, GAP, 200, 50);
  image3 = new Button("Image 3",  Button.W*2 + GAP*3, GAP, 200, 50);
  image4 = new Button("Image 4", Button.W*3 + GAP*4, GAP, 200, 50);
  image5 = new Button("Image 5", Button.W*4 + GAP*5, GAP, 200, 50);
  scatter =   new Button("", displayWidth-GAP*5, Button.H+GAP*2, 75, 75);
  scatter2 =  new Button("", displayWidth-GAP*5, Button.H*2+GAP*4, 75, 75);
  heat =      new Button("", displayWidth-GAP*5, Button.H*3+GAP*6, 75, 75);
  erased =    new Button("", displayWidth-GAP*5, Button.H*4+GAP*8, 75, 75);
  cluster =   new Button("", displayWidth-GAP*5, Button.H*5+GAP*10, 75, 75);
  compare =   new Button("", displayWidth-GAP*5, Button.H*6+GAP*12, 75, 75);
  click =     new Button("", displayWidth-GAP*5, Button.H*7+GAP*14, 75, 75);
}
 
void draw() {
  background(255);
 // test1=true;

  textSize(0100);
  fill(Button.TXTC);
  textSize(Button.TXTSZ);
  if (page >= 0){ 
    image1.display();  
    image2.display();
    image3.display();
    image4.display();
    image5.display();
  }
  
  if (map >= 0){
    scatter.display();
    scatter2.display();
    heat.display();
    erased.display();
    cluster.display();
    compare.display();
    click.display();
    
  }
 
  method("page" + page); // Java only!
  method("map" + map);
  //pageSelector();        // For JS!
  
  image(img[8], displayWidth-GAP*4.5, Button.H*7+GAP*14.5, 50, 50); //click
  image(img[9], displayWidth-GAP*4.65, Button.H*5+GAP*10.5, 60, 50); //cluster
  image(img[10], displayWidth-GAP*4.5, Button.H*6+GAP*12.5, 50, 50); //compare
  image(img[11], displayWidth-GAP*4.5, Button.H*4+GAP*8.5, 50, 50); //erased
  image(img[12], displayWidth-GAP*4.5, Button.H*3+GAP*6.25, 50, 60); //heat
  image(img[13], displayWidth-GAP*4.75, Button.H+GAP*2.15, 65, 65); //scatter
  image(img[14], displayWidth-GAP*4.75, Button.H*2+GAP*4.65, 65, 40); //scatterline
  image(img[15], displayWidth-Button.W-GAP*2.5, 0, 300, 90); //logo

//  // if (test1) scatterplot();
//   if (test2) scatterplotlines();
//   if (test3) heatMap();
//   if (test4) clustering();
//   if (test5) deErasedImage();
   
//Used for HashMap  
//// Get keys.
//  Set<Integer> keys = hm.keySet();
//  int prevkey=0;
//  // Loop over String keys.
//  for (Integer key : keys) {
//    if (fruit.get(key) == "red") {
//      System.out.println(key);}
//  }
//  //println(hm.size());
//// Using an enhanced loop to interate over each entry
//  for (Map.Entry me : hm.entrySet()) {
//  // print(me.getKey() + " is ");
//  // println(me.getValue());
//}
//  //println(hm.get(1));  
//  Iterator i = map.keySet().iterator();
//  while (i.hasNext()) {
//    //  Integer participant = (Integer) i.next();
//  //  ArrayList data = (ArrayList) map.get(participant);
//}

}
 
void mousePressed() {
  if      (image1.isHovering)  page = 0;
  else if (image2.isHovering)  page = 1;
  else if (image3.isHovering)  page = 2;
  else if (image4.isHovering)  page = 3;
  else if (image5.isHovering)  page = 4;
  if      (scatter.isHovering) map = 0;
  else if (scatter2.isHovering)map = 1;
  else if (heat.isHovering)    map = 2;
  else if (erased.isHovering)  map = 3;
  else if (cluster.isHovering) map = 4;
  else if (click.isHovering)   map = 5;
 
  redraw();
}
 
void mouseMoved() {
  image1.isInside();
  image2.isInside();
  image3.isInside();
  image4.isInside();
  image5.isInside();
  scatter.isInside();
  scatter2.isInside();
  heat.isInside();
  erased.isInside();
  cluster.isInside();
  compare.isInside();
  click.isInside();
 
  redraw();
}
 

