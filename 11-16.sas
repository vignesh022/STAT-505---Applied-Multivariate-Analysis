/*
The data to be analyzed comes from a firm that surveyed a random sample of n = 50
  of its employees in an attempt to determine what factors influence sales performance.
  Two collections of variables were measured:

Sales Performance:
        Sales Growth
        Sales Profitability
        New Account Sales
Test Scores as a Measure of Intelligence:
        Creativity
        Mechanical Reasoning
        Abstract Reasoning
        Mathematics
*/
options ls=78;
data sales;
  infile "X:\STAT 505\sales.txt";
  input growth profit new create mech abs math;
  run;
proc corr data=sales out=corr_out cov noprob;
  var growth profit new create mech abs math;
  run;

proc cancorr data=sales out=canout vprefix=sales vname="Sales Variables"
                       wprefix=scores wname="Test Scores";
  var growth profit new; *group of x-variables;
  with create mech abs math; *group of y-variables;
  run;
proc gplot data=canout;
  axis1 length=3 in;
  axis2 length=4.5 in;
  plot sales1*scores1 / vaxis=axis1 haxis=axis2; *first cancorr pair;
  symbol v=J f=special h=2 i=r color=black;
  run;
