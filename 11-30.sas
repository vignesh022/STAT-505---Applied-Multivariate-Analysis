/*
Ecological data from Woodyard Hammock, 
a beech-magnolia forest in northern Florida. The data 
involve counts of the numbers of trees of each species 
in n = 72 sites. A total of 31 species were identified 
and counted, however, only p = 13 most common species 
were retained and are listed below. They are:

carcar	Carpinus caroliniana	Ironwood
corflo	Cornus florida		Dogwood
faggra	Fagus grandifolia	Beech
ileopa	Ilex opaca		Holly
liqsty	Liquidambar styraciflua	Sweetgum
maggra	Magnolia grandiflora	Magnolia
nyssyl	Nyssa sylvatica		Blackgum
ostvir	Ostrya virginiana	Blue Beech
oxyarb	Oxydendrum arboreum	Sourwood
pingla	Pinus glabra		Spruce Pine
quenig	Quercus nigra		Water Oak
quemic	Quercus michauxii	Swamp Chestnut Oak
symtin	Symplocus tinctoria	Horse Sugar
*/

options ls=78;
data wood;
infile 'x:\wood.dat';
*infile 'v:\505\datasets\wood.dat';
  input x y acerub carcar carcor cargla cercan corflo faggra frapen
        ileopa liqsty lirtul maggra magvir morrub nyssyl osmame ostvir 
        oxyarb pingla pintae pruser quealb quehem quenig quemic queshu quevir 
        symtin ulmala araspi cyrrac;
  ident=_n_; *creates an id number for each site;
  drop acerub carcor cargla cercan frapen lirtul magvir morrub osmame pintae
       pruser quealb quehem queshu quevir ulmala araspi cyrrac;
  run;
proc sort data=wood;
  by ident;
  run;

proc cluster data=wood method=ward outtree=clust1;
  var carcar corflo faggra ileopa liqsty maggra nyssyl ostvir oxyarb 
      pingla quenig quemic symtin;
  id ident;
  run;

proc tree data=clust1 nclusters=4 out=clust2;
  id ident;
  run;
proc sort data=clust2;
  by ident;
  run;
data combine; *combines original observations with their cluster assignments;
  merge wood clust2;
  by ident;
  run;
proc glm data=combine;
  class cluster;
  model carcar corflo faggra ileopa liqsty maggra nyssyl ostvir oxyarb 
        pingla quenig quemic symtin = cluster;
  means cluster;
  run; quit;


* k-means procedure;
proc fastclus data=wood maxclusters=4 maxiter=100 out=clust replace=random;
*proc fastclus data=wood maxclusters=4 maxiter=100 out=clust radius=20;
  var carcar corflo faggra ileopa liqsty maggra nyssyl ostvir oxyarb 
      pingla quenig quemic symtin;
  id ident;
  run;
proc glm data=clust;
  class cluster;
  model carcar corflo faggra ileopa liqsty maggra nyssyl ostvir oxyarb 
        pingla quenig quemic symtin = cluster;
  means cluster;
  run; quit;
