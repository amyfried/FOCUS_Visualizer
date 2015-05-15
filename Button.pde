class Button {
  static final int W = 200, H = 50, TXTSZ = 020;
  static final color BTNC = #00A0A0, HOVC = #00FFFF, TXTC = 255;
 
  final String label;
  final short x, y, w,h;
 
  boolean isHovering;
 
  Button(String txt, int xx, int yy, int ww, int hh) {
    label = txt;
 
    x = (short) xx;
    y = (short) yy; 
    
    w = (short) ww;
    h = (short) hh;
  }
 
  void display() {
    fill(isHovering? HOVC:BTNC);
    rect(x, y, w, h,10);
 
    fill(TXTC);
    text(label, x + w/2, y + h/2);
  }
 
  boolean isInside() {
    return isHovering = mouseX > x & mouseX < (x+w) & mouseY > y & mouseY < (y+h);
  }
}
