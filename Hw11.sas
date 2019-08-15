/*
Paper and Fiber characteristics
*/
options ls=78;
data paper;
  infile "X:\STAT 505\paper.dat" delimiter = '09'x;
  input x1 x2 x3 x4 y1 y2 y3 y4;
  run;
proc corr data=paper out=corr_out cov noprob;
  var x1 x2 x3 x4 y1 y2 y3 y4;
  run; 

proc cancorr data=paper out=canout vprefix=paper vname="Paper Characteristics"
                       wprefix=fiber wname="Fiber Characteristics";
  var x1 x2 x3 x4; *group of x-variables;
  with y1 y2 y3 y4; *group of y-variables;
  run; quit;
proc gplot data=canout;
  axis1 length=3 in;
  axis2 length=4.5 in;
  plot paper1*fiber1 / vaxis=axis1 haxis=axis2; *first cancorr pair;
  symbol v=J f=special h=2 i=r color=black;
  run; quit;
/*
Sales performance vs Test scores
  */
data sales;
  infile "X:\STAT 505\sales.txt";
  input growth profit new create mech abs math;
  run;
proc corr data=sales out=corr_out cov noprob;
  var growth profit mech abs math;
  run;

proc cancorr data=sales out=canout vprefix=sales vname="Sales Variables"
                       wprefix=scores wname="Test Scores";
  var growth profit ; *group of x-variables;
  with mech abs math; *group of y-variables;
  run;
proc gplot data=canout;
  axis1 length=3 in;
  axis2 length=4.5 in;
  plot sales1*scores1 / vaxis=axis1 haxis=axis2; *first cancorr pair;
  symbol v=J f=special h=2 i=r color=black;
  run;
