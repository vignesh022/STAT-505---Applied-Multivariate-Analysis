
options ls=78;
data swiss;
  infile "v:\505\datasets\swiss3.dat";
  input type $ length left right bottom top diag;
  run;
proc sort data=swiss;
  by type;
  run;

* Bartlett's test for equal covariance matrices;
proc discrim data=swiss pool=test;
  class type;
  var length left right bottom top diag;
  run;

* 2-Sample Hotellings T2 (unequal variances);
proc corr data=swiss nocorr cov out=swiss_out;
  by type;
  var length left right bottom top diag;
  run;
proc iml;
use swiss_out;
  read all var _NUM_ where(_TYPE_="MEAN" & type='real') into xbar1[colname=varnames];;
  read all var _NUM_ where(_TYPE_="MEAN" & type='fake') into xbar2;
  read all var _NUM_ where(_TYPE_="N" & type='real') into n1;
  read all var _NUM_ where(_TYPE_="N" & type='fake') into n2;
  read all var _NUM_ where(_TYPE_="COV" & type='real') into S1;
  read all var _NUM_ where(_TYPE_="COV" & type='fake') into S2;
  varnames=t(varNames);
  xbar1 = t(xbar1);
  xbar2 = t(xbar2);
  n1 = n1[1];
  n2 = n2[1];
  p = nrow(S1);
  Sp = ((n1-1)*S1+(n2-1)*S2)*(1/(n1+n2-2));
  print varnames xbar1 xbar2;
  print s1 s2 sp;

* hypothesis test for equal group mean vectors;
  t2 = t(xbar1-xbar2)*inv((1/n1)*s1+(1/n2)*s2)*(xbar1-xbar2);
  f = (n1+n2-p-1)*t2/p/(n1+n2-2);
  df1 = p;
  St = (1/n1)*s1+(1/n2)*s2;
  temp = (t(xbar1-xbar2)*inv(st)*(s1/n1)*inv(st)*(xbar1-xbar2)/t2)**2/(n1-1);
  temp = temp+(t(xbar1-xbar2)*inv(st)*(s2/n2)*inv(st)*(xbar1-xbar2)/t2)**2/(n2-1);
  df2 = 1/temp;
  pval = 1-probf(f,df1,df2);
  print t2 f df1 df2 pval;

* confidence intervals for differences between group mean components;
  alpha = .05;
  s1diag = vecdiag(S1);
  s2diag = vecdiag(S2);
  t1 = tinv(1-alpha/2,df2);
  tb = tinv(1-alpha/2/p,df2);
  f = finv(1-alpha,df1,df2);
  loone = xbar1-xbar2-t1*sqrt(s1diag/n1+s2diag/n2);
  upone = xbar1-xbar2+t1*sqrt(s1diag/n1+s2diag/n2);
  lobon = xbar1-xbar2-tb*sqrt(s1diag/n1+s2diag/n2);
  upbon = xbar1-xbar2+tb*sqrt(s1diag/n1+s2diag/n2);
  losim = xbar1-xbar2-sqrt(p*(n1+n2-2)*f*(s1diag/n1+s2diag/n2)/(n1+n2-p-1));
  upsim = xbar1-xbar2+sqrt(p*(n1+n2-2)*f*(s1diag/n1+s2diag/n2)/(n1+n2-p-1));
  print varnames loone upone lobon upbon losim upsim;

  quit;