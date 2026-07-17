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
beginfig(22)
  obj(XFa)("\prod_{\ell=1}^p\Fvec_{\ell}\partit_{\ell}");
  obj(XXFa)("\prod_{\i=1}^n\prod_{j=1}^{m_i}\Fvec_{\pair ij}\partit_{\pair ij}");
  obj(XGa)("\prod_{\i=1}^n\Gvec_i\partit_{\pair i{\++}}");
  obj(Ha)("H\avec");
  obj(XFb)("\prod_{\ell=1}^p\Fvec_{\ell}\partit[2]_{\ell}");
  obj(XXFb)("\prod_{\i=1}^n\prod_{j=1}^{m_i}\Fvec_{\pair ij}\partit[2]_{\pair ij}");
  obj(XGb)("\prod_{\i=1}^n\Gvec_i\partit[2]_{\pair i{\++}}");
  obj(Hb)("H\bvec");

  origin
    = loc(XFb)
    = loc(Ha) + 8u*left + 4u*down;

  canonical_rectangle(locs(XFa, Ha, Hb, XFb));

  evenly_spaced(loc(XFa), loc(XXFa), z1, loc(XGb), loc(Hb));
  canonical_rectangle(locs(XXFa, XGa, XGb, XXFb));

  drop(XXFa, XGa, XGb, XXFb, XFa, Ha, Hb, XFb);

  mor(XFa, Ha)("(\beta\compose(\alpha_1, \ldots, \alpha_n))_{\partit}", top);
  var_curved_mor(XFa, XFb)("\prod_{\ell}\Fvec_\ell\phi_\ell", lft) Bar;
  mor(Ha, Hb)("Hf", rt);
  mor(XFb, Hb)("(\beta\compose(\alpha_1, \ldots, \alpha_n))_{\partit[2]}", bot);

  mor(XFa, XXFa)("\isomorphic", urt);
  mor(XXFa, XGa)("\prod_i\alpha_{i,\partit_{\pair i*}}", bot);
  mor(XGa, Ha)("\beta_{\partit_{\pair {*}{\++}}}", ulft);

  mor(XFb, XXFb)("\isomorphic", lrt);
  mor(XXFb, XGb)("\prod_i\alpha_{i,\partit[2]_{\pair i*}}", top);
  mor(XGb, Hb)("\beta_{\partit[2]_{\pair {*}{\++}}}", lft);

  mor(XXFa, XXFb)("\prod_i\prod_j\Fvec_{\pair ij}\phi_{\pair ij}", lft) Foo;
  mor(XGa, XGb)("\prod_i\Gvec_i\phi_{\pair i{\++}}", rt);

  commute_explained(XFa, XXFa, XGa, Ha)("$\compose$-def");
  commute_explained(XFb, XXFb, XGb, Hb)("$\compose$-def");
  commute_explained(Foo, XFb, Bar)("$\isomorphic$-nat");
  commute_explained(XXFa, XXFb, XGa, XGb)("$\prod_i(\alpha_i$-nat.$)$");
  commute_explained(Ha, Hb, XGb)("$\beta$-nat")
endfig;

end
