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
beginfig(10)
  obj(HakXH)("(H\A_{i_0})^k\times\prod_{i \neq i_0}H\A_{i}");
  obj(HaXHk)("(H\A_{i_0}\times\prod_{i \neq i_0}H\A_{i})^k");
  obj(XHk)("(\prod_{i}H\A_{i})^k");
  obj(XH)("\prod_{i}H\A_i");
  obj(HX)("H\prod_i\A_i");
  obj(Hb)("H\A[2]");
  obj(Hbk)("H(\A[2]^k)");
  obj(HakxHX)("H(\A_{i_0}^k)\times \prod_{i \neq i_0}H\A_i");
  obj(HakxX)("H(\A_{i_0}^k\times \prod_{i \neq i_0}\A_i)");
  obj(HaxXk)("H(\A_{i_0}\times \prod_{i \neq i_0}\A_i)^k");
  obj(HaxX)("H(\A_{i_0}\times \prod_{i \neq i_0}\A_i)");
  obj(HaxHX)("H\A_{i_0}\times \prod_{i \neq i_0}H\A_i");
  obj(HXk)("H(\prod_{i}\A_i)^k");

  origin
    = loc(XH)
    = loc(XHk) + 8u*left + 7u*down;

  canonical_rectangle(locs(HakXH, XHk, Hb, XH));
  evenly_spaced(locs(HakXH, HaXHk, XHk));

  xaligned(loc(Hbk), loc(Hb));

  evenly_spaced(locs(HakXH, HakxHX, HakxX, HaxXk, HXk, Hbk));

  vertically_spaced(locs(HXk, Hbk, Hb));

  loc(HaxHX) = ((xpart(loc(XH)), ypart(loc(HakxX))));

  evenly_spaced(loc(HakxHX), z1, loc(HaxX), loc(HX),
        (xpart(loc(HakxHX)), ypart(loc(XH))));

  drop(HaxHX, HX, HaxX,
       HakxHX, HakxX, HaxXk, HXk, Hbk,
       HaXHk, HakXH, XHk, Hb, XH);

  mor(HakXH, HaXHk)("\str", top);
  mor(HaXHk, XHk)("\isomorphic^k", top);
  mor(XHk, Hbk)("(\Multi(\TT, H)h)^k", rt);
  mor(Hbk, Hb)("H\A[2]\sem t", lft);

  mor(HakXH, HaxHX)("H\A_{i_0}\sem t\times\id", lft);
  mor(HaxHX, XH)("\isomorphic", lft);
  mor(XH, Hb)("\Multi(\TT, H)h", bot);

  mor(HakXH, HakxHX)("\isomorphic\times\id", urt);
  mor(HakxHX, HaxHX)("H(\A_{i_0}\sem t)\times \id", lrt) tightspotB;

  mor(HaxHX, HaxX)("\isomorphic", llft);
  curved_mor(HakxHX, HakxX)("\isomorphic", urt);
  mor(HakxX, HaxX)("H(\sem t\times \id)", ulft) tightspotA;

  mor(HaxX, HX)("H\isomorphic", rt);
  mor(XH, HX)("\isomorphic", lrt);
  mor(HX, Hb)("Hh", urt);

  mor(HakxX, HaxXk)("H\str", urt);
  mor(HaxXk, HXk)("H\isomorphic", urt);
  mor(HXk, Hbk)("(Hh)^k", llft);

  mor(XHk, HXk)("\isomorphic^k", ulft);

  commute_explained(HakXH, HaxHX, HaxHX, HakxHX)("$\seq H\A_{i_0}$\\-def");
  commute_explained(tightspotA, tightspotB)("$\isomorphic$-nat");
  commute_explained(XH, HX, HaxX, HaxHX)("$H$\\preserves\\products");
  commute_explained(HX, Hb, XH)("$\Multi(\TT,H)h$-def");
  commute_explained(HXk, HX)("$H(h$ multi-hom$)$");
  commute_explained(XHk, HXk, Hbk)("$($def$)^k$");
  commute_explained(HaxXk, HaXHk)("$H$ preserves products");
endfig;

end
