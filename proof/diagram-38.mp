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
beginfig(38)
  obj(dist)("\Trans\dist\DD");
  obj(M)("\MM");
  obj(O)("F\OO");
  obj(A)("\OO*\DD");

  origin
    = loc(M)
    = loc(A) + 4u*left + 2u*down;

  canonical_rectangle(locs(dist, A, O, M));

  drop(dist, A, O, M);

  mor(A, dist)("", top) U;
  mor(M, dist)("", lft) L;
  mor(O, A)("", rt);
  mor(O, M)("", bot);

  pushout(0.25u)(L, U);
endfig;

end
