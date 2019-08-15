options ls=78;
title "STAT 505 - Final Exam";
data wolves;
infile 'X:\STAT 505\wolves.dat' delimiter='09'x;
input id location $ x1 x2 x3 x4 x5 x6 x7 x8 x9;
run;
proc princomp data=wolves;
  var x1 x2 x3 x4 x5 x6 x7 x8 x9;
  run; quit;
