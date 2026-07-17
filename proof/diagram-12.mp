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
beginfig(12)
  obj(XKH)("\prod_iKH a_i");
  obj(KXH)("K\prod_iH a_i");
  obj(KHX)("KH\prod_i a_i");
  obj(KHb)("KHb");

  origin
    = loc(XKH)
    = loc(KHb) + 6u*left;

  drop(XKH, KHb);

  gen_curved_mor( 60)(XKH, KHb)("\seq K (\seq H f)", top) U;
  gen_curved_mor(-60)(XKH, KHb)("\seq {K\compose H} f", bot) D;

  evenly_spaced(locs(U, KXH, KHX, D));

  drop(KXH, KHX);

  mor(XKH, KXH)("\isomorphic", ulft);
  mor(XKH, KHX)("\isomorphic", llft);
  mor(KXH, KHX)("\isomorphic", rt);
  mor(KXH, KHb)("K\seq H f", top);
  mor(KHX, KHb)("K     H f", lrt);

  commute_explained(U, KXH)("def");
  commute_explained(D, KHX)("def");
  commute_explained(XKH, KXH, KHX)("product\\preservation");
  commute_explained(KHb, KXH, KHX)("$K(\seq H$-def$)$");
endfig;

end
