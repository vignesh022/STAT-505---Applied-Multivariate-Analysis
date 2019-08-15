options ls=78;
/* 
 * mineral content measurements at three different arm bone locations
 * for n = 25 women
 */
data mineral;
  infile "v:\505\datasets\mineral.dat";
  input domradius radius domhumerus humerus domulna ulna;
  run;

proc corr data=mineral cov nocorr out=corr_out;
  var domhumerus domradius; *choosing two for easy plotting;
  run;

proc iml;
title ' ';
  use corr_out;
  read all var _NUM_ where(_TYPE_="MEAN") into xbar[colname=varnames];
  read all var _NUM_ where(_TYPE_="COV") into S;
  read all var _NUM_ where(_TYPE_="N") into n;
  varnames=t(varNames); *names of the variables;
  s2=vecdiag(S); *vector of variances;
  n=n[1];
  p=nrow(S);
  xbar=t(xbar);
  t1=tinv(1-.025,n-1); *multiplier for individual intervals;
  tb=tinv(1-.025/p,n-1); *Bonferroni multiplier for simultaneous intervals;
  loone=xbar-t1*sqrt(s2/n); *this will be a vector since xbar is a vector;
  upone=xbar+t1*sqrt(s2/n);
  lobon=xbar-tb*sqrt(s2/n);
  upbon=xbar+tb*sqrt(s2/n);
  print varNames loone upone lobon upbon;

  f=finv(0.95,p,n-p);
  losim=xbar-sqrt(p*(n-1)*f*s2/(n-p)/n);
  upsim=xbar+sqrt(p*(n-1)*f*s2/(n-p)/n);
  print varNames losim upsim m;
  quit;

proc glm data=mineral alpha=.05;
  model domhumerus domradius = / clparm;
  run;
  quit; *output gives the same individual interval results as the above;

data theta;
  pi=constant('PI');
  do i=0 to 200;
    theta=pi*i/100;
    u=cos(theta);
    v=sin(theta);
    output;
  end;
  run;
proc iml;
  create plotdata var{x y}; 
  start ellipse;
	use corr_out;
    read all var _NUM_ where(_TYPE_="MEAN") into xbar;
    read all var _NUM_ where(_TYPE_="COV") into S;
    read all var _NUM_ where(_TYPE_="N") into n;
    n=n[1];
    p=nrow(S);
    lambda=eigval(S); 
    e=eigvec(S);
    d=diag(sqrt(lambda));
	f=finv(0.95,p,n-p);
    z=z*d*e`*sqrt(p/n*(n-1)*f/(n-p));
    do i=1 to nrow(z);
      x=z[i,1]+xbar[1];
      y=z[i,2]+xbar[2];
      append; *adds new values for x and y to dataset c;
    end;
  finish;
  use theta;
  read all var{u v} into z;
  run ellipse; *assigns (x,y) point for each theta;
  quit;

title 'Individual 95% confidence limits';
proc gplot data=plotdata;
  axis1 order=0.7 to 1 by .1 length=3.5 in label=('domradius');;
  axis2 order=1.6 to 2 by .1 length=4 in label=('domhumerus');;
  plot y*x / vaxis=axis1 haxis=axis2 href= 1.67567 1.90969 vref= .79673 .89087;
  symbol v=none l=1 i=join color=black;
  run;

title 'Bonferroni 95% simultaneous confidence limits';
proc gplot data=plotdata;
  axis1 order=0.7 to 1 by .1 length=3.5 in label=('domradius');
  axis2 order=1.6 to 2 by .1 length=4 in label=('domhumerus');
  plot y*x / vaxis=axis1 haxis=axis2 href= 1.6571258 1.9282342  vref= 0.7892746 0.8983254 ;
  symbol v=none l=1 i=join color=black;
  run;

title 'T-squared 95% simultaneous confidence limits';
proc gplot data=plotdata;
  axis1 order=0.7 to 1 by .1 length=3.5 in label=('domradius');
  axis2 order=1.6 to 2 by .1 length=4 in label=('domhumerus');
  plot y*x / vaxis=axis1 haxis=axis2 href= 1.6411678 1.9441922   vref= 0.7828557 0.9047443 ;
  symbol v=none l=1 i=join color=black;
  run;
