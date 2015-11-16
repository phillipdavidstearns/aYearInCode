import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;


import processing.opengl.*;

HE_Mesh box;
WB_Render render;
void setup() {
  size(600, 600, OPENGL);
  smooth();

  HEC_Box boxCreator=new HEC_Box().setWidth(400).setWidthSegments(10)
    .setHeight(200).setHeightSegments(4)
      .setDepth(200).setDepthSegments(4);
  boxCreator.setCenter(100, 100, 0).setZAxis(1, 1, 1);
  box=new HE_Mesh(boxCreator);

  //define a selection
  HE_Selection selection=new HE_Selection(box);  

  //add faces to selection
  HE_FaceIterator fItr=new HE_FaceIterator(box);
  HE_Face f;
  while (fItr.hasNext ()) {
    f=fItr.next();
    if (random(100)<10) selection.add(f);
  }


  HEM_Extrude extrude=new HEM_Extrude().setDistance(100);

  //only modify selection (if applicable)
  box.modifySelected(extrude, selection);
  
  //Some modifiers store selections after application.
  HE_Selection newSelection=extrude.walls;
  extrude.setDistance(-10).setChamfer(0.4);
  box.modifySelected(extrude,newSelection);
  
  render=new WB_Render(this);
}

void draw() {
  background(120);
  lights();
  translate(300, 300, 0);
  rotateY(mouseX*1.0f/width*TWO_PI);
  rotateX(mouseY*1.0f/height*TWO_PI);
  noStroke();
  render.drawFaces(box);
  stroke(0);
  render.drawEdges(box);
}




