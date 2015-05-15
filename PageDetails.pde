void page0() {
  picdig=1;
  tint(255,255,255,150);
  image(img[1], 0, (GAP*2)+Button.H, displayWidth*.89, displayHeight*.89); 
  noTint();
  fill(#FF00FF);
 // fill( #8BEFFF );
  fill(#35495e);
  rect(GAP, GAP, Button.W, Button.H,10);
}
 
void page1() {
   picdig=2;
   tint(255,255,255,150);
  image(img[2], 0, (GAP*2)+Button.H, displayWidth*.89, displayHeight*.89);
  noTint();
  fill(#FFFF00);
  //fill( #8BEFFF );
  fill(#35495e);
  rect(Button.W + GAP*2, GAP, Button.W, Button.H,10);
}
 
void page2() {
  fill(#008000);
  picdig=3;
  tint(255,255,255,150);
  image(img[3], 0, (GAP*2)+Button.H, displayWidth*.89, displayHeight*.89);
  noTint();
  fill(#FFFF00);
 // fill( #8BEFFF );
 fill(#35495e);
  rect(Button.W*2 + GAP*3, GAP, Button.W, Button.H,10);
}

void page3() {
  picdig=4;
  tint(255,255,255,150);
  image(img[4], 0, (GAP*2)+Button.H, displayWidth*.89, displayHeight*.89);
  noTint();
  fill(#FFFF00);
  //fill( #8BEFFF );
  fill(#35495e);
  rect(Button.W*3 + GAP*4, GAP, Button.W, Button.H,10);
}

void page4() {
  picdig=5;
  tint(255,255,255,150);
  image(img[5], 0, (GAP*2)+Button.H, displayWidth*.89, displayHeight*.89);
  noTint();
  fill(#FFFF00);
  fill( #35495e);
  rect(Button.W*4 + GAP*5, GAP, Button.W, Button.H,10);
}

void pageSelector() {
  switch(page) {
  case 0: 
    page0();
    break;
 
  case 1: 
    page1();
    break;
 
  case 2: 
    page2();
    break;
  case 3: 
    page3();
    break;
  case 4: 
    page4();
  }
}
