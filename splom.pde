/* 
* Multi-dependencies Visualization
* Hoa Nguyen 
*/

float getX( float vx, float w1 , float u1){
  return u1 + MathX.lerp( 0, w1, (vx - x_min) / (x_max-x_min) );
}

float getY( float vy , float h1, float v1){
  return v1 + MathX.lerp( h1, 0, (vy - y_min) / (y_max-y_min) );
}

void scatterPlot( int d0, int d1, float u1, float v1, float w1, float h1 ){
  ReadableAttribute attr0 = dat.get(d0);
  ReadableAttribute attr1 = dat.get(d1);
  
  dw.noStroke();
  dw.fill( 255 );
  dw.rect( u1-20, v1, w1+20, h1+30);
  dw.strokeWeight( 2 );
  dw.stroke(0, 0, 200);
  if( attr0 != null && attr1 != null ){
    if(attr0.size() < 10000){
      for (int i = 0; i < Math.min( attr0.size(), attr1.size()); i++) {
        dw.point( getX( attr0.getNormalized( i ) ,w1,u1), getY( attr1.getNormalized( i ) ,h1,v1) );
      }
    }
    else{
      for (int i = 0; i < Math.min( attr0.size(), attr1.size()); i+= (attr0.size()/5000)) {
        dw.point( getX( attr0.getNormalized( i ) ,w1,u1), getY( attr1.getNormalized( i ) ,h1,v1) );
      }
    }
  }
  
  /*
  dw.noFill( );
  dw.stroke( 0 );
  dw.strokeWeight( 1 );
  dw.rect( u1, v1, w1, h1 );
  */
  dw.strokeWeight( 2 );
  dw.stroke(0, 0, 0);
  dw_arrow(u1, v1+h1, u1, v1);
  dw_arrow(u1, v1+h1, u1+w1, v1+h1);
  
  dw.noStroke();
  dw.fill(0);
  dw.text(dimLabel[d1],u1-25,v1+h1/2);
  dw.text(dimLabel[d0],u1+w1/2-10,v1+h1+15);    
}

void splomPlots(int np){
  u0 = 0;
  v0 = dw.width;
  w = dw.width;
  h = w;  
  float s = 40;
  float wsp = (h-np*(s-1))/(np-1);
  dw.noFill( );
  dw.stroke( 0 );
  dw.strokeWeight( 1 );
  dw.rect( u0, v0+s/2, w-5, h-s/2 );
  
   
  for(int i=0;i<(np-1);i++){
    for(int j=i+1;j<(np);j++){
      scatterPlot( sp[i], sp[j], u0 + (i+1)*s+i*wsp, v0 + j*s+(j-1)*wsp, wsp, wsp );
    } 
  }  
}