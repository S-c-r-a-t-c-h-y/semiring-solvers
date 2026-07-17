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
beginfig(23)
  obj(XFa)("\prod_{\ell=1}^n \Fvec_{\ell}\partit_{\ell}");
  obj(XFb)("\prod_{\ell=1}^n \Fvec_{\ell}\partit_{\ell}");
  obj(XX)("\prod_{\ell+1}^n \prod\set{\Fvec_\ell\partit_\ell}");
  obj(G)("G\avec");

  origin
    = loc(XFa)
    = loc(G)+ 3.5u*left;

  drop(XFa, G);

  gen_curved_mor( 90)(XFa, G)("(\alpha\compose(\id[\Fvec_1], \ldots, \id[\Fvec_n]))_{\partit}", top) U;
  gen_curved_mor(-90)(XFa, G)("\alpha_{\partit}", bot) D;

  evenly_spaced(locs(U, XX, XFb, D));

  drop(XX, XFb);

  mor(XFa, XX)("\isomorphic", ulft);
  mor(XX, XFb)("\isomorphic", rt);
  mor(XFb, G)("\alpha_{\partit}", lrt);
  equals_mor(XFa, XFb)("",);

  commute_explained(XFa, XFb, XX)("products");
  commute_explained(XX, U)("$\compose$-def");
  commute_explained(XFb, D)("$\id$");
endfig;

end
