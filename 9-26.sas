
options ls=78;
data nutrient;
  infile "v:\505\datasets\nutrient.dat";
  input id calcium iron protein a c;
  run;

* Profile plots;
%let p=5;
data nutrient3; *stacks the variables and adds a new column for ratio;
  set nutrient;
  variable="calcium"; ratio=calcium/1000; output;
  variable="iron";    ratio=iron/15;      output;
  variable="protein"; ratio=protein/60;   output;
  variable="vit a";   ratio=a/800;        output;
  variable="vit c";   ratio=c/75;         output;
  keep variable ratio;
  run;
proc sort data=nutrient3;
  by variable;
  run;
proc means data=nutrient3; *computes means and variances for the ratios;
  by variable;
  var ratio;
  output out=a3 n=n mean=xbar var=s2;
  run;
data b3; *creates data for plotting, includes T2 CI limits;
  set a3;
  f=finv(0.95,&p,n-&p);
  ratio=xbar; output;
  ratio=xbar-sqrt(&p*(n-1)*f*s2/(n-&p)/n); output;
  ratio=xbar+sqrt(&p*(n-1)*f*s2/(n-&p)/n); output;
  run;
proc gplot data=b3;
  axis1 length=4 in;
  axis2 length=6 in;
  plot ratio*variable / vaxis=axis1 haxis=axis2 vref=1 lvref=21;
  symbol v=none i=hilot color=black;
  run; quit;

/* Paired data
A total of 30 married couples were questioned
  q1) What is the level of passionate love you feel for your partner?
  q2) What is the level of passionate love your partner feels for you?
  q3) What is the level of companionate love you feel for your partner?
  q4) What is the level of companionate love your partner feels for you?
On a scale of 1 to 5: 
  1 = none at all
  2 = very little
  3 = some
  4 = a great deal
  5 = a tremendous amount
*/
data spouse;
  infile "v:\505\datasets\spouse.dat";
  input h1 h2 h3 h4 w1 w2 w3 w4;
  d1=h1-w1;
  d2=h2-w2;
  d3=h3-w3;
  d4=h4-w4;
  run;

proc corr data=spouse nocorr cov out=spouse_out;
  var d1 d2 d3 d4;
  run;

proc iml;
  use spouse_out;
  read all var _NUM_ where(_TYPE_="MEAN") into xbar[colname=varnames];
  read all var _NUM_ where(_TYPE_="COV") into S;
  read all var _NUM_ where(_TYPE_="N") into n;
  varnames=t(varNames);
  s2=vecdiag(S);
  n=n[1];
  p=nrow(s);
  xbar=t(xbar);

  * hypothesis test;
  mu0={0,0,0,0}; *these are the values of mu to be tested;
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

  quit;
