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
beginfig(02)
  obj(AkX)("\A_{i_0}^k");
  obj(Xk)("\parent{\prod_{i = 1}^n\A_i}^k");
  obj(AX)("\A_{i_0}");
  obj(Bk)("\A[2]^k");
  obj(B)("\A[2]");

  canonical_rectangle(locs(AkX, Xk, B, AX));
  evenly_spaced(locs(Xk,Bk,B));

  origin
    = loc(AX)
    = loc(Xk) + 8u*left + 3u*down;

  drop(AkX, B, AX, Bk);

  mor(AkX,Bk)("f^k", urt);
  mor(Bk,B)("\A[2]\sem t", rt);

  mor(AkX, AX)("\A_{i_0}\sem t", lft);
  mor(AX, B)("f", bot);

  commute(AkX, B);

endfig;

end
