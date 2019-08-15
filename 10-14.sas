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

*random effects approach;
*split plot model;
proc mixed data=dogs2;
  class treat dog time;
  model k=treat|time;
  repeated / subject=dog(treat) type=cs;
  run;
*autoregressive model;
proc mixed data=dogs2;
  class treat dog time;
  model k=treat|time;
  random dog(treat);
  repeated / subject=dog(treat) type=ar(1);
  run;
*autoregressive + moving averages model;
proc mixed data=dogs2;
  class treat dog time;
  model k=treat|time;
  random dog(treat);
  repeated / subject=dog(treat) type=arma(1,1);
  run;
*toeplitz model;
proc mixed data=dogs2;
  class treat dog time;
  model k=treat|time;
  random dog(treat) ;
  repeated / subject=dog(treat) type=toep;
  run;


