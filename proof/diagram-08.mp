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
beginfig(08)
  obj(XH)("\prod_iHa_i");
  obj(HX)("H\prod_ia_i");
  obj(XK)("\prod_iKa_i");
  obj(KX)("K\prod_ia_i");
  obj(H)("Ha_i");
  obj(K)("Ka_i");

  origin
    = loc(HX)
    = loc(XK) + 6u*left + 2u*down;

  canonical_rectangle(locs(XH, XK, KX, HX));
  evenly_spaced(.5[loc(XH), loc(HX)], loc(H), loc(K), .5[loc(XK), loc(KX)]);

  drop(XH, XK, KX, HX, H, K);

  mor(XH, XK)("\prod_i\alpha_{a_i}", top);
  mor(HX, KX)("\alpha_{\prod_ia_i}", bot);
  mor(HX, XH)("\isomorphic", lft);
  mor(KX, XK)("\isomorphic", rt);

  mor(KX, K)("K\projection_i", llft);
  mor(XK, K)("\projection_i", ulft);
  mor(XH, H)("\projection_i", urt);
  mor(HX, H)("H\projection_i", lrt);
  mor(H,K)("\alpha_{a_i}", bot);

  commute_explained(XH, XK, K, H)("$\projection_i$-nat.");
  commute_explained(HX, KX, K, H)("$\alpha$-nat.");
  commute_explained(HX, XH, H)("$H$ preserves\\products");
  commute_explained(KX, XK, K)("$K$ preserves\\products");
endfig;

end
