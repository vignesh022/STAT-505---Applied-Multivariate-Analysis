/*
We will use the Places Rated Almanac data (Boyer and Savageau) which rates 329 communities according to nine criteria:
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
options ls=78;
data places;
  infile 'X:\STAT 505\places.txt';
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

* SAS default is to do pca on the correlation matrix, the cov option specifies covariance matrix;
proc princomp data=places cov out=a;
  var climate housing health crime trans educate arts recreate econ;
  run;
proc print data=a; 
  var prin1-prin9;
  run;
proc corr data=a;
  var prin1 prin2 prin3 climate housing health crime trans educate arts 
      recreate econ;
  run;
proc gplot data=a;
  axis1 length=5 in;
  axis2 length=5 in;
  plot prin2*prin1 / vaxis=axis1 haxis=axis2;
  symbol v=J f=special h=2 i=none color=black;
  run;

* correlation approach (standardized);
proc princomp data=places out=b;
  var climate housing health crime trans educate arts recreate econ;
  run;
proc print data=b; 
  var prin1-prin9;
  run;
proc corr data=b;
  var prin1 prin2 prin3 climate housing health crime trans educate arts 
      recreate econ;
  run;
proc gplot;
  axis1 length=5 in;
  axis2 length=5 in;
  plot prin2*prin1 / vaxis=axis1 haxis=axis2;
  symbol v=J f=special h=2 i=none color=black;
  run;
