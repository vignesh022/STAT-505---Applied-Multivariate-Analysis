options ls=78;
data pollution;
  infile 'X:\STAT 505\air.dat';
  input wind solar CO NO NO2 O3 HC; 
  run;
proc princomp data=pollution;
  var wind solar CO NO NO2 O3 HC;
  run;
proc factor data=pollution method=principal rotate=varimax nfactors=2 simple scree ev preplot
     plot residuals;;
  var wind solar CO NO NO2 O3 HC;
  run; quit;
proc factor data = pollution method=principal nfactors=3 rotate=varimax simple scree ev preplot
     plot residuals;
  var wind solar CO NO NO2 O3 HC;
  run; quit;
