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
beginfig(34)
  obj(pQa)("\prod\set{Q\avec}");
  obj(pQb)("\prod\set{Q\bvec}");
  obj(Qb)("Q\bvec");
  obj(Qa)("Q\avec");
  obj(Qap)("Q\avec");
  obj(pPa)("\prod\set{P\avec}");
  obj(pPb)("\prod\set{P\bvec}");
  obj(pPap)("\prod\set{P\avec}");
  obj(pPbp)("\prod\set{P\bvec}");
  obj(Pb)("P\bvec");
  obj(Pa)("P\avec");

  origin
    = loc(pQb)
    = loc(Pa) + 8u*left + 8u*down;

  canonical_rectangle(locs(pQa, Pa, Pb, pQb));

  evenly_spaced(loc(pQa), loc(Qa), z1, loc(pPbp), loc(pPb), loc(Pb));

  loc(Qap) = z1;

  canonical_rectangle(locs(Qa, pPa, pPb, Qb));
  canonical_rectangle(z1, loc(pPap), loc(pPbp), z2);

  drop(Qap, Qb, pPa, pPbp, pPb, Qa, pQa, Pa, Pb, pQb);

  mor(pQa, Pa)("(\inv\alpha)_{\seq[j=1][1]{\avec}}", top);
  mor(pQb, Pb)("(\inv\alpha)_{\seq[j=1][1]{\bvec}}", bot);
  mor(pQa, pQb)("\prod\set{Qf}", lft);
  mor(Pa, Pb)("Pf", rt);

  mor(pQa, Qa)("\isomorphic", urt);
  mor(pQb, Qb)("\isomorphic", lrt);

  mor(Qa, Qb)("Qf", rt);
  mor(Qap, Qb)("Qf", lrt);

  mor(pPa, pPb)("\prod\set{Pf}", rt);

  mor(Qa, pPa)("\inv{\parent{\alpha_{\seq\avec}}}", top);
  mor(Qb, pPb)("\inv{\parent{\alpha_{\seq\bvec}}}", bot);
  mor(pPbp, Qb)("\alpha_{\seq\bvec}", lrt);
  mor(pPa, Qap)("\alpha_{\seq\bvec}", lrt);

  equals_mor(Qap, Qa)("",);
  equals_mor(pPbp, pPb)("",);

  mor(pPb, Pb)("\isomorphic", urt);
  mor(pPa, Pa)("\isomorphic", lrt);


  commute_explained(pQa, Qb)("products");
  commute_explained(pQa, Qa, pPa, Pa)("$\inv\alpha$-def");
  commute_explained(pQb, Qb, pPb, Pb)("$\inv\alpha$-def");
  commute_explained(Qap, pPbp)("$\alpha$-nat.");

  commute_explained(Qa, Qap, Qb)("inverse");
  commute_explained(Qb, pPbp, pPb)("inverse");

  commute_explained(Pa, pPb)("products");

endfig;

end
