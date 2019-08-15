options ls=78;
title "STAT 505 - Homework 9";
*Question 1*;
data air;
  infile 'X:\STAT 505\air.dat';
  input wind solar CO NO NO2 O3 HC;
  run;
proc princomp data=air cov out=a;
  var wind solar CO NO NO2 O3 HC;
  run;
proc print data=a; 
  var prin1-prin7;
  run;
proc corr data=a;
  var prin1 prin2 prin3 wind solar CO NO NO2 O3 HC;
  run; quit;
proc princomp data=air out=b;
  var wind solar CO NO NO2 O3 HC;
  run;
proc print data=b; 
  var prin1-prin7;
  run;
proc corr data=b;
  var prin1 prin2 prin3 wind solar CO NO NO2 O3 HC;
  run; quit;
*Question 2*;
data track;
infile "X:\STAT 505\track.dat";
input d100 d200 d400 d800 d1500 d5000 d10000 marathon country $;
d100=d100/60;
d200=d200/60;
d400=d400/60;
run;
proc princomp data=track cov out=a;
  var d100 d200 d400 d800 d1500 d5000 d10000 marathon;
  run;
proc corr data=a;
  var prin1 prin2 prin3 d100 d200 d400 d800 d1500 d5000 d10000 marathon;
  run;
proc gplot data=a;
  axis1 length=5 in;
  axis2 length=5 in;
  plot prin2*prin1 / vaxis=axis1 haxis=axis2;
  symbol v=J f=special h=2 i=none color=black;
  run; quit;
proc sort data=a;
by prin1;
proc print;
id country;
var prin1;
run; quit;
proc princomp data=track out=b;
  var d100 d200 d400 d800 d1500 d5000 d10000 marathon;
  run;
proc corr data=b;
  var prin1 prin2 prin3 d100 d200 d400 d800 d1500 d5000 d10000 marathon;
  run;
proc gplot;
  axis1 length=5 in;
  axis2 length=5 in;
  plot prin2*prin1 / vaxis=axis1 haxis=axis2;
  symbol v=J f=special h=2 i=none color=black;
  run; quit;
proc sort data=b;
by prin1;
proc print;
id country;
var prin1;
run; quit;
proc sort data=b;
by prin2;
proc print;
id country;
var prin2;
run; quit;
