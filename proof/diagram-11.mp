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
beginfig(11)
  obj(HA k)("(H\A)^k");
  obj(H Ak)("H(\A^k)");
  obj(H A)("H\A");
  obj(KA k)("(K\A)^k");
  obj(K Ak)("K(\A^k)");
  obj(K A)("K\A");

  origin
    = loc(H A)
    = loc(KA k) + 5u*left + 2u*down;

  canonical_rectangle(loc(HA k), loc(KA k), loc(K A), loc(H A));

  evenly_spaced( .5[loc(HA k), loc(H A)]
               , loc(H Ak), loc(K Ak)
               , .5[loc(KA k), loc(K A)]);

  drop(H Ak, K Ak, HA k, KA k, K A, H A);

  mor(HA k, KA k)("\alpha_{\carrier\A}^k", top);
  mor(H A, K A)("\alpha_{\carrier\A}", bot);
  var_curved_mor(HA k, H A)("(H\A)\sem t", lft);
      curved_mor(KA k, K A)("(H\A)\sem t", rt);

  mor(HA k, H Ak)("\isomorphic", urt);
  mor(H Ak, H A)("H(\A\sem t)", lrt);

  mor(KA k, K Ak)("\isomorphic", ulft);
  mor(K Ak, K A)("K(\A\sem t)", llft);

  mor(H Ak, K Ak)("\alpha_{\carrier\A^k}", top);

  commute_explained(H Ak, K Ak, HA k, KA k)("($*$)");
  commute_explained(H Ak, K Ak, H A, K A)("$\alpha$-nat");

  commute(H Ak, HA k, H A)("\definedby");
  commute(K Ak, KA k, K A)("\defines");
endfig;

end
