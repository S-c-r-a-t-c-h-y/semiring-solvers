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
beginfig(16)
  obj(MultiC)("\Multi(\TT, \C[1])");
  obj(SeqC)("\seq{\C[1],\prod}");
  obj(MultiD)("\Multi(\TT, \C[2])");
  obj(SeqD)("\seq{\C[2],\prod}");

  origin
    = loc(MultiD)
    = loc(SeqC) + 3u*left + 2u*down;

  canonical_rectangle(locs(MultiC, SeqC, SeqD, MultiD));

  drop(MultiC, SeqC, SeqD, MultiD);

  mor(MultiC, SeqC)("\carrier-_{\C[1]}", top);
  mor(SeqC, SeqD)("\seq H", rt);
  mor(MultiC, MultiD)("\Multi(\TT, H)", lft);
  mor(MultiD, SeqD)("\carrier-_{\C[2]}", bot);

  commute(MultiC, SeqC, SeqD, MultiD);
endfig;

end
