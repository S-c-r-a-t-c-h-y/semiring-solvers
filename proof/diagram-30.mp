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
beginfig(30)
  obj(usrc)("\seq[i=1][1]{F[\avec]\xto{u} x}");
  obj(utgt)("\id[x] \compose \seq[i=1][n]{u}");
  obj(proj)("u");

  origin = loc(usrc)
         = loc(utgt) + 5*u*left;
  loc(proj) = loc(utgt) + u*down;

  drop(proj, usrc, utgt);

  map(usrc, utgt)("\UU[2](F;\id[x])_{\seq\avec}", top);
  map(usrc, proj)("\id[{\UU[2](F;\id[x])}]", llft);
  equals_mor(proj,utgt)("\scriptstyle\leftarrow\text{neutrality}", rt);
  empty_mor(usrc, proj)("\isomorphic", urt);
endfig;

end
