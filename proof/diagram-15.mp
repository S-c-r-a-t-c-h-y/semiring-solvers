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
beginfig(15)
  obj(XId)("\prod_i\Id a_i");
  obj(IdX)("\Id\prod_i a_i");
  obj(X)("\prod_ia_i");
  obj(Idb)("\Id b");
  obj(b)("b");

  origin
    = loc(X)
    = loc(Idb) + 2u*left + u*down;

  canonical_rectangle(locs(IdX, Idb, b, X));

  evenly_spaced(locs(XId, IdX, Idb));

  drop(XId, IdX, Idb, b, X);

  gen_curved_mor(40)(XId, Idb)("\seq{\Id}f", top) U;
  mor(XId, IdX)("\isomorphic", bot);
  mor(IdX, Idb)("\Id f", bot);
  equals_mor(XId, X)("", llft);
  equals_mor(X, IdX)("", lrt);
  mor(X, b)("f", bot);
  equals_mor(Idb, b)("", rt);

  commute_explained(U, IdX)("$\seq\Id$-def");
  commute_explained(Idb, b, X, IdX)("$\id$");
  commute_explained(XId, IdX, X)("$\id$");
endfig;

end
