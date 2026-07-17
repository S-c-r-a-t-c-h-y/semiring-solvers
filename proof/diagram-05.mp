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
beginfig(05)
  obj(XH)("\prod\set{Ha}");
  obj(HX)("H\prod\set a");
  obj(Ha)("Ha");
  obj(Hb)("Ha");

  origin
    = loc(XH)
    = loc(Ha) + 5u*left;

  drop(XH, Ha);

  gen_curved_mor( 90)(XH, Ha)("\seq H((a) \xto{\id} a)", top) U;
  gen_curved_mor(-90)(XH, Ha)("(Ha) \xto{\id} Ha", bot) D;

  evenly_spaced(loc(U), loc(HX), z1, loc(Hb), loc(D));
  drop(HX, Hb);

  mor(XH, HX)("\isomorphic", ulft);
  mor(HX, Ha)("H\parent{\begin{array}{@{}r@{}l@{}}(a&)\\\id\downarrow\\ a\end{array}}", top);
  mor(XH, Hb)("\isomorphic", llft);

  mor(HX, Hb)("\isomorphic", rt);
  curved_mor(Hb, Ha)("\id", ulft) eqa;
  var_curved_equals_mor(Hb, Ha)("",lrt) eqb;

  commute_explained(XH, HX, Hb)("$H$ preserves \\products");
  commute_explained(eqa, eqb)("functor");
  commute_explained(HX, eqa)("$H(\id$-def$)$");
  commute_explained(HX, U)("$\seq H$-def");
  commute_explained(Hb,D)("$\id$-def");

endfig;

end
