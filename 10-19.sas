options ls=78;
/*
Data were collected on two species of insects: 'a' and 'b'
Three variables were measured on each insect:
  X1 = Width of the 1st joint of the tarsus (legs)
  X2 = Width of the 2nd joint of the tarsus
  X3 = Width of the aedeagus (sec organ)
We have ten individuals of each species to make up training data.
The goal is to classify the species for a specimen with x1=194 x2=124 x3=49
We also assume equal prior probabilities
*/
data insect;
  infile "v:\505\datasets\insect.dat";
  input species $ joint1 joint2 aedeagus;
  run;

*using SAS discriminant procedure (equal priors default);
data test;
  input joint1 joint2 aedeagus;
  cards;
  194 124 49
  ; run;
proc discrim data=insect pool=test crossvalidate testdata=test testout=a;
  class species;
  var joint1 joint2 aedeagus;
  run;
proc print data=a;
  run;

*unequal priors;
data test;
  input joint1 joint2 aedeagus;
  cards;
  194 124 49
  ; run;
proc discrim data=insect pool=test crossvalidate testdata=test testout=b;
  class species;
  var joint1 joint2 aedeagus;
  priors 'a'=.9 'b'=.1;
  run;
proc print data=b;
  run;

*unequal covariances;
data swiss;
  infile "v:\505\datasets\swiss3.dat";
  input type $ length left right bottom top diag;
  run;
data test2;
  input length left right bottom top diag;
  cards;
  214.9 130.1 129.9 9 10.6 140.5
  ; run;
proc discrim data=swiss pool=test crossvalidate testdata=test2 testout=c;
  class type;
  var length left right bottom top diag;
  priors "real"=0.99 "fake"=0.01;
  run;
proc print data=c;
  run;
