input okdefs;
input commutative_diagrams;

TEXPRE(
  ""                           & char(10) &
  "%&latex"                    & char(10) &
  "\PassOptionsToPackage{usenames,dvipsnames,svgnames,table}{xcolor}" &
                                 char(10) &
  "\documentclass{article}"    & char(10) &
  "\usepackage{okgeneralmath}" & char(10) &
  "\usepackage{okcategory}"    & char(10) &
  "\input{defs}"               & char(10) &
  "\begin{document}"           & char(10) &
  ""
  );

outputtemplate := "diagram-%2c.mps";
beginfig(17)
  obj(MultiC)("\A");
  obj(SeqC)("\carrier\A");
  obj(MultiD)("H\A");
  obj(SeqD)("H\carrier{\A}");
  obj(SeqDa)("\carrier{H\A}");

  loc(SeqDa) = loc(SeqD) + u*left;

  origin
    = loc(MultiD)
    = loc(SeqC) + 3u*left + 2u*down;

  canonical_rectangle(locs(MultiC, SeqC, SeqD, MultiD));

  drop(MultiC, SeqC, SeqD, MultiD, SeqDa);

  map(MultiC, SeqC)("\carrier-_{\C[1]}", top);
  map(SeqC, SeqD)("\seq H", rt);
  map(MultiC, MultiD)("\Multi(\TT, H)", rt);
  map(MultiD, SeqDa)("\carrier-_{\C[2]}", bot);
  equals_mor(SeqDa, SeqD)("", bot);

endfig;

end
