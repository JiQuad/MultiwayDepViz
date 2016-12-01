/* 
* Multi-dependencies Visualization
* Hoa Nguyen 
*/

void draw_relationship(){
  pushMatrix();  
  translate(translateX,translateY);
  scale(scaleFactor);
  // draw glyphs of combining edges, triangle, tetrahedra.
  strokeWeight( 2 );
  stroke(0, 0, 0);
  float pa = 10;
  
  gap = numData*(Xend+Xstart)/(4.5*((numData-1)*(numData-1)));
  arrow(Xstart+5, Yend+15, Xstart+5, Ystart-pa);
  arrow(Xstart+5, Yend+15, Xend, Yend+15);
  strokeWeight( 2 );
  stroke(0, 0, 0);              
  fill(0);
  textAlign(CENTER);
  if(Yaxis == 4){
    text("Dim", Xend - 5, Yend + 45);
  }
  if(r2max > 1 || r2min<0){
    text(0, Xstart-15, Yend);
    text(1, Xstart-15, Ystart+20);
  }
  else{
    text(nf(r2min,1,1), Xstart-15, Yend);
    text(nf(r2max,1,1), Xstart-15, Ystart+20);
  }
  
  if(vizMeth == 7){
        float cx=Xstart, cy=Ystart;
        float ccx=Xstart, ccy=Ystart;
        float ccx2=Xstart, ccy2=Ystart;
        double oldsc;
        float oldcx=Xstart, oldcy=Ystart;
          for( int i=0; i<numData-3; i++ ){
            for(int j=i+1; j<numData-2; j++){
                if(filterDim > -1){
                  if(i!=filterDim && j != filterDim && j+1 != filterDim && j+2 != filterDim)
                    continue;
                }
                int d0 = i;
                int d1 = j;
                int d2 = j+1;
                int d3 = j+2;
                double sc0 = R2_tet(d0, d1, d2, d3);        
                double sc1 = R2_tet(d1, d0, d2, d3);
                double sc2 = R2_tet(d2, d1, d0, d3);
                double sc3 = R2_tet(d3, d1, d2, d0);

                sc = sca(Xaxis, 4, sc0, sc1, sc2, sc3);
                  
                if(Yaxis == 4)
                  cx = Xstart+gap*(i+j+j+1+j+2-filterDim);
                else
                  cx =Xend-((float)sca(Yaxis, 4, sc0, sc1, sc2, sc3)-r2min)*(Xend-Xstart)/(r2max-r2min)+15;                  
                  
                cy =Yend-((float)sc-r2min)*(Yend-Ystart)/(r2max-r2min);
                
                if(Yaxis == 4){
                  if(filterDim > -1){
                     if(filterDim == 0) 
                       cx = Xstart+gap*((i+j+1)*3.8);
                     else
                       cx = Xstart+gap*((i+j-filterDim+3)*3.8);
                     if((i+j+1)%5 == 1){
                       fill(255);
                       strokeWeight( 1 );
                       stroke(0, 0, 0);              
                       rect(cx-1.3*fon,Yend+fon,2.6*fon,4*fon+5);
                       strokeWeight( 2 );
                       fill(0);
                       textAlign(CENTER);
                       text(dimLabel[d0], cx, Yend+35);
                       text(dimLabel[d1], cx, Yend+50);
                       text(dimLabel[d2], cx, Yend+65);
                       text(dimLabel[d3], cx, Yend+80);
                     }
                  }
                  else{
                   if((j == (i+1) && j%5 == 1) || numData < 5){
                     fill(255);
                     strokeWeight( 1 );
                     stroke(0, 0, 0);              
                     rect(cx-1.3*fon,Yend+fon,2.6*fon,4*fon+5);
                     strokeWeight( 2 );
                     fill(0);
                     textAlign(CENTER);
                     text(dimLabel[d0], cx, Yend+35);
                     text(dimLabel[d1], cx, Yend+50);
                     text(dimLabel[d2], cx, Yend+65);
                     text(dimLabel[d3], cx, Yend+80);  
                   }
                  }
                }
              
                if(oldYaxis == Yaxis && oldXaxis == Xaxis){
                  if(oldMeth == 1){          
                    move_edges(i,j,j+1,j+2,cx,cy);              
                    if(step>=nstep)
                      draw_glyphs(d0,d1,d2,d3,cx,cy);
                  }
                  else if(oldMeth == 2){
                    move_triangles(i,j,j+1,j+2,cx,cy,sc,sc,sc,sc);            
                    if(step>=nstep)
                      draw_glyphs(d0,d1,d2,d3,cx,cy);
                  }
                  else if(oldMeth == 4){
                    move_tets(i,j,j+1,j+2,cx,cy,sc,sc,sc,sc);
                    if(step>=nstep)
                      draw_glyphs(d0,d1,d2,d3,cx,cy);
                  }
                  else if(oldMeth == 3){
                    move_edges(i,j,j+1,j+2,cx,cy);
                    move_triangles(i,j,j+1,j+2,cx,cy,sc,sc,sc,sc);            
                    if(step>=nstep)
                      draw_glyphs(d0,d1,d2,d3,cx,cy);
                  }
                  else if(oldMeth == 5){
                    move_edges(i,j,j+1,j+2,cx,cy);
                    move_tets(i,j,j+1,j+2,cx,cy,sc,sc,sc,sc);
                    if(step>=nstep)
                      draw_glyphs(d0,d1,d2,d3,cx,cy);
                  }
                  else if(oldMeth == 6){
                    move_tets(i,j,j+1,j+2,cx,cy,sc,sc,sc,sc);
                    move_triangles(i,j,j+1,j+2,cx,cy,sc,sc,sc,sc);            
                    if(step>=nstep)
                      draw_glyphs(d0,d1,d2,d3,cx,cy);
                  }
                  else if(oldMeth == 9){
                    fullRel = 0;
                    move_edges(i,j,j+1,j+2,cx,cy);
                    move_tets(i,j,j+1,j+2,cx,cy,sc,sc,sc,sc);
                    move_triangles(i,j,j+1,j+2,cx,cy,sc,sc,sc,sc);            
                    if(step>=nstep)
                      draw_glyphs(d0,d1,d2,d3,cx,cy);
                  }
                  else{
                      if(oldYaxis == Yaxis && oldXaxis == Xaxis){
                        if(scaleFactor > detailThres || numData < 10){
                         detail_tet_in_glyph_inov(d0, d1, d2, d3, cx, cy);
                        }
                        else
                         draw_over_glyph(d0, d1, d2, d3, cx, cy);
                      }
                  }
                }
                
                  // axis animation
                  if(oldYaxis != Yaxis){
                    if(oldYaxis == 4)
                      oldcx = Xstart+gap*(i+j+j+1+j+2);
                     else
                      oldcx = Xend - ((float)sca(oldYaxis, 4, sc0, sc1, sc2, sc3)-r2min)*(Xend-Xstart)/(r2max-r2min);
                    if(step < nstep){
                      if(scaleFactor > detailThres)
                       detail_tet_in_glyph_inov(d0, d1, d2, d3, oldcx + step*(cx-oldcx)/nstep, cy);
                      draw_over_glyph(d0, d1, d2, d3, oldcx + step*(cx-oldcx)/nstep, cy);
                      step++;
                    }
                    if(step>=nstep){
                      if(scaleFactor > detailThres)
                       detail_tet_in_glyph_inov(d0, d1, d2, d3, cx, cy);
                      draw_over_glyph(d0, d1, d2, d3, cx, cy);
                    }
                  }
                  if(oldXaxis != Xaxis){
                    oldsc = sca(oldXaxis, 4, sc0, sc1, sc2, sc3);
                    oldcy = Yend - ((float)oldsc-r2min)*(Yend-Ystart)/(r2max-r2min);
                    if(step < nstep){
                      if(scaleFactor > detailThres)
                         detail_tet_in_glyph_inov(d0, d1, d2, d3, cx, oldcy + step*(cy-oldcy)/nstep);
                      draw_over_glyph(d0, d1, d2, d3, cx, oldcy +step*(cy-oldcy)/nstep);
                      step++;
                    }
                    if(step>=nstep){                            
                      if(scaleFactor > detailThres)
                       detail_tet_in_glyph_inov(d0, d1, d2, d3, cx, cy);
                      draw_over_glyph(d0, d1, d2, d3, cx, cy);
                    }
                  }
               }
            }
       
      }
      // end of glyphs
      // draw only tetrahedra
      if(vizMeth == 4 || vizMeth == 5 || vizMeth == 6 || vizMeth == 9){
        float cx=Xstart, cy=Ystart;
        float ccx=Xstart, ccy=Ystart;
        float ccx2=Xstart, ccy2=Ystart;
        double oldsc;
        float oldcx=Xstart, oldcy=Ystart;
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
                  
                  sc = sca(Xaxis, 4, sc0, sc1, sc2, sc3);
                  
                  if(filterDim > -1){
                    if(i!=filterDim && j != filterDim && j+1 != filterDim && j+2 != filterDim)
                      continue;
                  }
                                    
                  if(Yaxis == 4)
                    cx = Xstart+gap*(i+j+j+1+j+2-filterDim);
                  else
                    cx =Xend-((float)sca(Yaxis, 4, sc0, sc1, sc2, sc3)-r2min)*(Xend-Xstart)/(r2max-r2min);                  
                    
                  cy =Yend-((float)sc-r2min)*(Yend-Ystart)/(r2max-r2min);
                  if(filterDim > -1){
                     if(filterDim == 0) 
                       cx = Xstart+gap*((i+j+1)*3.8);
                     else
                       cx = Xstart+gap*((i+j-filterDim+3)*3.8);
                       
                     if((i+j+1)%8 == 1){
                       fill(255);
                       strokeWeight( 1 );
                       stroke(0, 0, 0);              
                       rect(cx-1.3*fon,Yend+fon,2.6*fon,4*fon+5);
                       strokeWeight( 2 );
                       fill(0);
                       textAlign(CENTER);
                       text(dimLabel[d0], cx, Yend+35);
                       text(dimLabel[d1], cx, Yend+50);
                       text(dimLabel[d2], cx, Yend+65);
                       text(dimLabel[d3], cx, Yend+80);
                     }                      
                  }
                  else{
                   if((j == (i+1) && j%8 == 1)  || numData < 10){
                       fill(255);
                       strokeWeight( 1 );
                       stroke(0, 0, 0);              
                       rect(cx-1.3*fon,Yend+fon,2.6*fon,4*fon+5);
                       strokeWeight( 2 );
                       fill(0);
                       textAlign(CENTER);
                       text(dimLabel[d0], cx, Yend+35);
                       text(dimLabel[d1], cx, Yend+50);
                       text(dimLabel[d2], cx, Yend+65);
                       text(dimLabel[d3], cx, Yend+80);                     
                   }
                  }
              
                  if(oldYaxis == Yaxis && oldXaxis == Xaxis){
                    // from triangle
                    if(oldMeth == 2 || oldMeth == 3 || oldMeth == 6){  
        
                        move_triangles(i,j,j+1,j+2,cx,cy,sc0,sc1,sc2,sc3); 
                        if(step>=nstep){
                          if(fullRel == 0)
                            draw_overview_tet(d0,d1,d2,d3,cx, cy,sc);
                          else
                            draw_full_tet(d0,d1,d2,d3,cx, sc0,sc1,sc2,sc3);
                        }            
                    }
                    else if(oldMeth == 1 || oldMeth == 3 || oldMeth == 5){
                      move_edges_to_tet(i,j,j+1,j+2,sc0,sc1,sc2,sc3,cx,cy);
                      if(step>=nstep){
                        if(fullRel == 0)
                          draw_overview_tet(d0,d1,d2,d3,cx, cy, sc);
                        else
                          draw_full_tet(d0,d1,d2,d3,cx,sc0,sc1,sc2,sc3);
                      }
                    }
                    else{
                      double ssc0 = R2_tet(d0, d1, d2, d3);        
                      double ssc1 = R2_tet(d1, d0, d2, d3);
                      double ssc2 = R2_tet(d2, d1, d0, d3);
                      double ssc3 = R2_tet(d3, d1, d2, d0);
                      double ssc = sca(Xaxis, 4, ssc0, ssc1, ssc2, ssc3);
                      if(Yaxis == 4)
                        ccx = Xstart+gap*(i+j+j+1+j+2);
                        //ccx = gap*(i+j);
                      else
                        ccx = Xend - ((float)sca(Yaxis, 4, ssc0, ssc1, ssc2, ssc3)-r2min)*(Xend-Xstart)/(r2max-r2min);
                      
                      ccy = Yend -  ((float)ssc-r2min)*(Yend-Ystart)/(r2max-r2min); 
                      
                      if(fullRel == 0){
                        if(oldMeth == 4 && vizMeth == 4){
                          if(ssc > lower_threshold && ssc < upper_threshold){
                            if(step < nstep){ 
                              draw_full_move_tet(d0,d1,d2,d3,ccx, cx, step,sc0, sc1, sc2, sc3,ssc,ssc,ssc,ssc);
                              step += 1;
                            }    
                            else if(step>=nstep){
                              draw_overview_tet(d0,d1,d2,d3,cx, cy, sc);
                            }  
                          }  
                        }
                        else if (oldYaxis == Yaxis && oldXaxis == Xaxis)
                          draw_overview_tet(d0,d1,d2,d3,cx, cy, sc);
                      }
                      else{
                        if((oldMeth == 4 && vizMeth == 4) || (oldMeth == 7&&fullRel == 1)){
                          if(ssc > lower_threshold && ssc < upper_threshold){
                            if(step < nstep){ 
                              draw_full_move_tet(d0,d1,d2,d3,ccx, cx, step,ssc,ssc,ssc,ssc,sc0, sc1, sc2, sc3);
                              step += 1;
                            }    
                            else if(step>=nstep){
                              draw_full_tet(d0,d1,d2,d3,cx,sc0,sc1,sc2,sc3);
                            }  
                          }  
                        }
                        else if (oldYaxis == Yaxis && oldXaxis == Xaxis)
                          draw_full_tet(d0,d1,d2,d3,cx,sc0,sc1,sc2,sc3);
                      }
                    }
                  }
                  // axis animation
                  if(oldYaxis != Yaxis){
                    float ssc = (float)sca(oldYaxis, 4, sc0, sc1, sc2, sc3);
                    if(oldYaxis == 4)
                      oldcx = Xstart+gap*(i+j+j+1+j+2);
                     else
                      oldcx = Xend - (ssc-r2min)*(Xend-Xstart)/(r2max-r2min);
                    if(step < nstep){
                      draw_overview_tet(d0,d1,d2,d3,oldcx + step*(cx-oldcx)/nstep, cy, ssc);
                      step++;
                    }
                    if(step>=nstep){
                      if(fullRel == 0)
                        draw_overview_tet(d0,d1,d2,d3,cx, cy, sc);
                      else
                        draw_full_tet(d0,d1,d2,d3,cx,sc0,sc1,sc2,sc3);
                    }
                  }
                  else if(oldXaxis != Xaxis){
                    oldsc = sca(oldXaxis, 4, sc0, sc1, sc2, sc3);
                    oldcy = Yend - (float)oldsc*(Yend-Ystart);
                    if(step < nstep){
                      draw_overview_tet(d0,d1,d2,d3,cx, oldcy + step*(cy-oldcy)/nstep, oldsc);
                      step++;
                    }
                    if(step>=nstep){                            
                       if(fullRel == 0)
                        draw_overview_tet(d0,d1,d2,d3,cx, cy, sc);
                      else
                        draw_full_tet(d0,d1,d2,d3,cx,sc0,sc1,sc2,sc3);
                    }
                  }
          }
        }
      }
      // end tets
      // only triangles
      if(vizMeth == 2 || vizMeth == 3 || vizMeth == 6 || vizMeth == 9){
        float cx=Xstart, cy=Ystart;
        float ccx=Xstart, ccy=Ystart;
        float ccx2=Xstart, ccy2=Ystart;
        double oldsc;
        float oldcx=Xstart, oldcy=Ystart;
        for( int i=0; i<numData-2; i++ ){
          for(int j=i+1; j<numData-1; j++){
                int d0 = i;
                int d1 = j;
                int d2 = j+1;
                  
                double sc0 = R2_triangle(d0, d1, d2);        
                double sc1 = R2_triangle(d1, d0, d2);
                double sc2 = R2_triangle(d2, d1, d0);
                
                sc = sca(Xaxis, 3, sc0, sc1, sc2, 0);
               
                if(Yaxis == 4)
                  cx = Xstart+gap*(i+j+j+1+j);
                else
                  cx = Xend - ((float)sca(Yaxis, 3, sc0, sc1, sc2, 0)-r2min)*(Xend-Xstart)/(r2max-r2min);
                  
                cy = Yend - ((float)sc-r2min)*(Yend-Ystart)/(r2max-r2min);  
                
                if(filterDim > -1){
                  if(i!=filterDim && j != filterDim && j+1 != filterDim && j+2 != filterDim)
                    continue;
                }
                if(filterDim > -1){
                   if(filterDim == 0) 
                     cx = Xstart+gap*((i+j+1)*4.8);
                   else
                     cx = Xstart+gap*((i+j-filterDim+3)*4.8);
                   if(vizMeth == 2 || vizMeth == 3) {   
                     fill(255);
                     strokeWeight( 1 );
                     stroke(0, 0, 0);              
                     rect(cx-10,Yend+20,22,32);
                     strokeWeight( 2 );
                     fill(0);
                     textAlign(CENTER);
                     text(dimLabel[d0], cx, Yend+30);
                     text(dimLabel[d1], cx, Yend+40);
                     text(dimLabel[d2], cx, Yend+50); 
                   }
                }
                else{
                 if((j == (i+1) && j%2 == 1)  || numData < 10){
                   if(vizMeth == 2 || vizMeth == 3) { 
                     fill(255);
                     strokeWeight( 1 );
                     stroke(0, 0, 0);              
                     rect(cx-fon,Yend+fon,2*fon,3*fon+5);
                     strokeWeight( 2 );
                     fill(0);
                     textAlign(CENTER);
                     text(dimLabel[d0], cx, Yend+35);
                     text(dimLabel[d1], cx, Yend+50);
                     text(dimLabel[d2], cx, Yend+65);
                   }
                 }
                }
              
                if(oldYaxis == Yaxis && oldXaxis == Xaxis){
                  // from tetrahedra to triangle
                  if(oldMeth == 4 || oldMeth == 5 || oldMeth == 6 || oldMeth == 7){
                    if(j<(numData-2) && i<(numData-3)){
                      int d3 = j+2;
                      double ssc0 = R2_tet(d0, d1, d2, d3);        
                      double ssc1 = R2_tet(d1, d0, d2, d3);
                      double ssc2 = R2_tet(d2, d1, d0, d3);
                      double ssc3 = R2_tet(d3, d1, d2, d0);
                      double ssc = sca(Xaxis, 4, ssc0, ssc1, ssc2, ssc3);
                      
                      if(Yaxis == 4)
                        ccx =Xstart+gap*(i+j+j+1+j+2);
                      else
                        ccx = Xend - ((float)sca(Yaxis, 4, ssc0, ssc1, ssc2, ssc3)-r2min)*(Xend-Xstart)/(r2max-r2min);
                      
                      ccy = Yend -  ((float)ssc-r2min)*(Yend-Ystart)/(r2max-r2min);    
                      if(ssc > lower_threshold && ssc < upper_threshold){
                        if(step < nstep){                        
                          move_in_triangles(i,j,j+1, ccx, ccy, ssc0, ssc1, ssc2, ssc3, ssc);
                          move_in_triangles(i,j+1,j+2, ccx, ccy, ssc0, ssc1, ssc2, ssc3, ssc);
                          move_in_triangles(j,j+1,j+2, ccx, ccy, ssc0, ssc1, ssc2, ssc3, ssc); 
                          step += 1;
                        }
                      }
                    }              
                    if(step>=nstep){
                      if(fullRel == 0)
                        draw_overview_tri(d0,d1,d2,cx, cy, sc);
                      else
                        draw_full_tri(d0,d1,d2,cx, sc0, sc1, sc2);
                    } 
                  }
                  else if(oldMeth == 1 || oldMeth == 3 || oldMeth == 5){
                    move_edges_to_tri(i,j,j+1,sc0,sc1,sc2,cx,cy);
                    if(step>=nstep){
                       if(fullRel == 0)
                         draw_overview_tri(d0,d1,d2,cx, cy, sc);
                       else
                         draw_full_tri(d0,d1,d2,cx, sc0, sc1, sc2);
                    }
                  }
                  else{ 
                    if(Yaxis == 4)
                          ccx = Xstart+gap*(i+j+j+1+j);
                        else
                          ccx = Xend - ((float)sca(Yaxis, 4, sc0, sc1, sc2, 0)-r2min)*(Xend-Xstart)/(r2max-r2min);
                          
                     if(fullRel == 0){       
                        if((oldMeth == 2 && vizMeth == 2)){
                          if(sc > lower_threshold && sc < upper_threshold){
                            if(step < nstep){ 
                              draw_full_move_tri(d0,d1,d2,ccx, cx, step, sc0, sc1, sc2, sc,sc,sc);
                              step += 1;
                            }    
                            else if(step>=nstep){
                              draw_overview_tri(d0,d1,d2,cx, cy, sc);
                            }  
                          }  
                        }
                        else if (oldYaxis == Yaxis && oldXaxis == Xaxis){
                          draw_overview_tri(d0,d1,d2,cx, cy, sc);
                        }
                     }
                     else{
                       if(oldMeth == 2 && vizMeth == 2){
                        if(sc > lower_threshold && sc < upper_threshold){
                          if(step < nstep){ 
                            draw_full_move_tri(d0,d1,d2,ccx, cx, step, sc,sc,sc,sc0, sc1, sc2);
                            step += 1;
                          }    
                          else if(step>=nstep){
                            draw_full_tri(d0,d1,d2,cx, sc0, sc1, sc2);
                          }  
                        }  
                      }
                      else if (oldYaxis == Yaxis && oldXaxis == Xaxis){
                        draw_full_tri(d0,d1,d2,cx, sc0, sc1, sc2);    
                      }
                     }
                  }
                }
                
                 
                  // axis animation
                  if(oldYaxis != Yaxis){
                    float ssc = (float)sca(oldYaxis, 3, sc0, sc1, sc2, 0);
                    if(oldYaxis == 4)
                      oldcx = Xstart+gap*(i+j+j+1+j);
                     else
                      oldcx = Xend - (ssc-r2min)*(Xend-Xstart)/(r2max-r2min);
                    if(step < nstep){
                      draw_overview_tri(d0,d1,d2,oldcx + step*(cx-oldcx)/nstep, cy, ssc);
                      step++;
                    }
                    if(step>=nstep){
                      if(fullRel == 0)
                       draw_overview_tri(d0,d1,d2,cx, cy, sc);
                     else
                       draw_full_tri(d0,d1,d2,cx, sc0, sc1, sc2);
                    }
                  }
                  else if(oldXaxis != Xaxis){
                    oldsc = sca(oldXaxis, 3, sc0, sc1, sc2,0);
                    oldcy = Yend - (float)oldsc*(Yend-Ystart);
                    if(step < nstep){
                      draw_overview_tri(d0,d1,d2,cx, oldcy + step*(cy-oldcy)/nstep, oldsc);
                      step++;
                    }
                    if(step>=nstep){                            
                      if(fullRel == 0)
                         draw_overview_tri(d0,d1,d2,cx, cy, sc);
                       else
                         draw_full_tri(d0,d1,d2,cx, sc0, sc1, sc2); 
                    }
                  }
          }
        }
      }
      // end triangle
      // draw only pair-wise
      if(vizMeth == 1 || vizMeth == 3 || vizMeth == 5 || vizMeth == 9){
        float cx=Xstart, cy=Ystart;
        float ccx=Xstart, ccy=Ystart;
        double oldsc;
        float oldcx=Xstart, oldcy=Ystart;
        for( int i=0; i<numData-1; i++ ){
          for(int j=i+1; j<numData; j++){
                int d0 = i;
                int d1 = j;
                
                double pc = pcc[d0][d1];
                sc = pc*pc;
                
                if(Yaxis == 4)
                  cx =Xstart+gap*(i+2.9*j);
                else
                  cx = Xend - ((float)sc-r2min)*(Xend-Xstart)/(r2max-r2min);
                
                cy = Yend - ((float)sc-r2min)*(Yend-Ystart)/(r2max-r2min);       
           
                if(scaleFactor > detailThres){  
                  stroke(0,0,0);
                  strokeWeight(8);
                  smooth();
                  point(cx, cy);
                }   
                
                if(filterDim > -1){
                  if(i!=filterDim && j != filterDim && j+1 != filterDim && j+2 != filterDim)
                    continue;
                }
                if(filterDim > -1){
                   if(filterDim == 0) 
                     cx = Xstart+gap*((i+2.9*j))*3.2;
                   else
                     cx = Xstart+gap*((i+j-filterDim+3)*3.2);
                   if(vizMeth == 1) {   
                     fill(255);
                     strokeWeight( 1 );
                     stroke(0, 0, 0);              
                     rect(cx-10,Yend+20,22,22);
                     strokeWeight( 2 );
                     fill(0);
                     textAlign(CENTER);
                     text(dimLabel[d0], cx, Yend+30);
                     text(dimLabel[d1], cx, Yend+40);
                   }
                }
                else{
                 if((j == (i+1) && j%2 == 1)  || numData < 10){
                   if(vizMeth == 1) {   
                     fill(255);
                     strokeWeight( 1 );
                     stroke(0, 0, 0);              
                     rect(cx-fon,Yend+fon,2*fon,2*fon+5);
                     strokeWeight( 2 );
                     fill(0);
                     textAlign(CENTER);
                     text(dimLabel[d0], cx, Yend+35);
                     text(dimLabel[d1], cx, Yend+50);
                   }
                 }
                }
              
                  
                // from tetrahedra to edges
                if(oldMeth == 7 || oldMeth == 4 || oldMeth == 5 || oldMeth == 6){
                  if(j<(numData-2) && i<(numData-3))
                    move_tets_to_edges(i,j,j+1,j+2,cx,cy,sc);
                  if(step>=nstep)
                    draw_overview_edge(d0,d1,cx, cy, sc);
                }
                // from edges to triangles
                if(oldMeth == 2 || oldMeth == 3 || oldMeth == 6){
                  if(j<(numData-1) && i<(numData-2))
                     move_tri_to_edges(i,j,j+1);
                  if(step>=nstep)
                    draw_overview_edge(d0,d1,cx, cy, sc);
                }
                else if(vizMeth == 1){          
                  draw_overview_edge(d0,d1,cx, cy, sc);          
                }     
                 // axis animation
                  if(oldYaxis != Yaxis){
                    float ssc = (float)sc;
                    if(oldYaxis == 4)
                      oldcx = Xstart+gap*(i+2.9*j);
                     else
                      oldcx = Xend - (ssc-r2min)*(Xend-Xstart)/(r2max-r2min);
                    if(step < nstep){
                      draw_overview_edge(d0,d1,oldcx + step*(cx-oldcx)/nstep, cy, ssc);
                      step++;
                    }
                    if(step>=nstep){
                       draw_overview_edge(d0,d1,cx, cy, sc);
                    }
                  }
                  else if(oldXaxis != Xaxis){
                    oldsc = sc;
                    oldcy = Yend - ((float)oldsc-r2min)*(Yend-Ystart)/(r2max-r2min);
                    if(step < nstep){
                      draw_overview_edge(d0,d1,cx, oldcy + step*(cy-oldcy)/nstep, oldsc);
                      step++;
                    }
                    if(step>=nstep){      
                         draw_overview_edge(d0,d1,cx, cy, sc);
                    }
                  }
          }
        }
      }
  
  popMatrix();  
}