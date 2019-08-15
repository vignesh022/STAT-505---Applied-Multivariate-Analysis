options nodate nonumber ls=78; 
	*suppress date and set printer linesize to 78;
title 'SAS intro, 8/24'; 

/* 

various comments

*/

data temp; 
	*defines temporary dataset temp;
	*also stands for work.temp;
input v1 v2 v3 $ @@; 
	*$ tells sas that v3 is not numerical;
	*@@ allows for multiple v1 v2 v3 inputs on same line;
	*datalines is alternate word for cards;
s_v1 = v1**.5; 
	*s_v1 is the sqrt of v1;
cards; 
1 2 a 3 4 b 5 6 c
; 
run;

data temp2;
set temp;
	*uses the existing dataset temp;
ss_v1 = v1**.25;
l_v1 = log(v1);
e_v1 = exp(v1);
	*these new variables will be added to temp2, along with all the variables from temp;
run;

proc print data=temp2;
var v1 ss_v1 l_v1 e_v1;
	*prints just the specified variable;
run;

data nutrient;
infile 'v:\505\datasets\nutrient.txt';
	*reads the data from the nutrient.txt file into a dataset called nutrient;
input id calcium iron protein vitA vitC;
l_cal = log(calcium);
s_cal = calcium**.5;
ss_cal = calcium**.25;
run;

ods rtf file='v:\505\fall16\8-24.rtf';
proc univariate data=nutrient;
*var calcium s_cal ss_cal l_cal;
histogram calcium s_cal ss_cal l_cal;
run;
ods rtf close;

ods graphics on;
proc corr data=nutrient noprob plots (maxpoints=75000)=matrix;
	*noprob suppresses the p-values for the correlations;
	*maxpoints=75000 overrides the existing max points for plotting;
run;
ods graphics off;


/* introduction to proc iml */

proc iml;
  a = 2; *scalar;
  b = {1 2 3}; *1x3 matrix (row vector);
  c = {1 2 3, 4 5 6}; *2x3 matrix;
  d = a*b+c[2,]; *element-wise operations;
  e = b#d; *element-wise multiplication;
  f = b*t(c); *matrix multiplication: b by transpose of c;
  print a b c d e f;
  quit;

* computation of total and generalized variance;
proc corr data=nutrient nocorr nosimple cov out=output; *saves the covariance matrix;
  var calcium iron protein vitA vitC;
  run;

proc print data=output (where=(_TYPE_="COV"));
  var calcium iron protein vitA vitC;
  run;

proc iml;
  use output where(_TYPE_="COV");
  read all var _NUM_ into S[colname=varNames];
  totvar=trace(S);
  genvar=det(S);
  print totvar genvar;
  quit;

* creating a data set from an iml matrix;
proc iml;
  x1 = {3,6,3};
  x2 = {4,-2,1};
  id = {1 2 3};
  create new var {id x1 x2};
  append;
  close new; 
  quit;
  proc corr data=new cov;
  var x1 x2;
  run;

* some misc functions;
proc iml;
  a = I(3); *3x3 identity matrix;
  b = diag({1 2 3}); *3x3 matrix with 1 2 3 on the diagonal;
  c = inv(b); *matrix inverse;
  d = b*c; *should equal the identity;
  print a b c d;
  quit;

