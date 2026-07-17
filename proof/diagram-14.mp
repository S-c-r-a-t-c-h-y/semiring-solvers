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
beginfig(14)
  obj(XHHa)("\prod\set{H_2H_1a}");
  obj(XXHH)("\prod\set{\prod\set{H_2H_1a}}");
  obj(XHK)("\prod\set{H_2K_1a}");
  obj(KK)("{K_2K_1a}");
  obj(XHXH)("\prod\set{H_2\prod\set{H_1a}}");
  obj(XHHb)("\prod\set{H_2H_1a}");
  obj(HH)("H_2H_1a");
  obj(HK)("H_2K_1a");

  origin
    = loc(XHXH)
    = loc(XHK) + 4u*left + 4u*down;

  canonical_rectangle(loc(XXHH), loc(XHK), z1, loc(XHXH));

  evenly_spaced(loc(XHHa), .5[loc(XHXH), loc(XXHH)], z3, .5[loc(XHK), loc(HK)], loc(KK));

  evenly_spaced(loc(XHXH), loc(XHHb), loc(HK));
  .5[loc(XHHb), loc(HK)] = z1;
  evenly_spaced(locs(KK, HK, HH));

  drop(XHHa, XHXH, XXHH, XHK, HK, KK, XHHb, HH);

  gen_curved_mor( 90)(XHHa, KK)("(\seq{\beta}\hcompose\seq{\alpha})_a", top);
  gen_curved_mor( 90)(XHHa, KK)("\seq[a]{\beta}\compose(\seq{H_2}\seq[a]{\alpha})", bot) U;
  gen_curved_mor(-90)(XHHa, KK)("\seq[a]{\beta\hcompose\alpha}", bot) D;

  mor(XHHa, XXHH)("\isomorphic", ulft);
  curved_mor(XXHH, XHK)("\prod\set{(\seq{H_2}\seq\alpha)_a}", top) UM;
  mor(XHK, KK)("\seq[K_1a]\beta", urt);

  mor(XXHH, XHXH)("\isomorphic", lft);
  mor(XHXH, XHK)("\prod\set{H_2\seq[a]\alpha}", ulft);

  mor(XHXH, XHHb)("\isomorphic", bot);
  mor(XHHb, XHK)("\prod\set{H_2\alpha_a}", lrt);

  mor(XHK, HK)("\prod\set{H_2\alpha_a}", urt);
  mor(XHHb, HH)("\isomorphic", llft);
  mor(HH, HK)("H_2\alpha_a", lrt);

  mor(HK, KK)("\beta_a", lrt);

  gen_curved_mor(-40)(XHHa, HH)("\isomorphic", llft);

  commute_explained(U, UM)("$\compose$-def");
  commute_explained(XXHH, XXHH, XHK, XHK, XHXH)("$\prod\{\seq{H_2}$-def$\}$");
  commute_explained(XHXH, XHHb, XHK)("$\prod\{H_2\seq\alpha$-def$\}$");
  commute_explained(HH, HK, XHHb)("$\isomorphic$-nat");
  commute_explained(HK, HK, KK, KK, XHK)("$\seq\beta$-def");
  commute_explained(D, HH)("$\seq{\beta\hcompose\alpha}$-def");
  commute_explained(HH, XHXH, XHHb)("$H_i$ preserves\\products")
endfig;

end
