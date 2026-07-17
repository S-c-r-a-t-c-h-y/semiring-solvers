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
beginfig(39)
  obj(k)("k");
  obj(na)("n_1");
  obj(nb)("n_2");
  obj(m)("m");

  origin
    = loc(na)
    = loc(nb) + 1.5u*left + 1u*down;

  canonical_rectangle(locs(k, nb, m, na));
  drop(k, nb, na, m);

  mor(k, na)("\zeta_1", lft);
  mor(k, nb)("\zeta_2", top);
  mor(na, m)("\theta_1", bot);
  mor(nb, m)("\theta_2", rt);

  commute(k, na, nb, m);
endfig;

end
