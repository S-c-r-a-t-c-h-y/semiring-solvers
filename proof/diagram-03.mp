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
beginfig(03)
  obj(AkX)("\pair{\pair{u_1}{u_2}}{v}");
  obj(AXk)("\pair{\pair{u_1}v}{\pair{u_2}v}");
  obj(Xk)("\pair{\pair{u_1}v}{\pair{u_2}v}");
  obj(AX)("\pair{\lambda_1u_1 + \lambda_2u_2}v");
  obj(X)("\pair{\lambda_1u_1 + \lambda_2u_2}v");
  obj(Bk)("\pair{f(u_1, v)}{f(u_2,v)}");
  obj(Ba)("f(\lambda_1u_1 + \lambda_2u_2, v)");
  obj(Bb)("\lambda_1f(u_1,v) + \lambda_2f(u_2, v)");
  obj(B)("shouldn't display this");

  canonical_rectangle(locs(AkX, Xk, B, AX));
  evenly_spaced(locs(AkX, AXk, Xk));
  evenly_spaced(locs(Xk,Bk,B));
  evenly_spaced(locs(AX, X, B));

  origin
    = loc(AX)
    = loc(Xk) + 7u*left + 3u*down;

  loc(Ba) + .75u*right = loc(B) = loc(Bb) + .6u*down;

  drop(X, AkX, Xk, AX, AXk, Bk, Ba, Bb);

  map(AkX, AXk)("\str", top);
  map(AXk, Xk)("\isomorphic", top);
  map(Xk,Bk)("f^k", rt);
  map(Bk,Bb)("\A[2]\sem{\lambda_1x_1 + \lambda_2x_2}", lft);

  map(AkX, AX)("\A_{i_0}\sem{\lambda_1x_1 + \lambda_2x_2}\times \id", rt);
  map(AX, X)("\isomorphic", bot);
  map(X, Ba)("f", bot);

  equals_mor(Ba,Bb)("", top);

endfig;

end
