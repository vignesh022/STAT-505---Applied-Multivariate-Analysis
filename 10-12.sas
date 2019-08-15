/*
g = 4 treatment groups:
  1 = Control - no surgical treatment is applied
  2 = Extrinsic cardiac denervation immediately prior to treatment.
  3 = Bilateral thoracic sympathectomy and stellectomy 3 weeks prior to treatment.
  4 = Extrinsic cardiac denervation 3 weeks prior to treatment.

p = 4 potassium levels measured at 1, 5, 9, and 13 minutes following a procedure
n_i = 9,8,9,10 dogs at treatments 1,2,3,4, respectively
*/
options ls=78;
data dogs;
  infile 'v:\505\datasets\dog1.dat';
  input treat dog p1 p2 p3 p4;
  run;
data dogs2;
  set dogs;
  time=1;  k=p1; output;
  time=5;  k=p2; output;
  time=9;  k=p3; output;
  time=13; k=p4; output;
  drop p1 p2 p3 p4;
  run;

*profile plots;
proc sort data=dogs2;
  by treat time;
  run;
proc means data=dogs2;
  by treat time;
  var k;
  output out=a mean=mean;
  run;
proc gplot data=a;
  axis1 length=4 in;
  axis2 length=6 in;
  plot mean*time=treat / vaxis=axis1 haxis=axis2;
  symbol1 v=J f=special h=2 i=join color=black;
  symbol2 v=K f=special h=2 i=join color=black;
  symbol3 v=L f=special h=2 i=join color=black;
  symbol4 v=M f=special h=2 i=join color=black;
  run; quit;

*manova approach;
*test for interaction with contrasts;
proc glm data=dogs;
  class treat;
  model p1 p2 p3 p4=treat;
  manova h=treat m=p1-p2,p2-p3,p3-p4 / printh printe; *test for treat*time interaction;
  manova h=treat m=p1+p2+p3+p4 / printh printe; *test for treat main effect;
  run; quit;
