
options ls=78;

* in-class example;
data rmatrix(type=corr);
  input _type_ $ lit engl math phys econ hist;
  cards;
corr  1.0000 0.730 0.370 0.430 0.405 0.7345
corr  0.7300 1.000 0.320 0.380 0.360 0.6860
corr  0.3700 0.320 1.000 0.620 0.540 0.2840
corr  0.4300 0.380 0.620 1.000 0.510 0.3510
corr  0.4050 0.360 0.540 0.510 1.000 0.3360
corr  0.7345 0.686 0.284 0.351 0.336 1.0000
n  200 200 200 200 200 200
; run; 
proc princomp data=rmatrix;
  var lit engl math phys econ hist;
  run;
proc factor data=rmatrix method=principal rotate=varimax nfactors=2;
  var lit engl math phys econ hist;
  run;

/*
Places Rated Almanac data (Boyer and Savageau) which rates 329 communities according to nine criteria:
  Climate and Terrain
  Housing
  Health Care & Environment
  Crime
  Transportation
  Education
  The Arts
  Recreation
  Economics
Notes:
  The data for many of the variables are strongly skewed to the right.
  The log transformation was used to normalize the data.
*/
data places;
  infile "v:\505\datasets\places.dat";
  input climate housing health crime trans educate arts recreate econ id;
  climate=log10(climate);
  housing=log10(housing);
  health=log10(health);
  crime=log10(crime);
  trans=log10(trans);
  educate=log10(educate);
  arts=log10(arts);
  recreate=log10(recreate);
  econ=log10(econ);
  run;
proc factor method=principal nfactors=3 rotate=varimax simple scree ev preplot
     plot residuals;
  var climate housing health crime trans educate arts recreate econ;
  run;
