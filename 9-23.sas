options ls=78;

data nutrient;
  infile "v:\505\datasets\nutrient.dat";
  input id calcium iron protein a c;
  run;

proc corr data=nutrient nocorr cov out=corr_out;
  var calcium iron protein a c;
  run;

proc iml;
  use corr_out;
  read all var _NUM_ where(_TYPE_="MEAN") into xbar[colname=varnames];
  read all var _NUM_ where(_TYPE_="COV") into S;
  read all var _NUM_ where(_TYPE_="N") into n;
  varnames=t(varNames);
  s2=vecdiag(S);
  n=n[1];
  p=nrow(s);
  xbar=t(xbar);

  * hypothesis test;
  mu0={1000, 15, 60, 800, 75}; *these are the values of mu to be tested;
  t2=n*t(xbar-mu0)*inv(s)*(xbar-mu0); *T2 test statistic;
  f=t2*(n-p)/p/(n-1); *F test statistic;
  pval=1-probf(f,p,n-p);
  print varnames xbar mu0;
  print t2 f pval;

  * confidence intervals;
  alpha = .05;
  t1=tinv(1-alpha/2,n-1);
  tb=tinv(1-alpha/2/p,n-1);
  f=finv(1-alpha,p,n-p);
  loone=xbar-t1*sqrt(s2/n);
  upone=xbar+t1*sqrt(s2/n);
  lobon=xbar-tb*sqrt(s2/n);
  upbon=xbar+tb*sqrt(s2/n);
  losim=xbar-sqrt(p*(n-1)*f*s2/(n-p)/n);
  upsim=xbar+sqrt(p*(n-1)*f*s2/(n-p)/n);
  print varNames loone upone lobon upbon losim upsim;
  
   * confidence interval for a'mu = mu2+mu5 in mg;
  a={0,1,0,0,1};
  xbar_a=t(a)*xbar;
  s2_a=t(a)*s*a;
  lo_sum=xbar_a-t1*sqrt(s2_a/n);
  up_sum=xbar_a+t1*sqrt(s2_a/n);
  parameter = 'sum of means for iron and vitamin C';
  null = t(a)*mu0;
  print parameter lo_sum null up_sum;
  
  quit;
