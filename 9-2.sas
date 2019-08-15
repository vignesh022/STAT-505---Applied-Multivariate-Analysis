options ls=78;
/*
  37 subjects taking the Wechsler adult intelligence test
  information (info), 
  similarities (sim), 
  arithmetic (arith), 
  picture completion (pic)
  */
data wechsler;
  infile 'v:\505\datasets\wechsler.dat';
  input id info sim arith pict;
  *pict2 = pict**2;
  run;

proc sgplot data=wechsler;
  scatter x=info y=sim;
  ellipse x=info y=sim / alpha=.32;  
  ellipse x=info y=sim / alpha=.05;
  ellipse x=info y=sim / alpha=.002;   
  run;

*univariate plots;
proc univariate data=wechsler;
  var info sim;
  *var pict pict2;
  histogram / normal;
  qqplot / normal;
  run;

*multivariate qq plot;
proc princomp data=wechsler std out=pcresult; 
  var info sim arith pict;
  run;
data pcresult;
  set pcresult;
  dist2=uss(of prin1-prin4); *these are the squared statistial distances;
  run;
proc sort data=pcresult;
  by dist2;
  run;
data plotdata;
  set pcresult;
  prb=(_n_ -.5)/37; *37 is the sample size;
  chiquant=cinv(prb,4); *chisq quantiles for plotting;
  run;
proc gplot data=plotdata;
  plot dist2*chiquant;
  run; quit;



