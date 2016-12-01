/* 
* Multi-way dependencies Visualization
* Hoa Thanh Nguyen
*/

import java.util.List;
import java.util.HashSet;
import java.util.Arrays;
import java.util.Set;
import java.util.Vector;

import com.sci.vis.SingleLinePlot;
import com.sci.vis.Scatterplot;
import com.sci.vis.Splom;
import com.sci.vis.Lineplot;
import com.sci.data.CSVLoader;
import org.ejml.ops.MatrixVisualization;

import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*;
import javax.swing.*;
import processing.core.PApplet;
import java.awt.*;

import java.awt.Dimension;
import java.awt.FlowLayout;
import javax.swing.Box;
import javax.swing.JCheckBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JScrollPane;
import javax.swing.JSlider;
import java.util.Hashtable;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

import java.awt.EventQueue;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;

int gX,gY;
ta_scroll gui;

PApplet dw;
PApplet dname;
private ControlP5 cp5; 
ControlFrame cf;
CSVLoader data = null;
CSVLoader data_origin = null;
ReadableAttribute[] dtmp = new  ReadableAttribute[250];
ArrayList<ReadableAttribute> dat = new ArrayList<ReadableAttribute>();
ArrayList<ReadableAttribute> tmpDat = new ArrayList<ReadableAttribute>();
double pcc[][] = new double[250][250];
double spcc[][] = new double[250][250];
String dimLabel[] = new String[250];
int dimList[] = new int[250];
int numDims = 0;
int pccComputed = 0;

int numData, numDat;
CheckBox checkbox;
DropdownList d1, d2;
Slider upth, loth;
controlP5.Button b;
controlP5.Button c;
int buttonValue = 0;

//set correlation coefficient threshold
float lower_threshold = 0;
float upper_threshold = 0.9;

float rad_edges = 5;
float rad_triangles = 7.5;
float rad_tets = 15;
float cenx, ceny;
float scaleFactor;
float translateX;
float translateY;
float Xstart, Ystart, Xend, Yend;

// Xaxis = 1: R2 min, 2: R2 max, 3: R2 avg.
int Xaxis = 1;
int oldXaxis = 1;
// Xaxis = 1: R2 min, 2: R2 max, 3: R2 avg, 4:dims.
int Yaxis = 4;
int oldYaxis = 4;
double sc = 0;

// vizMeth = 1:edges, 2:triangle, 4:tets, 7: combine all three types.
// 3: triangles and edges, 5: edges and tets, 6: tri and tets, 
int vizMeth = 7;
int oldMeth = 7;
int step = 0;
int nstep = 20000;
int selectedBox = 0;
float sb_startx=0, sb_starty=0, sb_endx=0, sb_endy=0;
float old_sb_startx=0, old_sb_starty=0, old_sb_endx=0, old_sb_endy=0;
int fullRel = 1;
float originx = 0;
float originy = 0;
float gap = 6;
float interBar = 0;
float igB = 0;
int selectedPosBar = 0;
float selectedx = 0, selectedy = 0;
int selectedGlyph = 0;
float zoom = 10;
float oldstate = 0;
float detailThres = 3;
float selv = 5;
float oldgap = gap;
int selectedViz = 0;
float thresStartX, thresEndX;
float selectedElem = 0;

float gx, gy, gw;
float p0x, p0y, p1x, p1y, p2x, p2y, p3x, p3y;
float po0x, po0y, po1x, po1y, po2x, po2y, po3x, po3y;
float pt0x, pt0y, pt1x, pt1y, pt2x, pt2y, pt3x, pt3y,pt30x, pt30y,pt31x, pt31y,pt32x, pt32y;

float x_min = 0, x_max = 1;
float y_min = 0, y_max = 1;
  
float u0 = 100;
float v0 = 100;
float w = 0;
float h = 0;
int numSPlot = 4;
int sp[] = new int[5];
PFont f;

double r2max_tet = -1, r2min_tet = 2;
double r2max_tri = -1, r2min_tri = 2;
double r2max_edge = -1, r2min_edge = 2;

float r2max, r2min;

// untangle Map
float[][] post_prob = new float[40000][250];  
int[][] map = new int[11][11];
int attrCount = 0;
int elemCount = 0;
int mouseClick = 1;

int seld0 = -1, seld1 = -1, seld2 = -1, seld3 = -1;
float selx, sely;
int filterDim = -1;
float prevPos = 0;

// intersection point between two lines
float xInts, yInts;

int fon = 16;
String[] dimnames = new String[250];

// lasso
int lassoSelect = 0;
int[] pmX = new int[1000000];
int[] pmY = new int[1000000];
int numpm = 0;
    
void setup() {
  if( SystemX.isWindows() ){
    size(845,550);
  }
  if( SystemX.isMac() ){
    size(845,600);
  }
  else
    size(845,550); // linux
  frameRate( 10 );
  if (frame != null) {
    frame.setResizable(true);
  }
  cp5 = new ControlP5(this); 

  cf = addControlFrame("Menu", 150,780);
  textFont( createFont("Arial", fon, true) );
  try {
    data = new CSVLoader("/Users/hoa/Documents/Data/nhatsdata/round1op.csv", true);
  }
  catch( IOException e ){
    e.printStackTrace( );
  }

  cenx = width/4;
  ceny = height/4;

  scaleFactor = 1;
  translateX = 0;
  translateY = 0;

  Xaxis = 1;
  
  dw = new detailWin();
  startApplet(dw);
  
  Xstart = 30;
  Ystart = 30;
  Xend = width - 30;
  Yend = height - 100;
  
  sb_startx = Xstart;
  sb_endx = Xend;
  sb_starty = Ystart;
  sb_endy = Yend;
  thresStartX = sb_startx;
  thresEndX = sb_endx;

  dtmp = data.getAttributeList();
  numData = data.attributeCount();
  numDat = numData;
  numData = numDat;
  for(int i = 0; i< numDat; i++) {
    dat.add(dtmp[i]);
  }

  nstep = 2500*numData;
  gap = numData*(Xend+Xstart)/(5*((numData-1)*(numData-1)));
  oldgap = gap;
  pccComputed = 0;
  spccData();
  sb_startx = Xstart;
  sb_endx = Xend;
  sb_starty = Ystart;
  sb_endy = Yend;
  thresStartX = sb_startx;
  thresEndX = sb_endx;
  
  maxminR2_tet();
  maxminR2_tri();
  maxminR2_edge();
  
  r2max = (float)r2max_tet;
  r2min = (float)r2min_edge;
  
  // untangleMap setup
  attrCount = data.attributeCount()-1;
  elemCount = data.elementCount();
  //posterior probability of data item i for label (dimension) attr j
  for(int i = 0; i < elemCount; i++){
    float rowsValue = 0;  
    for (int j = 0; j < attrCount; j++){
      ReadableAttribute attr_j = data.getAttribute(j); 
      rowsValue += attr_j.get(i);
    }
    for (int j = 0; j < attrCount; j++){
      ReadableAttribute attr_j = data.getAttribute(j); 
      post_prob[i][j] = attr_j.get(i)/rowsValue;
    }
  }
  
  // dim names 
  dimnames = loadStrings("/Users/hoa/Documents/Data/nhatsdata/Round1OPnames.txt");
  for(int i=0; i<dimnames.length; i++){
     String tmp = dimnames[i];
     dimLabel[i] = tmp.substring(0, tmp.indexOf('_'));
  }
}

void draw() {
   background(255);
   fill(0);  
   
   gX=frame.getX();gY=frame.getY();
   
   if (frameCount==4){  
     gui = new ta_scroll();
     gui.f.setAlwaysOnTop(true);
     gui.launchFrame();   
   }
   if(numDims > 0){
      translateX = 0;
      translateY = 0;
      scaleFactor = 1;
      
      sb_startx = 0;
      sb_starty = 0;
      sb_endx = width;
      sb_endy = height;
      thresStartX = 0;
      thresEndX = width;
       
      dat.clear();
      dtmp = data.getAttributeList();
      numData = numDims;
      numDat = numData;
      numData = numDat;
      for(int i = 0; i< numDims; i++){
        dat.add(dtmp[dimList[i]]);
      }
      nstep = 200*numData;
      gap = numData*(Xend+Xstart)/(5*((numData-1)*(numData-1)));
      oldgap = gap; 
      rad_edges = 5;
      rad_triangles = 1.5*rad_edges;
      rad_tets = 3*rad_edges;
      pccComputed = 0;
      pccData();
      
      r2max_tet = -1; r2min_tet = 2;
      r2max_tri = -1; r2min_tri = 2;
      r2max_edge = -1; r2min_edge = 2;
      maxminR2_tet();
      maxminR2_edge();  
      r2max = (float)r2max_tet;
      r2min = (float)r2min_edge;
      seld0 = -1; seld1 = -1; seld2 = -1; seld3 = -1;
      filterDim = -1;
  }
  
  dw.background(255);
    
  // draw intersection Bar
  fill(150,150,150);
  stroke(150,150,150);
  if(selectedPosBar == 0)
    line(width - interBar - igB, 0, width - interBar - igB, height);
  else{
    line(mouseX, 0, mouseX, height);
    interBar = width - mouseX - igB;
    selectedPosBar = 1;
  }
  
  if(selectedBox == 3){
    selectedGlyph = 0;
    fill(255,0,0);
    stroke(255,0,0);
    line(sb_startx,sb_starty,sb_startx,mouseY);
    line(sb_startx,mouseY,mouseX,mouseY);
    line(mouseX,mouseY,mouseX,sb_starty);
    line(mouseX,sb_starty,sb_startx,sb_starty);
  }
  
  if(selectedBox == 2){
    filterSel();
    selectedBox = 0;
  }
  
  
  // lasso
  if(lassoSelect == 1 || lassoSelect == 2){
    if(lassoSelect == 2){
      tmpDat.clear();
    }
    for(int i=0; i<numpm-1; ++i){
      if(lassoSelect == 1) { 
        fill(255,0,0);
        stroke(255,0,0);
        line(pmX[i],pmY[i],pmX[i+1],pmY[i+1]);
      }
      if(lassoSelect == 2){
        filterSel_lasso(pmX[i], pmY[i], pmX[numpm-1-i], pmY[numpm-1-i]);
      }
    }
    
    if(lassoSelect == 2){
        dat.clear();
        for(int k=0; k<tmpDat.size(); k++){
          int selDim = Integer.parseInt(tmpDat.get(k).getLabel().replace("d", ""));
          dimList[k] = selDim;
          dat.add(tmpDat.get(k));
        }
        numData = dat.size();
        nstep = 500*numData;
        if(numData < 20 && numData > 10){
          rad_edges = 3*(width - Xstart)/(numData*numData);
          rad_triangles = 1.5*rad_edges;
          rad_tets = 3*rad_edges;
        } else if(numData <=10){
          rad_edges = 6*(width - Xstart)/(numData*numData*numData);
          rad_triangles = 1.5*rad_edges;
          rad_tets = 3*rad_edges;
        } else{
          rad_edges = 5;
          rad_triangles = 1.5*rad_edges;
          rad_tets = 3*rad_edges;
        }
        
        pccComputed = 0;
        pccData();  
        r2max_tet = -1; r2min_tet = 2;
        r2max_tri = -1; r2min_tri = 2;
        r2max_edge = -1; r2min_edge = 2;    
        maxminR2_tet();
        maxminR2_edge();  
        r2max = (float)r2max_tet;
        r2min = (float)r2min_edge;
        
        lassoSelect = 0;
    }
  }
  
  draw_relationship();
}

void mouseMoved() {
  // lasso
  if(lassoSelect == 1){
    pmX[numpm] = mouseX;
    pmY[numpm] = mouseY;
    numpm++;
  }
}

void mousePressed() {
  if(selectedBox == 1){
    if(scaleFactor == 1){
      sb_startx = mouseX;
      sb_starty = mouseY;      
      originx = mouseX;
      originy = mouseY;
    }
    else{
      originx = (mouseX-translateX)/scaleFactor;
      originy = (mouseY-translateY)/scaleFactor;
      sb_startx = mouseX;
      sb_starty = mouseY;
    }
    thresStartX = mouseX;
    
    selectedBox = 3;
  }
  else{
    selectedGlyph = 1;
    mouseClick = 1;
  }
  
  if(mouseX<(width-interBar-igB+10) && mouseX>(width-interBar-igB-10)){
    selectedPosBar = 1;
  }
  
  // lasso
  if (lassoSelect == 1)
    lassoSelect = 2;
  if(lassoSelect == 3){
    numpm = 0;
    lassoSelect = 1;
  }  
}

void mouseDragged() {
}

void mouseReleased() {  
  if(selectedBox == 3){
    sb_endx = mouseX;
    sb_endy = mouseY;
    selectedBox = 2; 
    thresEndX = mouseX; 
    selectedViz = vizMeth;
  }
  if(selectedPosBar == 1)
    selectedPosBar = 0;
}


void keyPressed()
{
  if (key == 'r')
  {
    translateX = 0;
    translateY = 0;
    scaleFactor = 1;
    
    sb_startx = 0;
    sb_starty = 0;
    sb_endx = width;
    sb_endy = height;
    thresStartX = 0;
    thresEndX = width;
    
    dat.clear();
    dtmp = data.getAttributeList();
    numData = data.attributeCount();
    numDat = numData;
    numData = numDat;
    for(int i = 0; i< numDat; i++)
      dat.add(dtmp[i]);
    nstep = 200*numData;
    gap = numData*(Xend+Xstart)/(5*((numData-1)*(numData-1)));
    oldgap = gap; 
    rad_edges = 5;
    rad_triangles = 1.5*rad_edges;
    rad_tets = 3*rad_edges;
    pccComputed = 0;
    spccData();
    
    r2max_tet = -1; r2min_tet = 2;
    r2max_tri = -1; r2min_tri = 2;
    r2max_edge = -1; r2min_edge = 2;
    maxminR2_tet();
    maxminR2_edge();  
    r2max = (float)r2max_tet;
    r2min = (float)r2min_edge;
    seld0 = -1; seld1 = -1; seld2 = -1; seld3 = -1;
    filterDim = -1;
  }
}

void mouseWheel(MouseEvent e)
{
  int s = 10;
  translateX = translateX-e.getAmount()*(mouseX)/s;
  translateY = translateY-e.getAmount()*(mouseY)/s;
  scaleFactor += e.getAmount()/s;  
}

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(0, 0);
  f.setResizable(true);
  f.setVisible(true);
  return p;
}

public class ControlFrame extends PApplet {
  int w, h;
  public void setup() {
    size(w, h);
    frameRate(60);
    PFont font = createFont("arial",fon);
    
    cp5 = new ControlP5(this);
    
    d1 = cp5.addDropdownList("myList-d1")
          .setPosition(20, 360)
          ;        
    d2 = cp5.addDropdownList("myList-d2")
        .setPosition(20, 250)
        ;     
    customize(d1); // customize the first list 
    d1.setIndex(0);
    
    customize2(d2);
    d2.setIndex(3);
     
    Xaxis = 1; 
    Yaxis = 4;    
    
    loth = cp5.addSlider("min").plugTo(parent,"lower_threshold").setRange(0, 1).setPosition(20,30);
    upth = cp5.addSlider("max").plugTo(parent,"upper_threshold").setRange(0, 1).setPosition(20,50).setValue(1);
    
    checkbox = cp5.addCheckBox("checkBox")
              .setPosition(20, 95)
              .setColorForeground(color(120))
              .setColorActive(color(255))
              .setColorLabel(color(255))
              .setSize(10, 10)
              .setItemsPerRow(1)
              .setSpacingColumn(30)
              .setSpacingRow(20)              
              .addItem("Combined/Separated",10)
              .addItem("Pairwise", 1)
              .addItem("3-way", 2)
              .addItem("4-way", 4)
              ;   
    b = cp5.addButton("SelectionBox")
        .setValue(1)
        .setPosition(20,460)
        .setSize(100,20);
        
    c = cp5.addButton("LassoSelection")
        .setValue(1)
        .setPosition(20,560)
        .setSize(100,20);
  }
 
  public void SelectionBox(int theValue) {
  }
  
  public void LassoSelection(int theValue) {
  }
  
  public void draw() {
      background(100);
      noFill();
      stroke(200);
      strokeWeight(3);
      rect(15, 117, 110,88);
  }
  
  private ControlFrame() {
  }

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }

  void controlEvent(ControlEvent theEvent) {
    
    
    if (theEvent.isFrom(upth)){      
      //oldXaxis = Xaxis;
      Xaxis = (int)theEvent.getGroup().getValue();
    }
    if (theEvent.isFrom(loth)){ 
      //oldXaxis = Xaxis;     
      Xaxis = (int)theEvent.getGroup().getValue();
    }
    
    if (theEvent.isFrom(checkbox)) {
      int cb = 0;
      oldMeth = vizMeth;
      step = 0;
      for (int i=1;i<checkbox.getArrayValue().length;i++) {
        int n = (int)checkbox.getArrayValue()[i];
        if(n==1) {
            cb += checkbox.getItem(i).internalValue(); 
        }
      }
      vizMeth = cb;
      
      int k = (int)checkbox.getArrayValue()[0];
      if(k == 1){
        fullRel = 1;
      }
      else
        fullRel = 0;
        
      if(k == 1){
        if(cb==7 || cb == 0 ){
          if(oldMeth == 7){
            vizMeth = 9;
            fullRel = 0;
          }
        }
      }
      
      oldXaxis = Xaxis;
      oldYaxis = Yaxis;
      Xaxis = (int)theEvent.getController().getValue();    
    }

    if (theEvent.isGroup()) {
      step = 0;
      // check if the Event was triggered from a ControlGroup
      String gr = theEvent.getGroup().name();
      if(gr.equals("myList-d1")){        
        oldXaxis = Xaxis;
        Xaxis = (int)theEvent.getGroup().getValue();
      }
      else{
        step = 0;
        oldYaxis = Yaxis;
        Yaxis = (int)theEvent.getGroup().getValue();
      }
    } 
    else if (theEvent.isController()) {
      //oldXaxis = Xaxis;
      Xaxis = (int)theEvent.getController().getValue();
    }
    if(theEvent.isFrom(b)) {
      selectedBox = 1; 
    }    
    if(theEvent.isFrom(c)) {
      if(lassoSelect == 0) lassoSelect = 3;
    } 
  }
    
  void checkBox(float[] a) {
  }
  
  void customize(DropdownList ddl) {
    // a convenience function to customize a DropdownList
    ddl.setBackgroundColor(color(190));
    ddl.setItemHeight(20);
    ddl.setBarHeight(15);
    ddl.captionLabel().set("Yaxis");
    ddl.captionLabel().style().marginTop = 3;
    ddl.captionLabel().style().marginLeft = 3;
    ddl.valueLabel().style().marginTop = 3;
    
    ddl.addItem("Y axis - R2 min", 1);
    ddl.addItem("Y axis - R2 max", 2);
    ddl.addItem("Y axis - R2 average", 3);
    ddl.addItem("Y axis - Dimensions", 4);
    
    ddl.setColorBackground(color(60));
    ddl.setColorActive(color(255, 128));
  }
  
  void customize2(DropdownList ddl) {
    // a convenience function to customize a DropdownList
    ddl.setBackgroundColor(color(190));
    ddl.setItemHeight(20);
    ddl.setBarHeight(15);
    ddl.captionLabel().set("Xaxis");
    ddl.captionLabel().style().marginTop = 3;
    ddl.captionLabel().style().marginLeft = 3;
    ddl.valueLabel().style().marginTop = 3;
    
    ddl.addItem("X axis - R2 min", 1);
    ddl.addItem("X axis - R2 max", 2);
    ddl.addItem("X axis - R2 average", 3);
    ddl.addItem("X axis - Dimensions", 4);
    ddl.addItem("X axis - Time", 5);
    
    //ddl.scroll(0);
    ddl.setColorBackground(color(60));
    ddl.setColorActive(color(255, 128));
  }
  public ControlP5 control() {
    return cp5;
  }
  
  ControlP5 cp5;
  Object parent;
}


void startApplet(final PApplet p) {
  if (p == null) return;
  final PFrame f = new PFrame(p);
  p.frame = f;
  f.setTitle(p.getClass() + " window");
  //this thread is only necessary if you are restarting the PApplets
  Thread t = new Thread(new Runnable() {
    public void run() {
      p.setup();
    }
  });
  t.run();
}
void stopApplet(PApplet p) {
  if (p == null || p.frame == null) return;
  p.dispose();
  p.frame.dispose();
}

public class PFrame extends JFrame {
  public PFrame(PApplet p) {
    setSize(280, 770);
    add(p);
    p.init();
    show();
  }
}

public class detailWin extends PApplet {
  int counter = 0;
  public void setup() {
    size(280, 780); 
    textFont( createFont("Arial", 14, true) );   
    counter = 0;
    if (frame != null) {
      frame.setResizable(true);
    }
    background(255);
    noLoop();
  }
  public void draw() {
    frame.setLocation(1000, 0);
    mouseClick = 0;
    gx = dw.width/2;
    gy = dw.width/2;
    gw = dw.width/2;
    
    p0x = gx-gw/6;
    p0y = gy+gw/6;
    p1x = gx+gw/6;
    p1y = gy-gw/6;
    p2x = gx+gw/6;
    p2y = gy+gw/6;
    p3x = gx-gw/6;
    p3y = gy-gw/6;
    
    float d = 200;
    po0x = gx-gw/2;
    po0y = gy-gw/2+d;
    po1x = gx+gw/2;
    po1y = gy-gw/2+d;
    po2x = gx+gw/2;
    po2y = gy+gw/2+d;
    po3x = gx-gw/2;
    po3y = gy+gw/2+d;
  
    float h = (po1x - po0x)/4;
    float v = (po2y - po1y)/2; 
    pt0x = po0x+h;
    pt0y = gy-gw/2+v;
    pt1x = po1x-h;
    pt1y = gy-gw/2+v;
    pt2x = po2x-2*h;
    pt2y = gy+gw/2;
    pt30x = po3x+2*h;
    pt30y = gy-gw/2;
    pt31x = po2x;
    pt31y = gy+gw/2;
    pt32x = po3x;
    pt32y = gy+gw/2;
  }
  
}

class ta_scroll{
    private JFrame f; //Main frame
    private JTextArea ta; // Text area
    private JScrollPane sbrText; // Scroll pane for text area
    private JButton btnQuit; // Quit Program
    
    public ta_scroll(){ //Constructor
        // Create Frame
        f = new JFrame("Detail Names");
        //set the f frame position according to main frame
        f.setBounds(gX, gY+622, 845, 150);  
        f.removeNotify();f.setUndecorated(true); 
        
        JLabel label = new JLabel("Data Dimensions");
        Box box = Box.createVerticalBox();
        box.add(label);
        
        for(int i = 0; i< dimnames.length; ++i){
          JCheckBox  cbox = new JCheckBox(dimnames[i]);
          box.add(cbox);
          
          cbox.addActionListener(new ActionListener() {
              public void actionPerformed(ActionEvent e) {                
                  String tmp = e.getActionCommand();
                  int selDim = Integer.parseInt(tmp.substring(0, tmp.indexOf('_')).replace("d", ""));
                  dimList[numDims] = selDim;
                  numDims++;
              }
          });
          
          // data item selection
          ReadableAttribute dimi = data.getAttribute(i);
          int maxdim = (int)dimi.getRange().getMaximum();
          int mindim = (int)dimi.getRange().getMinimum();
          JSlider slider = new JSlider(mindim, maxdim, mindim+1);  
          if((maxdim - mindim) >= 10) slider.setMinorTickSpacing((maxdim - mindim)/10);
          else slider.setMinorTickSpacing(1);
          slider.setPaintTicks(true);
          // Set the labels to be painted on the slider
          slider.setPaintLabels(true);
          // Add positions label in the slider
          Hashtable<Integer, JLabel> position = new Hashtable<Integer, JLabel>();
          position.put(mindim, new JLabel(Integer.toString(mindim)));
          position.put(maxdim, new JLabel(Integer.toString(maxdim)));
          // Set the label to be drawn
          slider.setLabelTable(position);
          // Add change listener to the slider
          slider.addChangeListener(new ChangeListener() {
            public void stateChanged(ChangeEvent e) {
            }
          });
          
          box.add(slider);
        }
        
        JScrollPane jscrlpBox = new JScrollPane(box);
        jscrlpBox.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);    
        f.add(jscrlpBox);
        f.setVisible(true);
    }
    
    public void launchFrame(){ 
      
    }
} 