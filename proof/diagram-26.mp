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
beginfig(26)
  obj(uell)("\seq[\ell=1][p]{\partit_{\ell} \xto {u_\ell} \bvec_{\ell}}");
  obj(uij)("\seq[i=1][n]{\seq[j=1][m_i]{\seq{u_{\pair ij}}}}");
  obj(g fu)("g \compose \seq[i=1][n]{f_i \compose \seq[j=1][m_i]{u_{\pair ij}}}");
  obj(fu)("\seq[i=1][n]{f_i \compose \seq[j=1][m_i]{u_{\pair ij}}}");
  obj(gf u)("(g \compose \seq[i=1][n]f)\compose \seq[\ell=1][p]{u_\ell}");

  origin
    = loc(gf u)
    = loc(uij) + 7.5u*left + 3u*down;

  canonical_rectangle(locs(uell, uij, fu, gf u));

  evenly_spaced(loc(gf.u), z2, loc(g.fu), z1, z3, loc(fu));

  drop(fu, uell, uij, g fu, gf u);

  map(uell, uij)("\isomorphic", top);
  map(uij, fu)("\prod_{i=1}^n(\yoneda f_i)_{\partit_{\pair i*}}", rt);
  map(fu, g fu)("(\yoneda g)_{\partit_{\pair *{\++}}}", bot);
  map(uell, gf u)("(\yoneda(g \compose \seq[i=1][n]{f_i}))_{\partit}", lft);

  equals_mor(gf u, g fu)("\overset{\text{composition associativity}}\downarrow",
      top);
endfig;

end
