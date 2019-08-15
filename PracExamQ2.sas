options ls=78;
data iris;
infile "X:\STAT 505\iris.dat";
input slength swidth plength pwidth type $;
y1=log(slength/swidth);
y2=log(plength/pwidth);
run;
proc gplot data=iris;
plot y2*y1=type;
symbol1 v=b f=special h=2 i=join color=red interpol=none;
symbol2 v=a f=special h=2 i=join color=green interpol=none;
symbol3 v=c f=special h=2 i=join color=blue interpol=none;
run; quit;
proc discrim data=iris pool=yes crossvalidate;
class type;
var y1;
priors '1'=1 '2'=1 '3'=1;
run;
proc discrim data=iris pool=yes crossvalidate;
class type;
var y2;
priors '1'=1 '2'=1 '3'=1;
run;
proc discrim data=iris pool=yes crossvalidate;
class type;
var y1 y2;
priors '1'=1 '2'=1 '3'=1;
run;
