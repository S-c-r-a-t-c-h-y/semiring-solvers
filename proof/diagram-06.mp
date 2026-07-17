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
beginfig(06)
  obj(XHa)("\prod_{\ell=1}^pHa_{\phi\ell}");
  obj(HXa)("H\prod_{\ell=1}^pa_{\phi\ell}");
  obj(Hc)("Hc");
  obj(HXXa)("H\prod_{i=1}^n\prod_{j=1}^{m_i}a_{i,j}");
  obj(XHXa)("\prod_{i=1}^nH\prod_{j=1}^{m_i}a_{i,j}");
  obj(XXHa)("\prod_{i=1}^n\prod_{j=1}^{m_i}Ha_{i,j}");
  obj(HXb)("H\prod_{i=1}^nb_i");
  obj(XHb)("\prod_{i=1}^nHb_i");

  origin
    = loc(XHa)
    = loc(Hc) + 10u*left;

  drop(Hc, XHa);

  gen_curved_mor( 90)(XHa, Hc)("\seq H(g\compose(f_1, \ldots, f_n))", top) U;
  gen_curved_mor(-90)(XHa, Hc)
    ("\seq Hg\compose(\seq H f_1, \ldots, \seq H f_n)", bot) D;

  evenly_spaced(locs(U, HXa, HXXa, XHXa, XHb, D));
  evenly_spaced(locs(XHa, XXHa, XHb));
  evenly_spaced(locs(XHb,HXb,Hc));
  drop(HXa, HXXa, XHXa, XXHa, XHb, HXb);

  mor(XHa, HXa)("\isomorphic",ulft);
  mor(HXa, Hc)("",urt) biglabelAnchor;
  obj(biglabel)("H(g\compose(f_1, \ldots, f_n))");
  loc(biglabel) = loc(biglabelAnchor) + .35u*left + u*up;
  drop(biglabel);
  mor(XHa, XXHa)("\isomorphic", llft);
  mor(XXHa, XHb)("\prod_{i}\seq Hf_i", llft);
  mor(XHb, HXb)("\isomorphic", lrt);
  mor(HXb, Hc)("\seq Hg", lrt);
  mor(HXXa, HXb)("H\prod_if_i", urt);
  mor(XHXa, HXXa)("\isomorphic", rt);
  mor(XHXa, XHb)("\prod_iHf_i", rt);

  mor(HXa, HXXa)("H\isomorphic", lrt);

  mor(XXHa, XHXa)("\prod_i\isomorphic", ulft);

  commute_explained(XHa, HXXa, XHXa)("$H$ preserves\\products");
  commute_explained(XXHa,XHXa,XHb)("$\seq H$-def");
  commute_explained(XHXa,HXb)("$\isomorphic$-nat");
  commute_explained(HXa,HXXa,Hc)("$H(\compose$-def$)$");
  commute_explained(U,HXa)("$\seq H$-def");
  commute_explained(D,XHb)("$\compose$-def");
endfig;

end
