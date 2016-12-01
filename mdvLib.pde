/* 
* Multi-dependencies Visualization
* Hoa Nguyen 
*/

void draw_glyphs(int d0,int d1,int d2,int d3,float cx, float cy){
  if(scaleFactor > detailThres){
    detail_tet_in_glyph_inov(d0, d1, d2, d3, cx, cy);
    //draw_points_glyph(d0, d1, d2, d3, cx, cy);
    draw_over_glyph(d0, d1, d2, d3, cx, cy);
  }
  else
    draw_over_glyph(d0, d1, d2, d3, cx, cy);    
}

void move_edges(int i0, int i1, int i2, int i3, float cx, float cy){
  edge_move(i0,i1,cx,cy);
  edge_move(i0,i2,cx,cy);
  edge_move(i0,i3,cx,cy);
  edge_move(i1,i2,cx,cy);
  edge_move(i1,i3,cx,cy);
  edge_move(i2,i3,cx,cy);
}

void move_edges_to_tet(int i0, int i1, int i2, int i3, double sc0, double sc1, double sc2, double sc3, float cx, float cy){
  edge_move_to_tet(i0,i1,i2,i3,sc0,sc1,sc2,sc3,cx,cy);
  edge_move_to_tet(i0,i2,i1,i3,sc0,sc1,sc2,sc3,cx,cy);
  edge_move_to_tet(i0,i3,i1,i2,sc0,sc1,sc2,sc3,cx,cy);
  edge_move_to_tet(i1,i2,i0,i3,sc0,sc1,sc2,sc3,cx,cy);
  edge_move_to_tet(i1,i3,i0,i2,sc0,sc1,sc2,sc3,cx,cy);
  edge_move_to_tet(i2,i3,i0,i1,sc0,sc1,sc2,sc3,cx,cy);
}

void move_tets_to_edges(int i0, int i1, int i2, int i3, float cx, float cy, double sc){
  tet_move_to_edge(i0,i1,i2,i3,cx,cy,sc);
  tet_move_to_edge(i0,i2,i1,i3,cx,cy,sc);
  tet_move_to_edge(i0,i3,i1,i2,cx,cy,sc);
  tet_move_to_edge(i1,i2,i0,i3,cx,cy,sc);
  tet_move_to_edge(i1,i3,i0,i2,cx,cy,sc);
  tet_move_to_edge(i2,i3,i0,i1,cx,cy,sc);
}

void move_tri_to_edges(int i0, int i1, int i2){
  tri_move_to_edge(i0,i1,i2,i1);
  tri_move_to_edge(i0,i2,i1,i1);
  tri_move_to_edge(i1,i2,i0,i1);
}


void move_edges_to_tri(int i0, int i1, int i2, double sc0, double sc1, double sc2, float cx, float cy){
  edge_move_to_tri(i0,i1,i2,sc0,sc1,sc2,cx,cy);
  edge_move_to_tri(i0,i2,i1,sc0,sc1,sc2,cx,cy);
  edge_move_to_tri(i1,i2,i0,sc0,sc1,sc2,cx,cy);
}

void move_triangles(int i0, int i1, int i2, int i3, float cx, float cy, double sc0, double sc1, double sc2, double sc3){
  triangle_move(i0,i1,i2,cx,cy,(float)sc0,(float)sc1,(float)sc2, i1);
  triangle_move(i0,i2,i3,cx,cy,(float)sc0,(float)sc2,(float)sc3, i1);
  triangle_move(i1,i2,i3,cx,cy,(float)sc0,(float)sc2,(float)sc3, i1);
}

void move_in_triangles(int d0, int d1, int d2, float ccx, float ccy, double ssc0, double ssc1, double ssc2, double ssc3, double ssc){
  double sc0 = R2_triangle(d0, d1, d2);        
  double sc1 = R2_triangle(d1, d0, d2);
  double sc2 = R2_triangle(d2, d1, d0);
  float cx, cy;
  
  sc = sca(Xaxis, 3, sc0, sc1, sc2, 0);
  if(Yaxis == 4)
    cx = Xstart+gap*(d0+2*d1+d2);
  else
    cx = Xend - ((float)sca(Yaxis, 3, sc0, sc1, sc2, 0)-r2min)*(Xend-Xstart)/(r2max-r2min);                            
  cy = Yend - ((float)sc-r2min)*(Yend-Ystart)/(r2max-r2min); 
  if(fullRel == 0)
    draw_overview_tri(d0,d1,d2, ccx + step*(cx-ccx)/nstep, ccy+step*(cy-ccy)/nstep, sc);
    
  else{
    if(oldMeth == 7)
      draw_full_move_tri(d0,d1,d2,ccx, cx, step, ssc, ssc, ssc,  sc0,sc1,sc2);
    else
      draw_full_move_tri(d0,d1,d2,ccx, cx, step, ssc0, ssc1, ssc2, sc0,sc1,sc2);
  }
}

void move_tets(int i0, int i1, int i2, int i3, float cx, float cy, double sc0, double sc1, double sc2, double sc3){
  tet_move(i0,i1,i2,i3,cx,cy,(float)sc0,(float)sc1,(float)sc2,(float)sc3);
}

void edge_move(int i, int j, float cx, float cy){
  double pc = pcc[i][j];
  double ssc = pc*pc;
  float ccx, ccy;
  if(Yaxis == 4)
    ccx = Xstart+gap*(i+2.9*j);
  else
    ccx = Xend - ((float)ssc-r2min)*(Xend-Xstart)/(r2max-r2min);
  
  ccy = Yend - ((float)ssc-r2min)*(Yend-Ystart)/(r2max-r2min);
  if(ssc > lower_threshold && ssc < upper_threshold){  
    if(step < nstep){ 
      draw_overview_edge(i,j,ccx + step*(cx-ccx)/nstep, ccy+step*(cy-ccy)/nstep, ssc);
      step += 1;
    }
  }   
}

void triangle_move(int d0, int d1, int d2, float cx, float cy, float sc0, float sc1, float sc2, int ad){
  double ssc0 = R2_triangle(d0, d1, d2);        
  double ssc1 = R2_triangle(d1, d0, d2);
  double ssc2 = R2_triangle(d2, d1, d0);
  float ccx, ccy;
  
  double ssc = sca(Xaxis, 3, ssc0, ssc1, ssc2, 0);
  if(Yaxis == 4)
    ccx =Xstart+gap*(d0+d1+d2+ad);
  else
    ccx = Xend - ((float)sca(Yaxis, 3, ssc0, ssc1, ssc2, 0)-r2min)*(Xend-Xstart)/(r2max-r2min);
    
  ccy = Yend - ((float)ssc-r2min)*(Yend-Ystart)/(r2max-r2min);         
  
  if(ssc > lower_threshold && ssc < upper_threshold){
    if(step < nstep){
      if(fullRel == 0)   
        draw_overview_tri(d0,d1,d2, ccx + step*(cx-ccx)/nstep, ccy+step*(cy-ccy)/nstep, ssc);
      else
        draw_full_move_tri(d0,d1,d2,ccx, cx, step, ssc0, ssc1, ssc2, sc0,sc1,sc2);
  
      step += 1;
    }
  }
}

void tet_move(int d0, int d1, int d2, int d3, float cx, float cy, float sc0, float sc1, float sc2, float sc3){
  double ssc0 = R2_tet(d0, d1, d2, d3);        
  double ssc1 = R2_tet(d1, d0, d2, d3);
  double ssc2 = R2_tet(d2, d1, d0, d3);
  double ssc3 = R2_tet(d3, d1, d2, d0);
  double ssc = sca(Xaxis, 4, ssc0, ssc1, ssc2, ssc3);
  float ccx, ccy;
  
  if(Yaxis == 4)
    ccx = Xstart+gap*(d0+d1+d2+d3);
  else
    ccx = Xend - ((float)sca(Yaxis, 4, ssc0, ssc1, ssc2, ssc3)-r2min)*(Xend-Xstart)/(r2max-r2min);
  
  ccy = Yend -  ((float)ssc-r2min)*(Yend-Ystart)/(r2max-r2min);           
  if(ssc > lower_threshold && ssc < upper_threshold){
    if(step < nstep){
      if(fullRel == 0)   
        draw_overview_tet(d0,d1,d2,d3,ccx + step*(cx-ccx)/nstep, ccy+step*(cy-ccy)/nstep, ssc);
      else
         draw_full_move_tet(d0,d1,d2,d3,ccx, cx, step,ssc0, ssc1, ssc2, ssc3,sc0,sc1,sc2,sc3);
  
      step += 1;
    }
  }
}

void edge_move_to_tet(int d0, int d1, int d2, int d3, double sc0, double sc1, double sc2, double sc3, float cx, float cy){
  double pc = pcc[d0][d1];
  double ssc = pc*pc;
  float ccx2, ccy2;
  if(Yaxis == 4)
    ccx2 = Xstart+gap*(d0+2.9*d1);
  else
    ccx2 = Xend - ((float)ssc-r2min)*(Xend-Xstart)/(r2max-r2min);
  
  ccy2 = Yend - ((float)ssc-r2min)*(Yend-Ystart)/(r2max-r2min);    
  if(step < nstep){ 
    if(fullRel == 0)
      draw_overview_edge(d0,d1,ccx2 + step*(cx-ccx2)/nstep, ccy2+step*(cy-ccy2)/nstep, ssc);
    else{
      float x0 = cx;
      float x1 = cx;
      float x2 = cx;
      float x3 = cx;
      float y0 = Yend - ((float)sc0-r2min)*(Yend-Ystart)/(r2max-r2min);
      float y1 = Yend - ((float)sc1-r2min)*(Yend-Ystart)/(r2max-r2min);
      float y2 = Yend - ((float)sc2-r2min)*(Yend-Ystart)/(r2max-r2min);
      float y3 = Yend - ((float)sc3-r2min)*(Yend-Ystart)/(r2max-r2min);
      draw_overview_edge(d0,d1,ccx2 + step*(x0-ccx2)/nstep, ccy2+step*(y0-ccy2)/nstep, ssc);
      draw_overview_edge(d1,d2,ccx2 + step*(x1-ccx2)/nstep, ccy2+step*(y1-ccy2)/nstep, ssc);
      draw_overview_edge(d2,d3,ccx2 + step*(x2-ccx2)/nstep, ccy2+step*(y2-ccy2)/nstep, ssc);
      draw_overview_edge(d3,d0,ccx2 + step*(x3-ccx2)/nstep, ccy2+step*(y3-ccy2)/nstep, ssc);
    }
    step += 1;
  }
}

void tet_move_to_edge(int d0, int d1, int d2, int d3, float cx, float cy, double sc){
  double ssc0 = R2_tet(d0, d1, d2, d3);        
  double ssc1 = R2_tet(d1, d0, d2, d3);
  double ssc2 = R2_tet(d2, d1, d0, d3);
  double ssc3 = R2_tet(d3, d1, d2, d0);
  float ccx, ccy;
  double ssc = sca(Xaxis, 4, ssc0, ssc1, ssc2, ssc3);
  
  if(Yaxis == 4)
    ccx = Xstart+gap*(d0+d1+d2+d3);
  else
    ccx = Xend - ((float)sca(Yaxis, 4, ssc0, ssc1, ssc2, ssc3)-r2min)*(Xend-Xstart)/(r2max-r2min);
  
  ccy = Yend -  ((float)ssc-r2min)*(Yend-Ystart)/(r2max-r2min);    
  
  double pc = pcc[d0][d1];
  double s = pc*pc;
  float ccx2, ccy2;
  
  if(Yaxis == 4)
    ccx2 = Xstart+gap*(d0+2.9*d1);
  else
    ccx2 = Xend - ((float)s-r2min)*(Xend-Xstart)/(r2max-r2min);
  
  ccy2 = Yend -((float)s-r2min)*(Yend-Ystart)/(r2max-r2min);  

  if(ssc > lower_threshold && ssc < upper_threshold){  
    if(step < nstep){ 
      if(fullRel == 0 || oldMeth == 7)
        draw_overview_edge(d0,d1,ccx + step*(ccx2-ccx)/nstep, ccy+step*(ccy2-ccy)/nstep, ssc);
      else{
        float x0 = ccx;
        float x1 = ccx;
        float x2 = ccx;
        float x3 = ccx;
        float y0 = Yend - ((float)ssc0-r2min)*(Yend-Ystart)/(r2max-r2min);
        float y1 = Yend - ((float)ssc1-r2min)*(Yend-Ystart)/(r2max-r2min);
        float y2 = Yend - ((float)ssc2-r2min)*(Yend-Ystart)/(r2max-r2min);        
        float y3 = Yend - ((float)ssc3-r2min)*(Yend-Ystart)/(r2max-r2min);
        draw_overview_edge(d0,d1,x0 + step*(ccx2-x0)/nstep, y0+step*(ccy2-y0)/nstep, ssc);
        draw_overview_edge(d1,d2,x1 + step*(ccx2-x1)/nstep, y1+step*(ccy2-y1)/nstep, ssc);
        draw_overview_edge(d2,d3,x2 + step*(ccx2-x2)/nstep, y2+step*(ccy2-y2)/nstep, ssc); 
        draw_overview_edge(d3,d0,x3 + step*(ccx2-x3)/nstep, y3+step*(ccy2-y3)/nstep, ssc);   
      }
      step += 1;
    }
  }
}

void tri_move_to_edge(int d0, int d1, int d2, int ad){
  double ssc0 = R2_triangle(d0, d1, d2);        
  double ssc1 = R2_triangle(d1, d0, d2);
  double ssc2 = R2_triangle(d2, d1, d0);
  float ccx, ccy;  
  double ssc = sca(Xaxis, 3, ssc0, ssc1, ssc2, 0);
  if(Yaxis == 4)
    ccx =Xstart+gap*(d0+d1+d2+ad);
  else
    ccx = Xend - (float)sca(Yaxis, 3, ssc0, ssc1, ssc2, 0)*(Xend-Xstart);
    
  ccy = Yend - (float)ssc*(Yend-Ystart);  
  double pc = pcc[d0][d1];
  double s = pc*pc;
  float ccx2, ccy2;
  
  if(Yaxis == 4)
    ccx2 =Xstart+gap*(d0+2.9*d1);
  else
    ccx2 = Xend - ((float)s-r2min)*(Xend-Xstart)/(r2max-r2min);
  
  ccy2 = Yend - ((float)s-r2min)*(Yend-Ystart)/(r2max-r2min);  

  if(s > lower_threshold && s < upper_threshold){  
    if(step < nstep){ 
      if(fullRel == 0)
        draw_overview_edge(d0,d1,ccx + step*(ccx2-ccx)/nstep, ccy+step*(ccy2-ccy)/nstep, s);
      else{
        float x0 = ccx;
        float x1 = ccx;
        float x2 = ccx;
        float y0 = Yend - ((float)ssc0-r2min)*(Yend-Ystart)/(r2max-r2min);
        float y1 = Yend - ((float)ssc1-r2min)*(Yend-Ystart)/(r2max-r2min);
        float y2 = Yend - ((float)ssc2-r2min)*(Yend-Ystart)/(r2max-r2min);
        draw_overview_edge(d0,d1,x0 + step*(ccx2-x0)/nstep, y0+step*(ccy2-y0)/nstep, s);
        draw_overview_edge(d1,d2,x1 + step*(ccx2-x1)/nstep, y1+step*(ccy2-y1)/nstep, s);
        draw_overview_edge(d0,d2,x2 + step*(ccx2-x2)/nstep, y2+step*(ccy2-y2)/nstep, s);        
      }
      step += 1;
    }
  }
}


void edge_move_to_tri(int d0, int d1, int d2, double sc0, double sc1, double sc2, float cx, float cy){
  double pc = pcc[d0][d1];
  double ssc = pc*pc;
  float ccx2, ccy2;
  
  if(Yaxis == 4)
    ccx2 =Xstart+gap*(d0+2.9*d1);
  else
    ccx2 = Xend - ((float)ssc-r2min)*(Xend-Xstart)/(r2max-r2min);
  
  ccy2 = Yend -  ((float)ssc-r2min)*(Yend-Ystart)/(r2max-r2min);    
  if(step < nstep){ 
    if(fullRel == 0)
      draw_overview_edge(d0,d1,ccx2 + step*(cx-ccx2)/nstep, ccy2+step*(cy-ccy2)/nstep, ssc);
    else{
      float x0 = cx;
      float x1 = cx;
      float x2 = cx;
      float y0 = Yend - ((float)sc0-r2min)*(Yend-Ystart)/(r2max-r2min);
      float y1 = Yend - ((float)sc1-r2min)*(Yend-Ystart)/(r2max-r2min);
      float y2 = Yend - ((float)sc2-r2min)*(Yend-Ystart)/(r2max-r2min);
      draw_overview_edge(d0,d1,ccx2 + step*(x0-ccx2)/nstep, ccy2+step*(y0-ccy2)/nstep, ssc);
      draw_overview_edge(d1,d2,ccx2 + step*(x1-ccx2)/nstep, ccy2+step*(y1-ccy2)/nstep, ssc);
      draw_overview_edge(d2,d0,ccx2 + step*(x2-ccx2)/nstep, ccy2+step*(y2-ccy2)/nstep, ssc);
    }
    step += 1;
  }  
}
void draw_overview_tet(int d0, int d1, int d2, int d3,float x, float y, double s){
  if(s > lower_threshold && s < upper_threshold){
    double score_tet;
    score_tet = inThreshold(R2_tet(d0, d1, d2, d3))+inThreshold(R2_tet(d1, d0, d2, d3))+inThreshold(R2_tet(d2, d1, d0, d3))+inThreshold(R2_tet(d3, d1, d2, d0));
    if(scaleFactor == 1 || numData > 10){
      noStroke();
      green_hue((float)score_tet);
      rect(x-rad_tets/2, y-1.8*rad_tets/3, rad_tets, rad_tets);
    
      if(R2_tet(d0, d1, d2, d3) > lower_threshold && R2_tet(d0, d1, d2, d3) < upper_threshold)
        detail_tet_in_glyph((float)R2_tet(d0, d1, d2, d3),d0,d1,d2,d3,x,y,0);
    }
    else{
      detail_tet_in_glyph_inov(d0,d1,d2,d3,x,y);
    }
  }
}

void draw_overview_tri(int d0, int d1, int d2,float x, float y, double s){
  if(s > lower_threshold && s < upper_threshold){
    noStroke();
    blue_hue(11);
    triangle(x-rad_edges*sin(PI/3), y + rad_edges*sin(PI/6), x, y-rad_edges, x+rad_edges*sin(PI/3), y+ rad_edges*sin(PI/6));
    detail_tri((float)s,d0,d1,d2,x,y);
  } 
}

void draw_overview_edge(int d0, int d1, float x, float y, double s){
  if(s > lower_threshold && s < upper_threshold){
    noStroke();
    red_hue(6);
    ellipse(x, y, rad_edges, rad_edges);
  }
}

void draw_full_tet(int d0, int d1,int d2, int d3, float x, double sc0, double sc1, double sc2, double sc3){
  draw_overview_tet(d0,d1,d2,d3,x, Yend - ((float)sc0-r2min)*(Yend-Ystart)/(r2max-r2min), sc0);
}

void draw_full_tri(int d0, int d1,int d2, float x, double sc0, double sc1, double sc2){
  draw_overview_tri(d0, d1, d2, x, Yend - ((float)sc0-r2min)*(Yend-Ystart)/(r2max-r2min), sc0); 
  draw_overview_tri(d1, d0, d2, x, Yend - ((float)sc1-r2min)*(Yend-Ystart)/(r2max-r2min), sc1);
  draw_overview_tri(d2, d1, d0, x, Yend - ((float)sc2-r2min)*(Yend-Ystart)/(r2max-r2min), sc2); 
}

void draw_full_move_tet(int d0, int d1,int d2, int d3, float x, float xc, int st, double sc0, double sc1, double sc2, double sc3, double s0, double s1, double s2, double s3){
  float x0 = x;
  float x1 = x;
  float x2 = x;
  float x3 = x;
  float y0 = Yend - ((float)sc0-r2min)*(Yend-Ystart)/(r2max-r2min);
  float y1 = Yend - ((float)sc1-r2min)*(Yend-Ystart)/(r2max-r2min);
  float y2 = Yend - ((float)sc2-r2min)*(Yend-Ystart)/(r2max-r2min);
  float y3 = Yend - ((float)sc3-r2min)*(Yend-Ystart)/(r2max-r2min);
  
  float xc0 = xc;
  float xc1 = xc;
  float xc2 = xc;
  float xc3 = xc;
  
  float yc0 = Yend - ((float)s0-r2min)*(Yend-Ystart)/(r2max-r2min);
  float yc1 = Yend - ((float)s1-r2min)*(Yend-Ystart)/(r2max-r2min);
  float yc2 = Yend - ((float)s2-r2min)*(Yend-Ystart)/(r2max-r2min);
  float yc3 = Yend - ((float)s3-r2min)*(Yend-Ystart)/(r2max-r2min);
  
  draw_overview_tet(d0,d1,d2,d3,x0 + st*(xc0-x0)/nstep, y0+st*(yc0-y0)/nstep, sc0);
}

void draw_full_move_tri(int d0, int d1,int d2, float x, float xc, int st, double sc0, double sc1, double sc2, double s0, double s1, double s2){
  float x0 = x;
  float x1 = x;
  float x2 = x;  
  float y0 = Yend - ((float)sc0-r2min)*(Yend-Ystart)/(r2max-r2min);
  float y1 = Yend - ((float)sc1-r2min)*(Yend-Ystart)/(r2max-r2min);
  float y2 = Yend - ((float)sc2-r2min)*(Yend-Ystart)/(r2max-r2min);
  
  float xc0 = xc;
  float xc1 = xc;
  float xc2 = xc;
  
  float yc0 = Yend - ((float)s0-r2min)*(Yend-Ystart)/(r2max-r2min);
  float yc1 = Yend - ((float)s1-r2min)*(Yend-Ystart)/(r2max-r2min);
  float yc2 = Yend - ((float)s2-r2min)*(Yend-Ystart)/(r2max-r2min);
  
  draw_overview_tri(d0,d1,d2,x0 + st*(xc0-x0)/nstep, y0+st*(yc0-y0)/nstep, sc0);
  draw_overview_tri(d1,d0,d2,x1 + st*(xc1-x1)/nstep, y1+st*(yc1-y1)/nstep, sc1);
  draw_overview_tri(d2,d1,d0,x2 + st*(xc2-x2)/nstep, y2+st*(yc2-y2)/nstep, sc2);
}

double sca(int axi, int rel, double sc0, double sc1, double sc2, double sc3){
  double s = 0;
  //R2 min Axis
  if(axi == 1){
    s = 2;
    if(s >= sc0)
      s = sc0;
    if(s >= sc1)
      s = sc1;
    if(s >= sc2)
      s = sc2;
    if(rel == 4)  
      if(s >= sc3)
        s = sc3;
  }
  // R2 max Axis
  else if(axi == 2){
     s = -1;
    if(s <= sc0)
      s = sc0;
    if(s <= sc1)
      s = sc1;
    if(s <= sc2)
      s = sc2;
    if(rel == 4) 
      if(s <= sc3)
        s = sc3;
  }
  // R2 average Axis
  else if(axi == 3){
    if(rel == 4)
      s = (sc0+sc1+sc2+sc3)/4;
    else if(rel == 3)
      s = (sc0+sc1+sc2)/3;
  }
  return s;
}

void draw_over_glyph(int d0, int d1,int d2, int d3, float cx, float cy){ 

  double score_tet;
  score_tet = inThreshold(R2_tet(d0, d1, d2, d3))+inThreshold(R2_tet(d1, d0, d2, d3))+inThreshold(R2_tet(d2, d1, d0, d3))+inThreshold(R2_tet(d3, d1, d2, d0));
  if(score_tet != 0){   
    draw_tet_in_glyph(d0,d1,d2,d3,cx,cy);
    draw_tri_in_glyph(d0,d1,d2,d3,cx,cy);
    draw_edge_in_glyph(d0,d1,d2,d3,cx,cy); 
  }
}

void draw_tet_in_glyph(int d0, int d1,int d2, int d3, float cx, float cy){
 // tets
 double score_tet;
 score_tet = inThreshold(R2_tet(d0, d1, d2, d3))+inThreshold(R2_tet(d1, d0, d2, d3))+inThreshold(R2_tet(d2, d1, d0, d3))+inThreshold(R2_tet(d3, d1, d2, d0));
 if(R2_tet(d0, d1, d2, d3) > lower_threshold && R2_tet(d0, d1, d2, d3) < upper_threshold)
     detail_tet_in_glyph((float)R2_tet(d0, d1, d2, d3),d0,d1,d2,d3,cx,cy,0);
 if(score_tet != 0){   
   noStroke();
   if (selectedx >= (cx-selv) && selectedx <= (cx+selv) && selectedy >= (cy-selv) && selectedy <= (cy+selv) && selectedGlyph == 2){
    green_hue_sp((float)score_tet);
    float dx = cx-rad_tets;
    float dy = cy-rad_tets*1.2;
     
    rect(dx, dy, 2*rad_tets, 2*rad_tets);
    
    draw_dimOverview(dimLabel[d0], dx - 10, dy);
    draw_dimOverview(dimLabel[d1], dx + 2*rad_tets + 10, dy);
    draw_dimOverview(dimLabel[d2], dx + 2*rad_tets + 10, dy + 2*rad_tets);
    draw_dimOverview(dimLabel[d3], dx - 10, dy + 2*rad_tets);
     
    seld0 = d0;
    seld1 = d1;
    seld2 = d2;
    seld3 = d3;
    selx = cx;
    sely = cy;
   }
   else if(seld0 != -1 && d0 == seld0  &&  d1 == seld1 && d2 == seld2 && d3 == seld3){
      green_hue_sp((float)score_tet);
      float dx = selx-rad_tets;
      float dy = sely-rad_tets*1.2;
      noStroke();
      rect(dx, dy, 2*rad_tets, 2*rad_tets);
      draw_dimOverview(dimLabel[seld0], dx - 10, dy);
      draw_dimOverview(dimLabel[seld1], dx + 2*rad_tets + 10, dy);
      draw_dimOverview(dimLabel[seld2], dx + 2*rad_tets + 10, dy + 2*rad_tets);
      draw_dimOverview(dimLabel[seld3], dx - 10, dy + 2*rad_tets);
       
      if(mouseClick == 1){
        selectedx = (mouseX-translateX)/scaleFactor;
        selectedy = (mouseY-translateY)/scaleFactor;
        if (selectedx >= (dx - 10-selv) && selectedx <= (dx - 10+selv) && selectedy >= (dy-selv) && selectedy <= (dy+selv))
             filterDim = seld0;
        if (selectedx >= (dx + 2*rad_tets + 10-selv) && selectedx <= (dx + 2*rad_tets + 10+selv) && selectedy >= (dy-selv) && selectedy <= (dy+selv))
             filterDim = seld1;
        if (selectedx >= (dx + 2*rad_tets + 10-selv) && selectedx <= (dx + 2*rad_tets + 10+selv) && selectedy >= (dy+ 2*rad_tets-selv) && selectedy <= (dy+ 2*rad_tets+selv))
             filterDim = seld2;
        if (selectedx >= (dx - 10-selv) && selectedx <= (dx - 10+selv) && selectedy >= (dy+ 2*rad_tets-selv) && selectedy <= (dy+ 2*rad_tets+selv))
             filterDim = seld3;
        mouseClick = 2;
      }
   } else {
     green_hue((float)score_tet);
     rect(cx-rad_tets/2, cy-1.8*rad_tets/3, rad_tets, rad_tets);
   }
  }
}

void draw_tri_in_glyph(int d0, int d1,int d2, int d3, float x, float y){
  // triangle
  double score_tri;
  score_tri = inThreshold(R2_triangle(d0, d1, d2))+inThreshold(R2_triangle(d0, d1, d3))+inThreshold(R2_triangle(d0, d2, d3))+inThreshold(R2_triangle(d1, d0, d2))+inThreshold(R2_triangle(d1, d0, d3))+inThreshold(R2_triangle(d1, d2, d3))+inThreshold(R2_triangle(d2, d0, d1))+inThreshold(R2_triangle(d2, d0, d3))+inThreshold(R2_triangle(d2, d1, d3))+inThreshold(R2_triangle(d3, d0, d1))+inThreshold(R2_triangle(d3, d0, d2))+inThreshold(R2_triangle(d3, d1, d2));
  if(score_tri != 0){
    noStroke();
    blue_hue((float)score_tri);
    if (selectedx >= (x-selv) && selectedx <= (x+selv) && selectedy >= (y-selv) && selectedy <= (y+selv) && selectedGlyph == 2){
       triangle(x-2*rad_triangles*sin(PI/3), y + 2*rad_triangles*sin(PI/6), x, y-2*rad_triangles, x+2*rad_triangles*sin(PI/3), y+ 2*rad_triangles*sin(PI/6)); 
       seld0 = d0;
       seld1 = d1;
       seld2 = d2;
       seld3 = d3;
       selx = x;
       sely = y;
    }
    else if(seld0 != -1 && d0 == seld0  &&  d1 == seld1 && d2 == seld2 && d3 == seld3){
      triangle(selx-2*rad_triangles*sin(PI/3), sely + 2*rad_triangles*sin(PI/6), selx, sely-2*rad_triangles, selx+2*rad_triangles*sin(PI/3), sely+ 2*rad_triangles*sin(PI/6));
    }
    else  
      triangle(x-rad_triangles*sin(PI/3), y + rad_triangles*sin(PI/6), x, y-rad_triangles, x+rad_triangles*sin(PI/3), y+ rad_triangles*sin(PI/6));    
  }
}

void draw_edge_in_glyph(int d0, int d1,int d2, int d3, float cx, float cy){
  double score_pair;
  // pairwise
  score_pair = inThreshold(pcc[d0][d1])+inThreshold(pcc[d0][d2])+inThreshold(pcc[d0][d3])+inThreshold(pcc[d1][d2])+inThreshold(pcc[d1][d3])+inThreshold(pcc[d2][d3]);
  if(score_pair != 0){
    noStroke();
    red_hue((float)score_pair);
    if (selectedx >= (cx-selv) && selectedx <= (cx+selv) && selectedy >= (cy-selv) && selectedy <= (cy+selv) && selectedGlyph == 2)
      ellipse(cx, cy, 2*rad_edges, 2*rad_edges);    
    else
      ellipse(cx, cy, rad_edges, rad_edges);    
  }
}

double inThreshold(double sco){
  if(sco > lower_threshold && sco < upper_threshold)
    return 1;
  else
    return 0;
}

// draw detail 4-way glyph in zooming level or selection
void detail_tet_in_glyph_inov(int d0, int d1, int d2, int d3, float cx, float cy) {
  double s = inThreshold(R2_tet(d0, d1, d2, d3))+inThreshold(R2_tet(d1, d0, d2, d3))+inThreshold(R2_tet(d2, d1, d0, d3))+inThreshold(R2_tet(d3, d1, d2, d0));
  if(s != 0){
    noStroke();
   green_hue_sp((float)s);
   float dx = cx-rad_tets/2;
   // selection box
   float dy = cy-rad_tets*1.2;
   float sl = 1.8;
   float ppx0, ppy0, ppx1, ppy1, ppx2, ppy2, ppx3, ppy3;
  
   ppx0 = dx;
   ppy0 = dy;
   ppx1 = dx + sl*rad_tets;
   ppy1 = dy;
   ppx2 = dx + sl*rad_tets;
   ppy2 = dy + sl*rad_tets;
   ppx3 = dx;
   ppy3 = dy + sl*rad_tets;
   
   stroke(200); 
   strokeWeight(2*scaleFactor/5);
   line(ppx0, ppy0, ppx1, ppy1);
   line(ppx2, ppy2, ppx1, ppy1);
   line(ppx2, ppy2, ppx3, ppy3);
   line(ppx0, ppy0, ppx3, ppy3);
      
   if(numData > 30){
     noStroke();
     textFont( createFont("Arial", 10/scaleFactor) );
     int p = 4;
     draw_dimOverview(dimLabel[d0], ppx0-p, ppy0);
     draw_dimOverview(dimLabel[d1], ppx1+p, ppy1);
     draw_dimOverview(dimLabel[d2], ppx2+p, ppy2);
     draw_dimOverview(dimLabel[d3], ppx3-p, ppy3);
   }
   draw_tet_untangle_inov(d0, d1, d2, d3, ppx0, ppy0, ppx1, ppy1, ppy2);
   redraw();
  }
 }

void draw_points_untan_triangle_inov(float ax, float ay, float bx, float by, float cx, float cy, float t1, float t2, float t3, int col) { 
  float maxt = 10*max(t1,t2);
  float x = t1*ax + t2*bx + t3*cx;
  float y = t1*ay + t2*by + t3*cy;  
  noStroke();
  
  if (col == 0) 
    unt_red_hue(maxt);
  else if (col == 1) 
    unt_blue_hue(maxt);
  else if (col == 2)
    unt_green_hue(maxt);
  else if (col == 3)
    unt_pink_hue(maxt);
    
  float s = 3/scaleFactor;
  ellipse(x, y, s, s); 
}

// draw detail glyph in overview
void draw_tet_untangle_inov(int d0, int d1, int d2, int d3, float ppx0, float ppy0, float ppx1, float ppy1, float ppy2) {
  strokeWeight(1);
  stroke(227, 0, 42);
  fill(227, 0, 42);
  line(ppx0, ppy0, ppx1, ppy0);

  stroke(4, 8, 222);
  fill(4, 8, 222);
  line(ppx1, ppy0, ppx1, ppy2);

  stroke(0, 60, 30);
  fill(0, 60, 30);
  line(ppx1, ppy2, ppx0, ppy2);
 
  stroke(205, 0, 237);
  fill(205, 0, 237);
  line(ppx0, ppy0, ppx0, ppy2);
      
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

    float s = 5/scaleFactor;
    if (p0 == 1) {
      stroke(227, 0, 42);
      fill(227, 0, 42);
      ellipse(po0x, po0y, s, s); 
    } else if (p1 == 1) {
      stroke(4, 8, 222);
      fill(4, 8, 222);
      ellipse(po1x, po1y, s, s); 
    } else if (p2 == 1){
      stroke(0, 60, 30);
      fill(0, 60, 30);
      ellipse(po2x, po2y, s, s); 
    } else if (p3 == 1){
      stroke(205, 0, 237);
      fill(205, 0, 237);
      ellipse(po3x, po3y, s, s); 
    }
    else {
      draw_points_untan_triangle_inov(ppx0, ppy0, ppx1, ppy0, (ppx0+ppx1)/2,ppy2, p0, p1, (1-p0-p1),0);
      draw_points_untan_triangle_inov(ppx1, ppy0, ppx1, ppy2, ppx0, (ppy0+ppy2)/2, p1, p2, (1-p1-p2),1);
      draw_points_untan_triangle_inov(ppx1, ppy2, ppx0, ppy2, (ppx0+ppx1)/2,ppy0, p2, p3, (1-p2-p3),2);
      draw_points_untan_triangle_inov(ppx0, ppy2, ppx0, ppy0, ppx1, (ppy0+ppy2)/2, p3, p0, (1-p3-p0),3);
    }
  }
}

void draw_symb_tet_inov(float s, float x, float y, int col) {
 if (col == 0) {
   stroke(100, 0, 0);
   fill(100, 0, 0);
 } else {
   stroke(0, 100, 200);
   fill(0, 100, 200);
 }
 rect(x-5, y-5, 10, 10);
}
// R2 for 0/1,2
double R2_triangle(int ati, int atk, int atm)
{
  DenseMatrix64F c_i = new DenseMatrix64F(2,1);
  DenseMatrix64F Rxx_i = new DenseMatrix64F(2, 2);
          
  double cor0 = pcc[ati][atk];
  double cor1 = pcc[ati][atm];
  c_i.set(0,0, cor0);
  c_i.set(1,0, cor1);
  
  double cor_indep0 = pcc[atk][atk];
  Rxx_i.set(0,0,cor_indep0);
  double cor_indep1 = pcc[atk][atm];
  Rxx_i.set(0,1,cor_indep1);
  double cor_indep2 = pcc[atm][atk];
  Rxx_i.set(1,0,cor_indep2);
  double cor_indep3 = pcc[atm][atm];
  Rxx_i.set(1,1,cor_indep3);
  
  double R2;
  R2 = Correlation.MultipleCorrelation(Rxx_i, c_i);
  
  return R2;
}

// R2 for 0/1,2,3
double R2_tet(int at0, int at1, int at2, int at3){
  DenseMatrix64F c0 = new DenseMatrix64F(3,1);
  DenseMatrix64F Rxx0 = new DenseMatrix64F(3, 3);
  DenseMatrix64F c1 = new DenseMatrix64F(3,1);
  DenseMatrix64F Rxx1 = new DenseMatrix64F(3, 3);
  DenseMatrix64F c2 = new DenseMatrix64F(3,1);
  DenseMatrix64F Rxx2 = new DenseMatrix64F(3, 3);
  DenseMatrix64F c3 = new DenseMatrix64F(3,1);
  DenseMatrix64F Rxx3 = new DenseMatrix64F(3, 3);
        
  double co0 = pcc[at0][at1];
  double co1 = pcc[at0][at2];
  double co2 = pcc[at0][at3];
  c0.set(0,0, co0);
  c0.set(1,0, co1);        
  c0.set(2,0, co2);
  
  double co_ind0 = pcc[at1][at1];
  Rxx0.set(0,0,co_ind0);
  double co_ind1 = pcc[at1][at2];
  Rxx0.set(1,0,co_ind1);
  double co_ind2 = pcc[at1][at3];
  Rxx0.set(2,0,co_ind2);
  double co_ind3 = pcc[at2][at1];
  Rxx0.set(0,1,co_ind3);
  double co_ind4 = pcc[at2][at2];
  Rxx0.set(1,1,co_ind4);
  double co_ind5 = pcc[at2][at3];
  Rxx0.set(2,1,co_ind5);
  double co_ind6 = pcc[at3][at1];
  Rxx0.set(0,2,co_ind6);
  double co_ind7 = pcc[at3][at2];
  Rxx0.set(1,2,co_ind7);
  double co_ind8 = pcc[at3][at3];
  Rxx0.set(2,2,co_ind8);
  
  double R2;
  R2 = Correlation.MultipleCorrelation(Rxx0, c0);  
  return R2;
}


// compute dimLabel, and Pearson Correlation for dataset

void spccData(){
  for(int i=0;i<data.attributeCount();i++){
    // store dimID
    dimLabel[i] = data.getAttribute(i).getLabel();
    // store Preason Correlation Coeffient
    for(int j=0;j<data.attributeCount();j++){
      ReadableAttribute d0 = data.getAttribute(i);
      ReadableAttribute d1 = data.getAttribute(j);
      // Pearson Correlation Cooeficient
      spcc[i][j] = Correlation.PearsonCorrelation(d0, d1); 
      // Spearman Correlation Cooeficient Correlation.SpearmanCorrelation(ratr0, ratr1);
      //spcc[i][j] = Correlation.SpearmanCorrelation(d0, d1); 
      if(Double.isNaN(spcc[i][j]))
        spcc[i][j] = 0.01;
      pcc[i][j] = spcc[i][j]; 
    }
  }
  pccComputed = 1;
}

int getDimID(String dLabel){
  int id = 0;
  for(int i=0;i<numData;i++){
    if(dLabel.compareTo(dat.get(i).getLabel()) == 0){
      id = i;
    }
  }
  return id;
}

void pccData(){
  for(int i=0;i<numData;i++){
    dimLabel[i] = dat.get(i).getLabel();
    for(int j=0;j<numData;j++){
      ReadableAttribute d0 = data.getAttribute(dimList[i]);
      ReadableAttribute d1 = data.getAttribute(dimList[j]);
      // Pearson Correlation Cooeficient
      spcc[i][j] = Correlation.PearsonCorrelation(d0, d1); 
      // Spearman Correlation Cooeficient Correlation.SpearmanCorrelation(ratr0, ratr1);
      //spcc[i][j] = Correlation.SpearmanCorrelation(d0, d1); 
      if(Double.isNaN(spcc[i][j]))
        spcc[i][j] = 0.01;
      if(spcc[i][j] > 1.0)
        spcc[i][j] = 1.0;
      pcc[i][j] = spcc[i][j]; 
    }
  }
  pccComputed = 1;
}

void blue_hue(float sco){
  int alp = 200;  
  //int alp = 255;
  //purple  
  if(sco == 0)
    fill(255,255,255,alp);
  else if(sco>0&&sco<=1)
    fill(252,251,253,alp);
  else if(sco>1&&sco<=2)
    fill(239,237,245,alp);
  else if(sco>2&&sco<=3)
    fill(239,237,245,alp);
  else if(sco>3&&sco<=4)
    fill(218,218,235,alp);
  else if(sco>4&&sco<=5)
    fill(218,218,235,alp);
  else if(sco>5&&sco<=6)
    fill(188,189,220,alp);
  else if(sco>6&&sco<=7)
    fill(188,189,220,alp);
  else if(sco>7&&sco<=8)
    fill(158,154,200,alp);
  else if(sco>8&&sco<=9)
    fill(158,154,200,alp);
  else if(sco>9&&sco<=10)
    fill(128,125,186,alp);
  else if(sco>10&&sco<=11)
    fill(106,81,163,alp);
  else
    fill(84,39,143,alp);    
}

void red_hue(float sco){
  int alp = 200;
  //int alp = 255;
  // orange
    if(sco == 0)
      fill(255,255,255,alp);
    else if(sco>0&&sco<=1)
      fill(255,245,235,alp);
    else if(sco>1&&sco<=2)
      fill(254,230,206,alp);
    else if(sco>2&&sco<=3)
      fill(253,208,162,alp);
    else if(sco>3&&sco<=4)
      fill(253,174,107,alp);
    else if(sco>4&&sco<=5)
      fill(253,141,60,alp);
    else
      fill(241,105,19,alp);   
}

void green_hue(float sco){
    int alp = 180;
    noStroke();
    if(sco == 0)
      fill(255,255,255,alp);
    else if(sco>0&&sco<=1)
      fill(107,174,214,alp);
    else if(sco>1&&sco<=2)
      fill(66,146,198,alp);
    else if(sco>2&&sco<=3)
      fill(33,113,181,alp);
    else
      fill( 66,146,198,alp);  
}
void green_hue_sp(float sco){
    int alp = 255;
    if(sco == 0)
      fill(255,255,255,alp);
    else if(sco>0&&sco<=1)
      fill(107,174,214,alp);
    else if(sco>1&&sco<=2)
      fill(66,146,198,alp);
    else if(sco>2&&sco<=3)
      fill(33,113,181,alp);
    else
      fill( 66,146,198,alp);  
}

void blue_hue_sp(float sco){
  int alp = 255;  
  //purple  
  if(sco == 0)
    fill(255,255,255,alp);
  else if(sco>0&&sco<=1)
    fill(252,251,253,alp);
  else if(sco>1&&sco<=2)
    fill(239,237,245,alp);
  else if(sco>2&&sco<=3)
    fill(239,237,245,alp);
  else if(sco>3&&sco<=4)
    fill(218,218,235,alp);
  else if(sco>4&&sco<=5)
    fill(218,218,235,alp);
  else if(sco>5&&sco<=6)
    fill(188,189,220,alp);
  else if(sco>6&&sco<=7)
    fill(188,189,220,alp);
  else if(sco>7&&sco<=8)
    fill(158,154,200,alp);
  else if(sco>8&&sco<=9)
    fill(158,154,200,alp);
  else if(sco>9&&sco<=10)
    fill(128,125,186,alp);
  else if(sco>10&&sco<=11)
    fill(106,81,163,alp);
  else
    fill(84,39,143,alp);    
}

void red_hue_sp(float sco){
  int alp = 255;
  // orange
    if(sco == 0)
      fill(255,255,255,alp);
    else if(sco>0&&sco<=1)
      fill(255,245,235,alp);
    else if(sco>1&&sco<=2)
      fill(254,230,206,alp);
    else if(sco>2&&sco<=3)
      fill(253,208,162,alp);
    else if(sco>3&&sco<=4)
      fill(253,174,107,alp);
    else if(sco>4&&sco<=5)
      fill(253,141,60,alp);
    else
      fill(241,105,19,alp);   
}
void arrow(float x1, float y1, float x2, float y2) {
  line(x1, y1, x2, y2);
  pushMatrix();
  translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  rotate(a);
  line(0, 0, -10, -10);
  line(0, 0, 10, -10);
  popMatrix();
} 

void dw_arrow(float x1, float y1, float x2, float y2) {
  dw.line(x1, y1, x2, y2);
  dw.pushMatrix();
  dw.translate(x2, y2);
  float a = atan2(x1-x2, y2-y1);
  dw.rotate(a);
  dw.line(0, 0, -3, -3);
  dw.line(0, 0, 3, -3);
  dw.popMatrix();
} 

void maxminR2_tet(){
 for( int i=0; i<numData-3; i++ ){
    for(int j=i+1; j<numData-2; j++){
      int d0 = i;
      int d1 = j;
      int d2 = j+1;
      int d3 = j+2;
      double r = R2_tet(d0,d1,d2,d3); 
      if(r2min_tet > r)
        r2min_tet = r;
      if(r2max_tet < r)
        r2max_tet = r;
        
      r = R2_tet(d1,d0,d2,d3); 
      if(r2min_tet > r)
        r2min_tet = r;
      if(r2max_tet < r)
        r2max_tet = r;
        
      r = R2_tet(d2,d1,d0,d3); 
      if(r2min_tet > r)
        r2min_tet = r;
      if(r2max_tet < r)
        r2max_tet = r;
        
      r = R2_tet(d3,d1,d2,d0); 
      if(r2min_tet > r)
        r2min_tet = r;
      if(r2max_tet < r)
        r2max_tet = r;
    }
 } 
}

void maxminR2_tri(){
 for( int i=0; i<numData-2; i++ ){
    for(int j=i+1; j<numData-1; j++){
      int d0 = i;
      int d1 = j;
      int d2 = j+1;
      double r = R2_triangle(d0,d1,d2); 
      if(r2min_tri > r)
        r2min_tri = r;
      if(r2max_tri < r)
        r2max_tri = r;
    }
 } 
}

void maxminR2_edge(){
  for( int i=0; i<numData-1; i++ ){
    for(int j=i+1; j<numData; j++){
        int d0 = i;
        int d1 = j;
        
        double r = pcc[d0][d1]*pcc[d0][d1];
        if(r2min_edge > r)
          r2min_edge = r;
        if(r2max_edge < r)
          r2max_edge = r;
        
    }
  }
}

void draw_dimOverview(String dimName, float x, float y) {
  textFont( createFont("Arial", fon/scaleFactor) );
  stroke(0);
  strokeWeight(1/scaleFactor);
  fill(255,255,255,255);
  ellipse(x, y, fon*2/scaleFactor, fon*1.5/scaleFactor);
  fill(0,0,0,255);
  textAlign(CENTER);
  text(dimName, x, y+5/scaleFactor);
}


void unt_blue_hue(float sco) {
  int alp = 220;
  if (sco == 0)
    fill(255, 255, 255, alp);
  else if (sco>0&&sco<=1)
    fill(200, 200, 222, alp);
  else if (sco>1&&sco<=2)
    fill(180, 180, 222, alp);
  else if (sco>2&&sco<=3)
    fill(150, 154, 222, alp);
  else if (sco>3&&sco<=4)
    fill(130, 134, 222, alp);
  else if (sco>4&&sco<=5)
    fill(100, 104, 222, alp);
  else if (sco>5&&sco<=6)
    fill(70, 74, 222, alp);
  else if (sco>6&&sco<=7)
    fill(60, 64, 222, alp);
  else if (sco>7&&sco<=8)
    fill(50, 55, 222, alp);
  else if (sco>8&&sco<=9)
    fill(40, 44, 222, alp);
  else if (sco>9&&sco<=10)
    fill(28, 31, 222, alp);
  else if (sco>10&&sco<=11)
    fill(18, 22, 222, alp);
  else
    fill(4, 8, 222, alp);
}

void unt_red_hue(float sco) {
  int alp = 250;
  if (sco == 0)
    fill(255, 255, 255, alp);
  else if (sco>0&&sco<=1)
    fill(255, 245, 235, alp);
  else if (sco>1&&sco<=2)
    fill(254, 230, 206, alp);
  else if (sco>2&&sco<=3)
    fill(253, 208, 162, alp);
  else if (sco>3&&sco<=4)
    fill(253, 174, 107, alp);
  else if (sco>4&&sco<=5)
    fill(253, 141, 60, alp);
  else if (sco>5&&sco<=6)
    fill(227, 93, 117, alp);
  else if (sco>6&&sco<=7)
    fill(227, 70, 98, alp);
  else if (sco>7&&sco<=8)
    fill(227, 55, 87, alp);
  else if (sco>8&&sco<=9)
    fill(227, 41, 75, alp);
  else if (sco>9&&sco<=10)
    fill(227, 20, 58, alp);
  else if (sco>10&&sco<=11)
    fill(227, 81, 163, alp);
  else
    fill(227, 0, 42, alp);
}

void unt_green_hue(float sco) {
  int alp = 220;
  if (sco == 0)
    fill(255, 255, 255, alp);
  else if (sco>0&&sco<=1)
    fill(190, 240, 220, alp);
  else if (sco>1&&sco<=2)
    fill(180, 230, 210, alp);
  else if (sco>2&&sco<=3)
    fill(170, 220, 200, alp);
  else if (sco>3&&sco<=4)
    fill(150, 210, 180, alp);
  else if (sco>4&&sco<=5)
    fill(130, 210, 160, alp);
  else if (sco>5&&sco<=6)
    fill(110, 200, 140, alp);
  else if (sco>6&&sco<=7)
    fill(90, 190, 120, alp);
  else if (sco>7&&sco<=8)
    fill(70, 180, 100, alp);
  else if (sco>8&&sco<=9)
    fill(50, 170, 80, alp);
  else if (sco>9&&sco<=10)
    fill(30, 100, 60, alp);
  else if (sco>10&&sco<=11)
    fill(10, 80, 40, alp);
  else
    fill(0, 60, 30, alp);
}

void unt_pink_hue(float sco) {
  int alp = 240;
  if (sco == 0)
    fill(255, 255, 255, alp);
  else if (sco>0&&sco<=1)
    fill(220, 200, 237, alp);
  else if (sco>1&&sco<=2)
    fill(215, 180, 237, alp);
  else if (sco>2&&sco<=3)
    fill(210, 150, 237, alp);
  else if (sco>3&&sco<=4)
    fill(205, 130, 237, alp);
  else if (sco>4&&sco<=5)
    fill(205, 110, 237, alp);
  else if (sco>5&&sco<=6)
    fill(205, 93, 237, alp);
  else if (sco>6&&sco<=7)
    fill(205, 70, 237, alp);
  else if (sco>7&&sco<=8)
    fill(205, 55, 237, alp);
  else if (sco>8&&sco<=9)
    fill(205, 41, 237, alp);
  else if (sco>9&&sco<=10)
    fill(205, 20, 237, alp);
  else if (sco>10&&sco<=11)
    fill(205, 10, 237, alp);
  else
    fill(205, 0, 237, alp);
}