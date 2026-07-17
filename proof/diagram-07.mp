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
beginfig(07)
  obj(XH)("\prod_iHa_i");
  obj(HX)("H\prod_ia_i");
  obj(XK)("\prod_iKa_i");
  obj(KX)("K\prod_ia_i");
  obj(H)("Ha_i");  % not used here
  obj(K)("Ka_i"); % not used here

  origin
    = loc(HX)
    = loc(XK) + 3u*left + 1.5u*down;

  canonical_rectangle(locs(XH, XK, KX, HX));
  evenly_spaced(.5[loc(XH), loc(HX)], loc(H), loc(K), .5[loc(XK), loc(KX)]);

  drop(XH, XK, KX, HX); % , H, K);

  mor(XH, XK)("\prod_i\alpha_{a_i}", top);
  mor(HX, KX)("\alpha_{\prod_ia_i}", bot);
  mor(XH, HX)("\isomorphic", lft);
  mor(XK, KX)("\isomorphic", rt);

  commute(XH, XK, KX, HX);

endfig;

end
