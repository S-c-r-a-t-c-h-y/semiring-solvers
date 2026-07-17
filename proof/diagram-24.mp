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
beginfig(24)
  obj(XFa)("\prod_{\ell=1}^n \Fvec_{\ell}\partit_{\ell}");
  obj(XFb)("\prod_{\ell=1}^n \Fvec_{\ell}\partit_{\ell}");
  obj(XX)("\prod\set{\prod_{\ell+1}^n \Fvec_\ell\partit_\ell}");
  obj(XG)("\prod\set{G\avec}");
  obj(G)("G\avec");

  origin
    = loc(XFa)
    = loc(G)+ 5u*left;

  drop(XFa, G);

  gen_curved_mor( 90)(XFa, G)("(\id[G]\compose(\alpha))_{\partit}", top) U;
  gen_curved_mor(-90)(XFa, G)("\alpha_{\partit}", bot) D;

  loc(XX) = .5[loc(U), loc(XFa)];
  loc(XG) = .5[loc(U), loc(G)];
  evenly_spaced(loc(U), z1, loc(XFb), loc(D));

  drop(XX, XG, XFb);

  mor(XFa, XX)("\isomorphic", lrt);
  mor(XX, XG)("\prod\set{\alpha_{\partit}}", bot);
  var_curved_mor(XG, G)("\isomorphic", llft);
  var_curved_mor(XG, G)("\id[G,\avec]", urt);

  mor(XX, XFb)("\isomorphic", llft);
  equals_mor(XFa, XFb)("",);
  mor(XFb, G)("\alpha_{\partit}", lrt);

  commute_explained(XFa, XFb, XX)("products");
  commute_explained(XX, XG, U)("$\compose$-def");
  commute_explained(XX, XG, XFb, G)("$\isomorphic$-nat");
  commute_explained(XFb, D)("$\id$");
endfig;

end
