class Datapoint { 
  float xpos, ypos, time, picture, part; 
  color c;
 
  Datapoint (float x, float y, float t, float p, float id) {  
    xpos = x;
    ypos = y; 
    time = t; 
    picture = p;
    part = id;
    c=color(random(100, 200), 255, 255);
  } 

  void createScatterPlot() {
      if (picture == 1)
        {fill(c, 200);}
      if (picture == 2)
        { 
          fill(0,230,0, 200);
        }
     if (picture == 3)
        {
          fill(255,255,0, 200);
        }
     if (picture == 4)
        {
           fill(255, 200);
        }
     if (picture == 5)
        {
          fill(0,0,244, 200);
        }
  //    ellipse(drawing[i], r, r);    
      ellipse(xpos*.89,(ypos*.89)+100,10,10);  
   }
}
