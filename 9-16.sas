options ls=78;
/* wechsler intelligence test data
   Id and 4 variables:
   Information (info)
   Similarities (sim)
   Arithmetic (arith)
   Picture Completion (pict) 

   The following considers the partial correlation 
   between info and sim, conditional on arith and pict
*/
data wechsler;
  infile 'v:\505\datasets\wechsler.dat';
  input id info sim arith pict;
  run;

proc corr data=wechsler cov fisher(rho0=0 alpha=.05 biasadj=no);
  var info sim;
  partial arith pict;
  run;




