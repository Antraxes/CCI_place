void setup() {
  //canvas size
  size(1000, 1000);
}
  
void draw() {
  
  //moves whatever's in the matrix to the coordinates set
  pushMatrix();
  translate(300, 250);

  //draws 
  noFill();
  //makes the lines thick
  strokeWeight(35);
  //makes the lines flat
  strokeCap(PROJECT);
  //line colour 
  stroke(0);
  
  //leftmost C
  beginShape();
  vertex(230, 80);
  vertex(80, 80);
  vertex(80, 300);
  vertex(230, 300);
  endShape();
  
  //middle C
  beginShape();
  vertex(230, 150);
  vertex(150, 150);
  vertex(150, 230);
  vertex(230, 230);
  endShape();
  
  //dot on i
  line(300, 150, 300, 300);
  //line
  line(300, 80, 300, 80);
  
  popMatrix();
  //end of matrix

}
