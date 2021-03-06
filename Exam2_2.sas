options ls=78;
title "Ratings - Exam 2 Question 2 - STAT 505";
data ratings;
infile 'X:\STAT 505\ratings.dat' delimiter='09'x;
input renew q1 q2;
run;
proc gplot data=ratings;
plot q2*q1=renew;
symbol1 v=b f=special h=2 i=join color=red interpol=none;
symbol2 v=a f=special h=2 i=join color=green interpol=none;
run; quit;
proc discrim data=ratings pool=test crossvalidate;
class renew;
var q1 q2;
priors '1'=0.6 '0'=0.4;
run;
data test;
input q1 q2;
cards;
4 6
; run;
proc discrim data=ratings pool=test crossvalidate testdata=test testout=a;
class renew;
var q1 q2;
priors '1'=0.6 '0'=0.4;
run;
proc print data=a;
run;
