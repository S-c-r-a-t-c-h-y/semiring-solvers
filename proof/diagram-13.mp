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
beginfig(13)
  obj(XHa)("\prod\set{Ha}");
  obj(XHb)("\prod\set{Ha}");
  obj(XXH)("\prod\set{\prod\set{Ha}}");
  obj(H)("Ha");
  obj(XK)("\prod\set{Ka}");
  obj(K)("Ka");
  obj(L)("La");

  origin
    = loc(XXH) + 2u*right + 1u*up
    = loc(L) + 2u*left
    = loc(K);
  canonical_rectangle(z1, locs(K, XK, XXH));
  evenly_spaced(locs(XHa, XHb, K, L));
  evenly_spaced(loc(XXH), loc(XHb), z2, loc(H));

  drop(H, XHa, XHb, L, K, XK, XXH);

  gen_curved_mor( 90)(XHa, L)("\seq[a]{\beta\vcompose\alpha}", top) U;
  gen_curved_mor(-90)(XHa, L)
                   ("\seq[a]{\beta}\compose(\seq[a]{\alpha})", bot) D;
  curved_mor(XHa, H)("\isomorphic", ulft);
  curved_mor(H, K)("\alpha_a", urt);
  mor(K, L)("\beta_a", top);
  mor(XHa, XXH)("\isomorphic", llft);
  gen_curved_mor(-50)(XXH, XK)("\prod\set{\seq[a]\alpha}", bot) M;
  mor(XK, L)("\seq[a]\beta", lrt);
  mor(XXH, XHb)("\isomorphic", lft);
  mor(XHb, H)("\isomorphic", lft);
  mor(XHb, K)("\seq[a]\alpha", top);
  mor(XK, K)("\isomorphic",rt);

  commute_explained(D, M)("$\compose$-def");
  commute_explained(XHb, XK)("$\isomorphic$-nat");
  commute_explained(XHa, XHb, H)("products");
  commute_explained(XHb, K, H)("$\seq\alpha$-def");
  commute_explained(U, U, H, L, L)("$\seq{\beta\vcompose\alpha}$-def");
  commute_explained(L, K, XK)("$\seq{\beta}$-def");
endfig;

end
