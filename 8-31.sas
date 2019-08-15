options ls=78;
title "Bivariate Normal Density";
%let r = 0; *defines the macro variable r, will be referenced with &r;

data a;
  pi=constant('PI');
  do x1=-4 to 4 by 0.1;
    do x2=-4 to 4 by 0.1;
      phi=exp(-(x1*x1-2*&r*x1*x2+x2*x2)/2/(1-&r*&r))/2/pi/sqrt(1-&r*&r);
      output; *writes the values x1 x2 and phi to the dataset a;
    end;
  end;
  run;
proc g3d data=a;
  plot x1*x2=phi / rotate=20;
  run;
quit;

title "95% prediction ellipse";
data b;
  pi=constant('PI');
  do i=0 to 200;
    theta=pi*i/100; *theta ranges from 0 to 2pi;
    u=cos(theta);
    v=sin(theta);
    output; *theta, u, and v created as variables in dataset b;
  end;
  run;
proc iml;
  create c var{x y}; 
  start ellipse; 
    mu={0,0}; 
    sigma={1.0000 0.5000, 
	       0.5000 2.0000}; 
    lambda=eigval(sigma); 
    e=eigvec(sigma);
    d=diag(sqrt(lambda));
    z=z*d*e`*sqrt(5.99); *5.99=chisq(2,.95) for 95% probability;
    do i=1 to nrow(z);
      x=z[i,1];
      y=z[i,2];
      append; *adds new values for x and y to dataset c;
    end;
  finish;
  use b;
  read all var{u v} into z;
  run ellipse; *assigns (x,y) point for each theta;
  quit;
proc gplot data=c;
  axis1 order=-5 to 5 length=3 in;
  axis2 order=-5 to 5 length=3 in;
  plot y*x / vaxis=axis1 haxis=axis2 vref=0 href=0;
  symbol v=none l=1 i=join color=black;
  run; quit;

/*
  37 subjects taking the Wechsler adult intelligence test
  information (info), 
  similarities (sim), 
  arithmetic (arith), 
  picture completion (pic)
*/
data wechsler;
  infile 'v:\505\datasets\wechsler.dat';
  input id info sim arith pict;
  run;
proc sgplot data=wechsler;
  scatter x=info y=sim;
  ellipse x=info y=sim /alpha=.05;  
  run;
proc corr data=wechsler noprob nosimple cov out=output;
  var info sim;
  run;



