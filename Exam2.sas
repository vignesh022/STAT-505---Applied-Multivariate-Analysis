options ls=78;
title "Soporific Drug Effects - Exam 2 Question 1 - STAT 505";
data drugs;
infile 'X:\STAT 505\alertness.dat';
input sex $ p1 p2 p3 p4 p5;
run;
data drugs2;
set drugs;
time=5; k=p1; output;
time=10; k=p2; output;
time=15; k=p3; output;
time=20; k=p4; output;
time=25; k=p5; output;
drop p1 p2 p3 p4 p5;
run;
*Profile plots;
proc sort data=drugs2;
by sex time;
run;
proc means data=drugs2;
by sex time;
var k;
output out=a mean=mean;
run;
proc gplot data=a;
axis1 length=4 in;
axis2 length=6 in;
plot mean*time=sex / vaxis=axis1 haxis=axis2;
symbol1 v=J f=special h=2 i=join color=red;
symbol2 v=K f=special h=2 i=join color=blue;
run; quit;
*Test for interaction;
proc glm data=drugs;
class sex;
model p1 p2 p3 p4 p5=sex;
manova h=sex m=p2-p1,p3-p2,p4-p3,p5-p4;
run; quit;
*MANOVA for main effects;
data drugs3;
set drugs;
q = (p1+p2+p3+p4+p5);
drop p1 p2 p3 p4 p5;
run;
proc glm data=drugs3;
class sex;
model q = sex;
manova h = sex / printe printh;
run; quit;
*Test for effect of time;
data drugs4;
set drugs;
y1 = p2-p1;
y2 = p3-p2;
y3 = p4-p3;
y4 = p5-p4;
drop p1 p2 p3 p4 p5;
run;
proc iml;
  start hotel;
    mu0={0, 0, 0, 0};
    one=j(nrow(x),1,1);
    ident=i(nrow(x));
    ybar=x`*one/nrow(x);
    s=x`*(ident-one*one`/nrow(x))*x/(nrow(x)-1.0);
    print mu0 ybar;
    print s;
    t2=nrow(x)*(ybar-mu0)`*inv(s)*(ybar-mu0);
    f=(nrow(x)-ncol(x))*t2/ncol(x)/(nrow(x)-1);
    df1=ncol(x);
    df2=nrow(x)-ncol(x);
    p=1-probf(f,df1,df2);
    print t2 f df1 df2 p;
  finish;
  use drugs4;
  read all var{y1 y2 y3 y4} into x;
  run hotel;
  quit;

