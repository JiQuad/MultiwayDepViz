/* 
* Multi-way dependencies Visualization
* Hoa Thanh Nguyen
*/

void detail_tet_in_glyph(float s, int d0, int d1, int d2, int d3, float cx, float cy, int pos) {
  selectedx = (mouseX-translateX)/scaleFactor;
  selectedy = (mouseY-translateY)/scaleFactor;
  selectedGlyph = 2;
  if (selectedx >= (cx-selv) && selectedx <= (cx+selv) && selectedy >= (cy-selv) && selectedy <= (cy+selv)) {
    if (selectedGlyph == 2 && mouseClick == 1) {
      dw.strokeWeight(1);
      dw.stroke(227, 0, 42);
      dw.fill(227, 0, 42);
      dw.line(po0x, po0y, po1x, po1y);
    
      dw.stroke(4, 8, 222);
      dw.fill(4, 8, 222);
      dw.line(po1x, po1y, po2x, po2y);
  
      dw.stroke(0, 60, 30);
      dw.fill(0, 60, 30);
      dw.line(po2x, po2y, po3x, po3y);
   
      dw.stroke(205, 0, 237);
      dw.fill(205, 0, 237);
      dw.line(po0x, po0y, po3x, po3y);
       
      int p = 20;
      draw_dimName(dimLabel[d0], po0x-p, po0y);
      
      draw_dimName(dimLabel[d1], po1x+p, po1y);
      draw_dimName(dimLabel[d2], po2x+p, po2y);
      draw_dimName(dimLabel[d3], po3x-p, po3y);
      
      draw_tet_untangle(d0, d1, d2, d3);
      
      draw_triangle_untangle(d0, d1, d2, pt0x, pt0y, pt1x, pt1y, pt2x, pt2y);
      draw_triangle_untangle(d0, d1, d3, pt0x, pt0y, pt1x, pt1y, pt30x, pt30y);
      draw_triangle_untangle(d1, d2, d3, pt1x, pt1y, pt2x, pt2y, pt31x, pt31y);
      draw_triangle_untangle(d0, d2, d3, pt0x, pt0y, pt2x, pt2y, pt32x, pt32y);
      
      draw_dimName(dimLabel[d0], pt0x-p, pt0y);
      draw_dimName(dimLabel[d1], pt1x+p, pt1y);
      draw_dimName(dimLabel[d2], pt2x, pt2y+p/2);
      draw_dimName(dimLabel[d3], pt30x, pt30y-p/2);
      draw_dimName(dimLabel[d3], pt31x+p, pt31y);   
      draw_dimName(dimLabel[d3], pt32x-p, pt32y);
          
      mouseClick = 2;
      dw.redraw();
      
      // draw actual dim names
      float dis = 20;
      dw.strokeWeight(1);
      dw.stroke(0);
      dw.noFill();
      dw.rect(3, po3y + 1.5*dis, 13*dis + 12, height);
      
      dw.fill(0);
      dw.textAlign(LEFT);
      dw.text(dimLabel[d0], dis - 5, po3y + 2*dis, 13*dis, 9*dis);
      dw.text(dimLabel[d1], dis - 5, po3y + 6*dis, 13*dis, 9*dis);
      dw.text(dimLabel[d2], dis - 5, po3y+ 10*dis, 13*dis, 9*dis);
      dw.text(dimLabel[d3], dis - 5, po3y+ 14*dis, 13*dis, 9*dis);
    }
    
  }
}

void draw_points_untan_triangle_in_tet(float ax, float ay, float bx, float by, float cx, float cy, float t1, float t2, float t3, int col) { 
  float maxt = 10*max(t1,t2);
  float x = t1*ax + t2*bx + t3*cx;
  float y = t1*ay + t2*by + t3*cy;  
  dw.noStroke();
  
  if (col == 0) 
    dw_red_hue(maxt);
  else if (col == 1) 
    dw_blue_hue(maxt);
  else if (col == 2)
    dw_green_hue(maxt);
  else if (col == 3)
    dw_pink_hue(maxt);
   
   
  dw.ellipse(x, y, 5, 5); 
}

void draw_tet_untangle(int d0, int d1, int d2, int d3) {
  
  for (int i = 0; i < elemCount; i++) {
    float p0 = post_prob[i][d0];
    float p1 = post_prob[i][d1];
    float p2 = post_prob[i][d2];
    float p3 = post_prob[i][d3];   
    float sum = p0+p1+p2+p3;
    p0 /= sum;
    p1 /= sum;
    p2 /= sum;
    p3 /= sum;

    if (p0 == 1) {
      dw.stroke(227, 0, 42);
      dw.fill(227, 0, 42);
      dw.ellipse(po0x, po0y, 5, 5); 
    } else if (p1 == 1) {
      dw.stroke(4, 8, 222);
      dw.fill(4, 8, 222);
      dw.ellipse(po1x, po1y, 5, 5); 
    } else if (p2 == 1){
      dw.stroke(0, 60, 30);
      dw.fill(0, 60, 30);
      dw.ellipse(po2x, po2y, 5, 5); 
    } else if (p3 == 1){
      dw.stroke(205, 0, 237);
      dw.fill(205, 0, 237);
      dw.ellipse(po3x, po3y, 5, 5); 
    }
    else {
      draw_points_untan_triangle_in_tet(po3x, po3y, po0x, po0y, po1x, (po1y+po2y)/2, p3, p0, (1-p3-p0),3);
      draw_points_untan_triangle_in_tet(po2x, po2y, po3x, po3y, (po0x+po1x)/2,po0y, p2, p3, (1-p2-p3),2);
      draw_points_untan_triangle_in_tet(po1x, po1y, po2x, po2y, po0x, (po1y+po2y)/2, p1, p2, (1-p1-p2),1);
      draw_points_untan_triangle_in_tet(po0x, po0y, po1x, po1y, (po0x+po1x)/2,po2y, p0, p1, (1-p0-p1),0);
    }
  }
}

void draw_triangle_untangle(int a, int b, int c, float ax, float ay, float bx, float by, float cx, float cy) {
  dw.stroke(200);
  dw.noFill();
  dw.triangle(ax, ay, bx, by, cx, cy);
  for (int i = 0; i < elemCount; i++) {
    float p1 = post_prob[i][a];
    float p2 = post_prob[i][b];
    float p3 = post_prob[i][c];                  
    draw_points_triangle_untangle(ax, ay, bx, by, cx, cy, p1/(p1+p2+p3), p2/(p1+p2+p3), p3/(p1+p2+p3));
  }
}

void draw_points_triangle_untangle(float ax, float ay, float bx, float by, float cx, float cy, float t1, float t2, float t3) { 
  float px = t1*ax + t2*bx + t3*cx;
  float py = t1*ay + t2*by + t3*cy;  
  dw.noStroke();
  dw.fill(0, 100, 200, 100);
  dw.ellipse(px, py, 5, 5);
}


void detail_tri(float s, int d0, int d1, int d2, float cx, float cy) {
  if (selectedGlyph == 1) {
    selectedx = (mouseX-translateX)/scaleFactor;
    selectedy = (mouseY-translateY)/scaleFactor;
    if (selectedx >= (cx-selv) && selectedx <= (cx+selv) && selectedy >= (cy-selv) && selectedy <= (cy+selv))
      selectedGlyph = 2;
  }
  if (selectedx >= (cx-selv) && selectedx <= (cx+selv) && selectedy >= (cy-selv) && selectedy <= (cy+selv)) {
    if (selectedGlyph == 2) {
      double r1, r2, r3;
      r1= R2_triangle(d0, d1, d2);
      if (r1 > lower_threshold && r1 < upper_threshold) {
        dw_blue_hue_stroke(12);
        dw.strokeWeight(2);
        draw_symb_tri(s, po0x, po0y);
        dw_blue_hue(10);
        dw.triangle(po0x, po0y, p2x, p2y, p1x, p1y);
      }
      r2= R2_triangle(d1, d0, d2);
      if (r2 > lower_threshold && r2 < upper_threshold) {
        dw_blue_hue_stroke(12);
        dw.strokeWeight(2);
        draw_symb_tri(s, po1x, po1y);
        dw_blue_hue(10);
        dw.triangle(po1x, po1y, p2x, p2y, p0x, p0y);
      }
      r3= R2_triangle(d2, d1, d0);
      if (r3 > lower_threshold && r3 < upper_threshold) {
        dw_blue_hue_stroke(12);
        dw.strokeWeight(2);
        draw_symb_tri(s, po2x, po2y);
        dw_blue_hue(10);
        dw.triangle(po2x, po2y, p1x, p1y, p0x, p0y);
      }
      if (r1!=0 || r2!=0 || r3!=0) {
        draw_dimName(dimLabel[d0], po0x+30, po0y);
        draw_dimName(dimLabel[d1], po1x-30, po1y);
        draw_dimName(dimLabel[d2], po2x-30, po2y);

        draw_dimName(dimLabel[d0], p0x-30, p0y);
        draw_dimName(dimLabel[d1], p1x+30, p1y);
        draw_dimName(dimLabel[d2], p2x+30, p2y);
      }
    }
  }
}


void draw_dimName(String dimName, float x, float y) {
  dw.stroke(0);
  dw.strokeWeight(1);
  dw.fill(255);
  dw.ellipse(x, y, fon*2, fon*1.5);
  dw.fill(0);
  dw.textAlign(CENTER);
  dw.text(dimName, x, y+5);
}

void draw_symb_tri(float s, float x, float y) {
  dw_blue_hue_stroke(12);
  dw_blue_hue(s);
  dw.triangle(x-5, y+3, x, y-5, x+5, y+3);
}

void draw_symb_tet(float s, float x, float y, int col) {
  if (col == 0) {
    dw.stroke(200, 0, 0);
    dw.fill(200, 0, 0);
  } else if (col == 1) {
    dw.stroke(200, 200, 0);
    dw.fill(200, 200, 0);
  } else if (col == 2){
    dw.stroke(0, 100, 200);
    dw.fill(0, 100, 200);
  } else if (col == 3){
    dw.stroke(0, 200, 200);
    dw.fill(0, 200, 200);
  }
  else {
    dw.stroke(60, 60, 60);
    dw.fill(60, 60, 60);
  }
  
  dw.rect(x-5, y-5, 10, 10);
}

void dw_blue_hue_stroke(float sco) {
  int alp = 200;  
  if (sco == 0)
    dw.stroke(255, 255, 255, alp);
  else if (sco>0&&sco<=1)
    dw.stroke(252, 251, 253, alp);
  else if (sco>1&&sco<=2)
    dw.stroke(239, 237, 245, alp);
  else if (sco>2&&sco<=3)
    dw.stroke(239, 237, 245, alp);
  else if (sco>3&&sco<=4)
    dw.stroke(218, 218, 235, alp);
  else if (sco>4&&sco<=5)
    dw.stroke(218, 218, 235, alp);
  else if (sco>5&&sco<=6)
    dw.stroke(188, 189, 220, alp);
  else if (sco>6&&sco<=7)
    dw.stroke(188, 189, 220, alp);
  else if (sco>7&&sco<=8)
    dw.stroke(158, 154, 200, alp);
  else if (sco>8&&sco<=9)
    dw.stroke(158, 154, 200, alp);
  else if (sco>9&&sco<=10)
    dw.stroke(128, 125, 186, alp);
  else if (sco>10&&sco<=11)
    dw.stroke(106, 81, 163, alp);
  else
    dw.stroke(84, 39, 143, alp);
}

void dw_red_hue_stroke(float sco) {
  int alp = 100;
  if (sco == 0)
    dw.stroke(255, 255, 255, alp);
  else if (sco>0&&sco<=1)
    dw.stroke(255, 245, 235, alp);
  else if (sco>1&&sco<=2)
    dw.stroke(254, 230, 206, alp);
  else if (sco>2&&sco<=3)
    dw.stroke(253, 208, 162, alp);
  else if (sco>3&&sco<=4)
    dw.stroke(253, 174, 107, alp);
  else if (sco>4&&sco<=5)
    dw.stroke(253, 141, 60, alp);
  else
    dw.stroke(241, 105, 19, alp);
}

void dw_green_hue_stroke(float sco) {
  int alp = 180;
  if (sco == 0)
    dw.stroke(255, 255, 255, alp);
  else if (sco>0&&sco<=1)
    dw.stroke(107, 174, 214, alp);
  else if (sco>1&&sco<=2)
    dw.stroke(66, 146, 198, alp);
  else if (sco>2&&sco<=3)
    dw.stroke(33, 113, 181, alp);
  else
    dw.stroke( 66, 146, 198, alp);
}

void dw_blue_hue(float sco) {
  int alp = 220;
  if (sco == 0)
    dw.fill(255, 255, 255, alp);
  else if (sco>0&&sco<=1)
    dw.fill(200, 200, 222, alp);
  else if (sco>1&&sco<=2)
    dw.fill(180, 180, 222, alp);
  else if (sco>2&&sco<=3)
    dw.fill(150, 154, 222, alp);
  else if (sco>3&&sco<=4)
    dw.fill(130, 134, 222, alp);
  else if (sco>4&&sco<=5)
    dw.fill(100, 104, 222, alp);
  else if (sco>5&&sco<=6)
    dw.fill(70, 74, 222, alp);
  else if (sco>6&&sco<=7)
    dw.fill(60, 64, 222, alp);
  else if (sco>7&&sco<=8)
    dw.fill(50, 55, 222, alp);
  else if (sco>8&&sco<=9)
    dw.fill(40, 44, 222, alp);
  else if (sco>9&&sco<=10)
    dw.fill(28, 31, 222, alp);
  else if (sco>10&&sco<=11)
    dw.fill(18, 22, 222, alp);
  else
    dw.fill(4, 8, 222, alp);
}

void dw_red_hue(float sco) {
  int alp = 250;
  if (sco == 0)
    dw.fill(255, 255, 255, alp);
  else if (sco>0&&sco<=1)
    dw.fill(255, 245, 235, alp);
  else if (sco>1&&sco<=2)
    dw.fill(254, 230, 206, alp);
  else if (sco>2&&sco<=3)
    dw.fill(253, 208, 162, alp);
  else if (sco>3&&sco<=4)
    dw.fill(253, 174, 107, alp);
  else if (sco>4&&sco<=5)
    dw.fill(253, 141, 60, alp);
  else if (sco>5&&sco<=6)
    dw.fill(227, 93, 117, alp);
  else if (sco>6&&sco<=7)
    dw.fill(227, 70, 98, alp);
  else if (sco>7&&sco<=8)
    dw.fill(227, 55, 87, alp);
  else if (sco>8&&sco<=9)
    dw.fill(227, 41, 75, alp);
  else if (sco>9&&sco<=10)
    dw.fill(227, 20, 58, alp);
  else if (sco>10&&sco<=11)
    dw.fill(227, 81, 163, alp);
  else
    dw.fill(227, 0, 42, alp);
}

void dw_green_hue(float sco) {
  int alp = 220;
  if (sco == 0)
    dw.fill(255, 255, 255, alp);
  else if (sco>0&&sco<=1)
    dw.fill(190, 240, 220, alp);
  else if (sco>1&&sco<=2)
    dw.fill(180, 230, 210, alp);
  else if (sco>2&&sco<=3)
    dw.fill(170, 220, 200, alp);
  else if (sco>3&&sco<=4)
    dw.fill(150, 210, 180, alp);
  else if (sco>4&&sco<=5)
    dw.fill(130, 210, 160, alp);
  else if (sco>5&&sco<=6)
    dw.fill(110, 200, 140, alp);
  else if (sco>6&&sco<=7)
    dw.fill(90, 190, 120, alp);
  else if (sco>7&&sco<=8)
    dw.fill(70, 180, 100, alp);
  else if (sco>8&&sco<=9)
    dw.fill(50, 170, 80, alp);
  else if (sco>9&&sco<=10)
    dw.fill(30, 100, 60, alp);
  else if (sco>10&&sco<=11)
    dw.fill(10, 80, 40, alp);
  else
    dw.fill(0, 60, 30, alp);
}

void dw_pink_hue(float sco) {
  int alp = 240;
  if (sco == 0)
    dw.fill(255, 255, 255, alp);
  else if (sco>0&&sco<=1)
    dw.fill(220, 200, 237, alp);
  else if (sco>1&&sco<=2)
    dw.fill(215, 180, 237, alp);
  else if (sco>2&&sco<=3)
    dw.fill(210, 150, 237, alp);
  else if (sco>3&&sco<=4)
    dw.fill(205, 130, 237, alp);
  else if (sco>4&&sco<=5)
    dw.fill(205, 110, 237, alp);
  else if (sco>5&&sco<=6)
    dw.fill(205, 93, 237, alp);
  else if (sco>6&&sco<=7)
    dw.fill(205, 70, 237, alp);
  else if (sco>7&&sco<=8)
    dw.fill(205, 55, 237, alp);
  else if (sco>8&&sco<=9)
    dw.fill(205, 41, 237, alp);
  else if (sco>9&&sco<=10)
    dw.fill(205, 20, 237, alp);
  else if (sco>10&&sco<=11)
    dw.fill(205, 10, 237, alp);
  else
    dw.fill(205, 0, 237, alp);
}

void dw_yellow_hue(float sco) {
  int alp = 220;
  if (sco == 0)
    dw.fill(255, 255, 255, alp);
  else if (sco>0&&sco<=1)
    dw.fill(237, 190, 150, alp);
  else if (sco>1&&sco<=2)
    dw.fill(237, 190, 140, alp);
  else if (sco>2&&sco<=3)
    dw.fill(237, 190, 130, alp);
  else if (sco>3&&sco<=4)
    dw.fill(237, 190, 120, alp);
  else if (sco>4&&sco<=5)
    dw.fill(237, 190, 110, alp);
  else if (sco>5&&sco<=6)
    dw.fill(237, 190, 90, alp);
  else if (sco>6&&sco<=7)
    dw.fill(237, 190, 70, alp);
  else if (sco>7&&sco<=8)
    dw.fill(237, 190, 50, alp);
  else if (sco>8&&sco<=9)
    dw.fill(237, 190, 30, alp);
  else if (sco>9&&sco<=10)
    dw.fill(237, 190, 20, alp);
  else if (sco>10&&sco<=11)
    dw.fill(237, 190, 10, alp);
  else
    dw.fill(237, 190, 0, alp);
}