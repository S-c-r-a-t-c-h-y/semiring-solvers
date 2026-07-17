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
beginfig(09)
  obj(XHa)("\prod_iHa_i");
  obj(XHab)("\prod_iHa_i");
  obj(HXa)("H\prod_ia_i");
  obj(XxHa)("\prod_i\prod\set{Ha_i}");
  obj(xXHa)("\prod\set{\prod_i Ha_i}");
  obj(xHXa)("\prod\set{H\prod_i Ha_i}");
  obj(xHb)("\prod\set{Hb}");
  obj(Hb)("Hb");
  obj(XKa)("\prod_iKa_i");
  obj(KXa)("K\prod_ia_i");
  obj(Kb)("Kb");

  origin
    = loc(xHb)
    = loc(XKa) + 10u*left + 5u*down;

  canonical_rectangle(locs(XHa, XKa, Kb, xHb));
  evenly_spaced(locs(XHa, XxHa, XKa));
  evenly_spaced(locs(XxHa, XHab, HXa, Hb), .5[loc(xHb), loc(Kb)]);
  evenly_spaced(locs(XHa, xXHa, xHb));
  evenly_spaced(locs(xXHa, xHXa, HXa));
  evenly_spaced(loc(HXa), loc (KXa), .5[loc(XKa), loc(Kb)]);

  drop(xHXa, KXa, XHa, XKa, Kb, xHb, xXHa, XxHa, Hb, XHab, HXa);

  mor(XHa, XxHa)("\isomorphic", top);
  mor(XxHa, XKa)("\prod_i\seq[a_i]\alpha", top);
  mor(XKa,Kb)("\seq Kf", rt);

  mor(XHa, xXHa)("\isomorphic", lft);
  mor(xXHa, xHb)("\prod\set{\seq H f}", lft);
  mor(xHb, Kb)("\seq[b]\alpha", bot);

  mor(xHXa, HXa)("\isomorphic", top);
  mor(xHXa, xHb)("\prod\set{Hf}", lrt);

  mor(HXa, KXa)("\alpha_b", top);

  mor(xHb, Hb)("\isomorphic", lrt);
  mor(Hb, Kb)("\alpha_b", llft);

  mor(xXHa, xHXa)("\prod\set{\isomorphic}", top);
  mor(XxHa, XHab)("\prod_i\isomorphic", rt);
  mor(XHab, HXa)("\isomorphic", rt);
  mor(HXa, Hb)("Hf", rt);

  mor(XKa, KXa)("\isomorphic", ulft);
  mor(KXa, Kb)("Kf", llft);

  mor(XHab, XKa)("\prod_i\alpha_{a_i}", lrt);

  commute_explained(XHa, HXa)("$H$ prserves\\products");
  commute_explained(XxHa, XKa, XHab)("$\prod_i(\seq\alpha$-def$)$");
  commute_explained(XHab, KXa, HXa, XKa)("($*$)");
  commute_explained(KXa, XKa, Kb)("$\seq K$-def");
  commute_explained(HXa, Kb)("$\alpha$-nat");
  commute_explained(xHb, Hb, Kb)("$\seq\alpha$-def");
  commute_explained(xHXa, Hb)("$\isomorphic$-nat");
  commute_explained(xHXa, xXHa, xHb)("$\prod\{\seq H$-def$\}$");
endfig;

end
