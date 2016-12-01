/* 
* Multi-dependencies Visualization
* Hoa Nguyen 
*/

// filter
void filterSel(){
  tmpDat.clear();
  // update threshold
  float cy_min, cy_max, cx_min, cx_max, c;
  cy_min = (Yend - sb_endy)/(Yend-Ystart);
  cy_max = (Yend - sb_starty)/(Yend-Ystart);
  
  cx_min = (Xend - sb_endx)/(Xend-Xstart);
  cx_max = (Xend - sb_startx)/(Xend-Xstart);
  
  if(selectedViz == 7 || selectedViz == 4 || selectedViz == 5 || selectedViz == 6 || selectedViz == 0){
    for( int i=0; i<numData-3; i++ ){
      for(int j=i+1; j<numData-2; j++){
        int d0 = i;
        int d1 = j;
        int d2 = j+1;
        int d3 = j+2;

        double sc0 = R2_tet(d0, d1, d2, d3);        
        double sc1 = R2_tet(d1, d0, d2, d3);
        double sc2 = R2_tet(d2, d1, d0, d3);
        double sc3 = R2_tet(d3, d1, d2, d0);
        double sc = sca(Xaxis, 4, sc0, sc1, sc2, sc3);
        float s = (float)sca(Yaxis, 4, sc0, sc1, sc2, sc3);
        //c =Xstart+gap*(i+j+j+1+j+2);
        c = Xstart+gap*(i+j+j+1+j+2-filterDim);
        if(sc >= cy_min && sc <= cy_max){
          if(Yaxis == 4){
            if(c <= sb_endx && c>= sb_startx){  
              addElem(i);
              addElem(j);
              addElem(j+1);
              addElem(j+2);
            }
          }
          else{
            if(s >= cx_min && s <= cx_max){  
              addElem(i);
              addElem(j);
              addElem(j+1);
              addElem(j+2);
            }
          }
        }
      }
    }
  }
  if(selectedViz == 2 || selectedViz == 3 || selectedViz == 6){
    for( int i=0; i<numData-2; i++ ){
      for(int j=i+1; j<numData-1; j++){
        int d0 = i;
        int d1 = j;
        int d2 = j+1;

        double sc0 = R2_triangle(d0, d1, d2);        
        double sc1 = R2_triangle(d1, d0, d2);
        double sc2 = R2_triangle(d2, d1, d0);          
        sc = sca(Xaxis, 3, sc0, sc1, sc2, 0);
        float s = (float)sca(Yaxis, 3, sc0, sc1, sc2, 0);
        c = Xstart+gap*(i+j+j+1+j);
        if(sc >= cy_min && sc <= cy_max){
          if(Yaxis == 4){
            if(c <= sb_endx && c>= sb_startx){
              addElem(i);
              addElem(j);
              addElem(j+1);
            }
          }
          else{
            if(s >= cx_min && s <= cx_max){
              addElem(i);
              addElem(j);
              addElem(j+1);
            }
          }
        }
      }
    }
  }
  if(vizMeth == 1 || vizMeth == 3 || vizMeth == 5){
    for( int i=0; i<numData-1; i++ ){
      for(int j=i+1; j<numData; j++){
        int d0 = i;
        int d1 = j;
        
        double pc = pcc[d0][d1];
        sc = pc*pc;
        c =Xstart+gap*(i+2.9*j);
        if(sc >= cy_min && sc <= cy_max){
          if(Yaxis == 4){
            if(c <= sb_endx && c>= sb_startx){
              addElem(i);
              addElem(j);
            }
          }
          else{
            if(sc >= cx_min && sc <= cx_max){
              addElem(i);
              addElem(j);
            }
          }
        }       
      }
    }
  }
  
  // update dat
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
  }
  else if(numData <=10){
    rad_edges = 6*(width - Xstart)/(numData*numData*numData);
    rad_triangles = 1.5*rad_edges;
    rad_tets = 3*rad_edges;
  }
  else{
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
}

void addElem(int e){
  int ne = 1;
  int i=0;
  while(i<tmpDat.size()){
    if(tmpDat.get(i).getLabel().compareTo(dat.get(e).getLabel()) == 0){      
      ne = 0;
      i = tmpDat.size()+1;
    }
   i++;
  }
  if(ne == 1)
    tmpDat.add(dat.get(e));  
}


// filter
void filterSel_lasso(int px0, int py0, int px1, int py1){
  // update threshold
  float cy0, cy1, cx0, cx1, cy_min, cy_max, cx_min, cx_max, c;
  cy0 = (Yend - py0)/(Yend-Ystart);
  cy1 = (Yend - py1)/(Yend-Ystart);
  
  cy_min = min(cy0, cy1);
  cy_max = max(cy0, cy1);
  
  cx0 = (Xend - px0)/(Xend-Xstart);
  cx1 = (Xend - px1)/(Xend-Xstart);
  
  cx_min = min(cx0, cx1);
  cx_max = max(cx0, cx1);
  
  println("cx_min = " + cx_min + " cx_max = " + cx_max);
  println("cy_min = " + cy_min + " cy_max = " + cy_max);
  println("numData = " + numData);
  //if(lassoSelect == 2)
  //   tmpDat.clear();
  
  if(selectedViz == 7 || selectedViz == 4 || selectedViz == 5 || selectedViz == 6 || selectedViz == 0){
    for( int i=0; i<numData-3; i++ ){
      for(int j=i+1; j<numData-2; j++){
        int d0 = i;
        int d1 = j;
        int d2 = j+1;
        int d3 = j+2;

        double sc0 = R2_tet(d0, d1, d2, d3);        
        double sc1 = R2_tet(d1, d0, d2, d3);
        double sc2 = R2_tet(d2, d1, d0, d3);
        double sc3 = R2_tet(d3, d1, d2, d0);
        double sc = sca(Xaxis, 4, sc0, sc1, sc2, sc3);
        float s = (float)sca(Yaxis, 4, sc0, sc1, sc2, sc3);
        //c =Xstart+gap*(i+j+j+1+j+2);
        c = Xstart+gap*(i+j+j+1+j+2-filterDim);
        if(sc >= cy_min && sc <= cy_max){
          if(Yaxis == 4){
            if(c <= sb_endx && c>= sb_startx){  
              addElem(i);
              addElem(j);
              addElem(j+1);
              addElem(j+2);
            }
          }
          else{
            if(s >= cx_min && s <= cx_max){  
              addElem(i);
              addElem(j);
              addElem(j+1);
              addElem(j+2);
            }
          }
        }
      }
    }
  }
}