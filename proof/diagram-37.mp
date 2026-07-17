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
beginfig(37)
  obj(dist)("\Mod(\Trans\dist\DD, \Set)");
  obj(M)("\Mod(\MM, \Set)");
  obj(O)("\Mod(\OO, \pair\Set\prod)");
  obj(A)("\Mod(\OO, \Multi(\DD, \Set))");

  origin
    = loc(M)
    = loc(A) + 4u*left + 2u*down;

  canonical_rectangle(locs(dist, A, O, M));

  drop(dist, A, O, M);

  mor(dist, A)("\carrier-_{\OO\dist\DD}", top) U;
  mor(dist, M)("\carrier-_{\MM\dist}", lft) L;
  mor(A, O)("\Mod(\OO, \carrier-)", rt);
  mor(M, O)("\Mod(\Trans, \Set)", bot);

  pullback(.25u)(U, L);
endfig;

end
