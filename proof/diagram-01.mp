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
beginfig(01)
  obj(AkX)("\A_{i_0}^k\times\prod_{\substack{1 \leq i \leq n\\i \neq i_0}}\A_i");
  obj(AXk)("\parent{\begin{array}[c]{@{}l@{}}\A_{i_0}\times\prod\limits_{\substack{1 \leq i \leq n\\i \neq i_0}}\A_i\end{array}}^k");
  obj(Xk)("\parent{\prod_{i = 1}^n\A_i}^k");
  obj(AX)("\A_{i_0}\times\prod_{\substack{1 \leq i \leq n\\i \neq i_0}}\A_i");
  obj(X)("\prod_{i = 1}^n\A_i");
  obj(Bk)("\A[2]^k");
  obj(B)("\A[2]");

  canonical_rectangle(locs(AkX, Xk, B, AX));
  evenly_spaced(locs(AkX, AXk, Xk));
  evenly_spaced(locs(Xk,Bk,B));
  evenly_spaced(locs(AX, X, B));

  origin
    = loc(AX)
    = loc(Xk) + 8u*left + 3u*down;

  drop(X, AkX, Xk, B, AX, AXk, Bk);

  mor(AkX, AXk)("\str", top);
  mor(AXk, Xk)("\isomorphic", top);
  mor(Xk,Bk)("f^k", rt);
  mor(Bk,B)("\A[2]\sem t", rt);

  mor(AkX, AX)("\A_{i_0}\sem t\times \id", lft);
  mor(AX, X)("\isomorphic", bot);
  mor(X, B)("f", bot);

  commute(AkX, B);
endfig;

end
