data nutrient;
infile 'v:\505\datasets\nutrient.txt';
input id calcium iron protein vitA vitC;
run;

proc print data=nutrient;
var calcium iron;
run;

proc corr data=nutrient cov;
var calcium iron;
run;

data ex1;
input x1 x2;
cards;
6 3
10 4
12 7
12 6
;
run;

ods rtf file='v:\505\ex1.rtf';
proc corr data=ex1 cov noprob;
run;
ods rtf close;
