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
beginfig(33)
  obj(ell)("\seq[\ell=1][n]{\partit_{\ell}\xto{u_\ell} \bvec_{\ell}}");
  obj(Ffoui)("F(f \compose \seq[i=1][n]{u_i})");
  obj(FfoF)("Ff\compose\seq[i=1][n]{Fu_i}");
  obj(uij)("\seq[i=1][n]{\seq[j=1][1]{(\partit_{i}) \xto{u_i} \bvec_i}}");
  obj(uik)("\seq[k=1][1]{\seq[i=1][n]{(\partit_{i}) \xto{u_i} \bvec_i}}");
  obj(Fui)("\seq[i=1][n]{F[\partit_i] \xto{Fu_i} F\bvec_i}");
  obj(fui)("\seq[k=1][1]{f\compose\seq[i=1][n]{u_i}}");

  z4 = loc(ell) + 1.5u*right + u*down;
  z4 - loc(ell) = loc(Ffoui) - z5;

  loc(uij) = z4 + 1u*right;
  loc(uik) = z4 + 1u*down;

  canonical_rectangle(z4, loc(Fui), z5, loc(fui));

  origin
    = z1
    = z3 + 9u*left + 5u*down;

  loc(FfoF) = loc(Ffoui) + u*up;

  canonical_rectangle(loc(ell), z3, loc(Ffoui), z1);

  drop(Fui, fui, uij, uik, FfoF, Ffoui, ell);

  map(ell, uik)("\isomorphic", llft);
  map(uik, fui)("\prod\set{(\yoneda f)_{\partit}}", rt);
  map(fui, Ffoui)("(\map F)_{b,\partit}", urt);

  map(ell, uij)("\isomorphic", urt);
  map(uij, Fui)("\prod_{i=1}^n(\map F)_{\bvec_i, \partit_{\pair i*}}", bot);
  map(Fui, FfoF)("\UU[2](F;Ff)_{\partit}", lft);

  explicit_map(ell, Ffoui)(loc(ell) -- z1 -- loc(Ffoui))
    ("((\map F)_{b}\compose(\yoneda f))_{\partit}",bot) D;
  explicit_map(ell, FfoF)(loc(ell) -- z3 -- loc(FfoF))
    ("(\UU[2](F;Ff)\compose\seq[i=1][n]{(\map F)_{\bvec_i}})_{\partit}",top) U;
  equals_mor(FfoF, Ffoui)("\scriptstyle\leftarrow\text{multi-functoriality}",
      rt);

  commute_explained(D, fui)("$\compose$-def");
  commute_explained(U, Fui)("$\compose$-def");
endfig;

end
