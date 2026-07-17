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
beginfig(21)
  obj(Xa)("\prod\set{F\avec}");
  obj(a)("F\avec");
  obj(Xb)("\prod\set{F\bvec}");
  obj(b)("F\bvec");

  origin
    = loc(Xb)
    = loc(a) + 3u*left + 1.5u*down;

  canonical_rectangle(locs(Xa, a, b, Xb));
  drop(Xa, a, b, Xb);

  mor(Xa, a)("\id[F, \seq\avec]",top);
  mor(Xa, a)("\isomorphic",bot);
  mor(a, b)("Ff",rt);
  mor(Xa, Xb)("\prod\set{Ff}",lft);
  mor(Xb, b)("\isomorphic",top);
  mor(Xb, b)("\id[F, \seq\bvec]",bot);

  commute_explained(Xa, a, Xb, b)("$\isomorphic$-nat");
endfig;

end
