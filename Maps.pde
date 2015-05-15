void map0(){ //scatterplot
  fill(#35495e);
  rect(displayWidth-GAP*5, Button.H+GAP*2, 75, 75,10);
  image(img[13], displayWidth-GAP*4.75, Button.H+GAP*2.15, 65, 65); //scatter
  //only shows 1 participant, how to show it for all the participants
  for (Datapoint data : dataCollected){   
   if (data.picture == picdig){
             stroke(0);
             data.createScatterPlot();
             stroke(200);
             strokeWeight(1.5);
          }  
        } 
}
void map1(){ //scatterplotlines
  fill(#35495e);
  rect(displayWidth-GAP*5, Button.H*2+GAP*4, 75, 75,10);
  image(img[14], displayWidth-GAP*4.75, Button.H*2+GAP*4.65, 65, 40); //scatterline

 for (int i = 0; i < dataCollected.size(); i++) {
  Datapoint curr = dataCollected.get(i);
   if(i > 0){      //if the current index is greather than 0
     Datapoint prev = dataCollected.get(i-1);           //we can access the previous
   if (curr.picture == picdig){
  //   println(curr.picture);
      //if(dist(curr.xpos,curr.ypos,prev.xpos,prev.ypos) < 20) {//check the distance, if it's within a certain threshold     
        
        stroke(0,0,255);
        strokeWeight(2);
        line(curr.xpos*.89,(curr.ypos*.89)+100,prev.xpos*.89,(prev.ypos*.89)+100);        //draw the line
        noStroke();
        curr.createScatterPlot();
        stroke(200);
        strokeWeight(1.5);
        }
      }
    }
    // rect(Button.W*5 + GAP*6, GAP, Button.W, Button.H, 10);
  } 
 

void map2(){ //heatmap
  fill(#35495e);
  rect(displayWidth-GAP*5, Button.H*3+GAP*6, 75, 75,10);
  image(img[12], displayWidth-GAP*4.5, Button.H*3+GAP*6.25, 50, 60); //heat
// draw the background image in the upper right corner and transparently blend the heatmap on top of it
for (Datapoint data : dataCollected){
  if (data.picture == picdig){
 // render the heatmapBrush into the gradientMap:
    drawToGradient(int(data.xpos*.89), int((data.ypos*.89)+100));
    // update the heatmap from the updated gradientMap:
    updateHeatmap(); 
    //tint(255,255,255,192);
    image(img[int(picdig)], 0,100,displayWidth*.89,displayHeight*.89);
    tint(255,255,255,150);
    image(heatmap, 0, 100, displayWidth*.89,displayHeight*.89);
    noTint();   
  }
} 
}

void drawToGradient(int x, int y)
{//Rendering code that blits the heatmapBrush onto the gradientMap, centered at the specified pixel and drawn with additive blending
  // find the top left corner coordinates on the target image
  int startX = x-img[6].width/2;
  int startY = y-img[6].height/2;

  for (int py = 0; py < img[6].height; py++)
  {
    for (int px = 0; px < img[6].width; px++) 
    {
      // for every pixel in the heatmapBrush:
      // find the corresponding coordinates on the gradient map:
      int hmX = startX+px;
      int hmY = startY+py;
      /*
      The next if-clause checks if we're out of bounds and skips to the next pixel if so. 
      Note that you'd typically optimize by performing clipping outside of the for loops!
      */
      if (hmX < 0 || hmY < 0 || hmX >= gradientMap.width || hmY >= gradientMap.height)
      {
        continue;
      }      
      // get the color of the heatmapBrush image at the current pixel.
      int col = img[6].pixels[py*img[6].width+px]; // The py*heatmapBrush.width+px part would normally also be optimized by just incrementing the index.
      col = col & 0xff; // This eliminates any part of the heatmapBrush outside of the blue color channel (0xff is the same as 0x0000ff)
      
      // find the corresponding pixel image on the gradient map:
      int gmIndex = hmY*gradientMap.width+hmX;
      
      if (gradientMap.pixels[gmIndex] < 0xffffff-col) // sanity check to make sure the gradient map isn't "saturated" at this pixel. This would take some 65535 clicks on the same pixel to happen. :)
      {
        gradientMap.pixels[gmIndex] += col; // additive blending in our 24-bit world: just add one value to the other.
        if (gradientMap.pixels[gmIndex] > maxValue) // We're keeping track of the maximum pixel value on the gradient map, so that the heatmap image can display relative click densities (scroll down to updateHeatmap() for more)
        {
          maxValue = gradientMap.pixels[gmIndex];
        }
      }
    }
  }
  gradientMap.updatePixels();
}

void updateHeatmap()
{ //Updates the heatmap from the gradient map.
  // for all pixels in the gradient:
  for (int i=0; i<gradientMap.pixels.length; i++)
  {
    // get the pixel's value. Note that we're not extracting any channels, we're just treating the pixel value as one big integer.
    // cast to float is done to avoid integer division when dividing by the maximum value.
    float gmValue = gradientMap.pixels[i];
    
    // color map the value. gmValue/maxValue normalizes the pixel from 0...1, the rest is just mapping to an index in the heatmapColors data.
    int colIndex = (int) ((gmValue/maxValue)*(img[7].pixels.length-1));
    int col = img[7].pixels[colIndex];

    // update the heatmap at the corresponding position
    heatmap.pixels[i] = col;
  }
  // load the updated pixel data into the PImage.
  heatmap.updatePixels();
}

void map3(){
  fill(#35495e);
  rect(displayWidth-GAP*5, Button.H*4+GAP*8, 75, 75,10);
  image(img[11], displayWidth-GAP*4.5, Button.H*4+GAP*8.5, 50, 50); //erased
   // background(0);   
  image(fossil, 0, 100, displayWidth*.89, displayHeight*.89);
  for (Datapoint data : dataCollected){
  if (data.picture == picdig){
    //image(img[int(picdig)], 0,0,displayWidth,displayHeight);
    //use similar to the heat map but instead the transparency data is changing
    for(int y = 0 ; y < side ; y++){
       for(int x = 0; x < side; x++){
        //copy pixel from 'bottom' image to the top one
        //map sketch dimensions to sand/fossil an dimensions to copy from/to right coords
        int srcX = int(map((data.xpos+x),0,width+side,0, img[int(picdig)].width));
        int srcY = int(map((data.ypos+y),0,height+side,0,img[int(picdig)].height));
        int dstX = int(map(data.xpos+x,0,width+side,0,fossil.width));
        int dstY = int(map(data.ypos+y,0,height+side,0,fossil.height));
        fossil.set(dstX, dstY, img[int(picdig)].get(srcX,srcY));
       }
     }  
  }
  }  
}

void map4(){
  fill(#35495e);
  rect(displayWidth-GAP*5, Button.H*5+GAP*10, 75, 75,10);
  image(img[9], displayWidth-GAP*4.65, Button.H*5+GAP*10.5, 60, 50); //cluster

  for (Datapoint data : dataCollected){
    if (data.picture == picdig){

    int[][] image1 = {{570,556}, {459,537}, {339,521}, {510,366}, {711,503}, {943,673}, 
                      {1203,448}, {1137,449}, {1104,91}, {886,34}, {781,249}, {982,410}, {1191,789}, {1091,791}};
    int[][] image2 = {{739,307}, {832,138}, {795,312}, {868,406}, {949,511}, 
                      {1186,494}, {574,431}, {486,465}, {314,460}, {257,458}, {1126,317}, {1146,132}};
    int[][] image3 = {{633,199}, {717,51}, {330,236}, {981,262}, {958,352}, 
                      {805,448}, {1123,424}, {428,482}, {561,492}, {138,445}, {1020,478}};
    int[][] image4 = {{613,60}, {660,220}, {552,373}, {511,233}, {274,491}, 
                        {206,384}, {829,371}, {713,547}, {1248,426}};
    int[][] image5 = {{691,472}, {801,302}, {586,384}, {1018,287}, {1252,120}};

 if (data.picture==1){
        for (int i = 0; i < image1.length; i++) {
            for (int j = 0; j < i; j++) {
              fill(0,0,255);
                ellipse(image1[i][0]*.88, (image1[i][1]*.88)+100, 30, 30);
               int dist1 = int(dist(image1[i][0]*.88, (image1[i][1]*.88)+100, data.xpos*.88, (data.ypos*.88)+100));
               if (dist1<100){//distance is less than than 50
                 line(image1[i][0]*.88, (image1[i][1]*.88)+100, data.xpos*.88, (data.ypos*.88)+100);
                 fill(0,0,255,100);
                 ellipse(data.xpos*.88, (data.ypos*.88)+100,10,10);
                }
                else{
                  fill(255,255,0,100);
                  ellipse(data.xpos*.88, (data.ypos*.88)+100,10,10);
                }
            }
          }
      }
 if (data.picture==2){
        for (int i = 0; i < image2.length; i++) {
            for (int j = 0; j < i; j++) {
              fill(0,0,255);
                ellipse(image2[i][0]*.88, (image2[i][1]*.88)+100, 30, 30);
               int dist2 = int(dist(image2[i][0]*.88, (image2[i][1]*.88)+100, data.xpos*.88, (data.ypos*.88)+100));
               if (dist2<100){//distance is less than than 50
                 line(image2[i][0]*.88, (image2[i][1]*.88)+100, data.xpos*.88, (data.ypos*.88)+100);
                 fill(0,0,255,100);
                 ellipse(data.xpos*.88, (data.ypos*.88)+100,10,10);
                }
                else{
                  fill(255,255,0,100);
                  ellipse(data.xpos*.88, (data.ypos*.88)+100,10,10);
                }
            }
          }
      }
       if (data.picture==3){
        for (int i = 0; i < image3.length; i++) {
            for (int j = 0; j < i; j++) {
              fill(0,0,255);
                ellipse(image3[i][0]*.88, (image3[i][1]*.88)+100, 30, 30);
               int dist3 = int(dist(image3[i][0]*.88, (image3[i][1]*.88)+100, data.xpos*.88, (data.ypos*.88)+100));
               if (dist3<100){//distance is less than than 50
                 line(image3[i][0]*.88, (image3[i][1]*.88)+100, data.xpos*.88, (data.ypos*.88)+100);
                 fill(0,0,255);
                 ellipse(data.xpos*.88, (data.ypos*.88)+100,10,10);
                }
                else{
                  //fill(255,255,0);
                  ellipse(data.xpos*.88, (data.ypos*.88)+100,10,10);
                }
            }
          }
      }
      if (data.picture==4){
        for (int i = 0; i < image4.length; i++) {
            for (int j = 0; j < i; j++) {
              fill(0,0,255);
                ellipse(image4[i][0]*.88, (image4[i][1]*.88)+100, 30, 30);
               int dist4 = int(dist(image4[i][0]*.88, (image4[i][1]*.88)+100, data.xpos*.88, (data.ypos*.88)+100));
               if (dist4<100){//distance is less than than 50
                 line(image4[i][0]*.88, (image4[i][1]*.88)+100, data.xpos*.88, (data.ypos*.88)+100);
                 fill(0,0,255);
                 ellipse(data.xpos*.88, (data.ypos*.88)+100,10,10);
                }
                else{
                  fill(255,255,0);
                  ellipse(data.xpos*.88, (data.ypos*.88)+100,10,10);
                }
            }
          }
      }   
      if (data.picture==5){
        for (int i = 0; i < image5.length; i++) {
            for (int j = 0; j < i; j++) {
              fill(0,0,255);
                ellipse(image5[i][0]*.88, (image5[i][1]*.88)+100, 30, 30);
               int dist5 = int(dist(image5[i][0]*.88, (image5[i][1]*.88)+100, data.xpos*.88, (data.ypos*.88)+100));
               if (dist5<100){//distance is less than than 50
                 line(image5[i][0]*.88, (image5[i][1]*.88)+100, data.xpos*.88, (data.ypos*.88)+100);
                 fill(0,0,255);
                 ellipse(data.xpos*.88, (data.ypos*.88)+100,10,10);
                }
                else{
                  //fill(255,255,0);
                  ellipse(data.xpos*.88, (data.ypos*.88)+100,10,10);
                }
            }
          }
      }
 //if first image is near
//  570 556
//459 537
//339 521
//510 366
//711 503
//943 673
//1203 448
//1137 449
//1104 91
//886 34
//781 249
//982 410
//1191 789
//1091 791


//second image
//739 307
//832 138
//795 312
//868 406
//949 511
//1186 494
//574 431
//486 465
//314 460
//257 458
//1126 317
//1146 132
      //third image
//633 199
//717 51
//330 236
//981 262
//958 352
//805 448
//1123 424
//428 482
//561 492
//138 445
//8 378
//fourth image
//613 60
//660 220
//552 373
//511 233
//274 491
//206 384
//829 371
//713 547
//1248 426

//fifth image
//691 472
//801 302
//586 384
//1018 287
//1252 120
      
      }
    }
  }

void map5(){
  fill(#35495e);
  rect(displayWidth-GAP*5, Button.H*7+GAP*14, 75, 75,10);
  image(img[8], displayWidth-GAP*4.5, Button.H*7+GAP*14.5, 50, 50); //click

 //if mouse pressed 
 for (Datapoint data : dataCollected){
    if (data.picture == picdig){

    }
  }
}

void animationovertime(){
 //show dots that will be used overtime   
}

void mapSelector() {
  switch(map) {
  case 0: 
    map0(); //scatter
    break;
 
  case 1: 
    map1(); //scatterlines
    break;
 
  case 2: 
    map2(); //heatmap
    break;
  
  case 3: 
    map3(); //deerasedimage
    break;
  
  case 4: 
    map4(); //clustering
    break;
    
  case 5:
    map5(); //click clustering
  }
}

