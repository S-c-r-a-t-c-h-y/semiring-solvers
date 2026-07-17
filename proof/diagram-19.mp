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
beginfig(19)
  obj(X)("\prod_{i}F_i\partit_i");
  obj(G)("G\avec");
  obj(Xp)("\prod_{i}F_i\partit'_i");
  obj(Gp)("G\bvec");

  origin
    = loc(Xp)
    = loc(G) + 3u*left + 2u*down;

  canonical_rectangle(locs(X, G, Gp, Xp));
  drop(X, G, Gp, Xp);

  mor(X, G)("\alpha_{\partit}", top);
  mor(G, Gp)("Gf", rt);
  mor(X, Xp)("\prod_iF\phi_i", lft);
  mor(Xp, Gp)("\alpha_{\partit'}", bot);

  commute(X, G, Gp, Xp);
endfig;

end
