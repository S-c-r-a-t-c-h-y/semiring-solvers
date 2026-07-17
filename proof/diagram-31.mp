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
beginfig(31)
  obj(uell)("\seq[\ell=1][m]{F[\partit_{\ell}]} \xto{u_{\ell}} \xvec_{\ell}");
  obj(uij)("\seq[i=1][n]{\seq[j=1][m_i]{u_{\pair ij}}}");
  obj(viui)("\seq[i=1][n]{v_i\compose\seq[j=1][m_i]{u_{\pair ij}}}");
  obj(voviui)("v\compose\seq[i=1][n]{v_i\compose\seq[j=1][m_i]{u_{\pair ij}}}");
  obj(vvioui)("(v\compose\seq[i=1][n]{v_i})\compose\seq[\ell=1][m]{u_{\ell}}");

  origin
    = z1
    = z2 + 8u*left + 4u*down;

  canonical_rectangle(loc(uell), z2, z3, z1);

  evenly_spaced(loc(uell), loc(uij), loc(viui), z3);

  z3
    = loc(voviui)
    = loc(vvioui) + u*down;

  drop(uell, uij, viui, voviui, vvioui);

  explicit_map(uell, vvioui)(loc(uell) -- z2 -- loc(vvioui))
    ("\UU[2](F;v\compose\seq[i=1][n]{v_i})_{\partit}", top);
  explicit_map(uell, voviui)(loc(uell) -- z1 -- loc(voviui))
    ("\parent{\UU[2](F;v)\compose\seq[i=1][n]{\UU[2](F;v_i)}}_{\partit}", bot);

  mor(uell, uij)("\isomorphic", urt);
  mor(uij, viui)("\prod_{i=1}^n\UU[2](F;v_i)_{\partit_{\pair i*}}", urt);
  mor(viui, voviui)("\UU[2](F;v)_{\partit_{\pair i{\++}}}", llft);

  obj(dummy)("ignore me");
  loc(dummy)=z1;

  commute_explained(uij,viui,dummy)("$\compose$-def");

  equals_mor(voviui, vvioui)("\scriptstyle\leftarrow\text{associativity}", rt);
endfig;

end
