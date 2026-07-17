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
beginfig(29)
  obj(ui)("\seq[i=1][n]{(F[\partit_i])\xto{u_i} \xvec_i}");
  obj(vui)("v \compose \seq[i=1][n]{u_i}");
  obj(uip)("\seq[i=1][n]{(F[\partit'_i])\xto{u_i\compose " & % keep the space...
             "F[\phi_{\pair i*}]} \xvec_i}");
  obj(vofui)("v \compose\seq[i=1][n]{u_i \compose (F[\phi_{\pair i*}])}");
  obj(vuophi)("(v \compose \seq[i=1][n]{u_i})\compose F[\phi_{\pair *{\++}}]");
  obj(vuof)("(v \compose \seq[i=1][n]{u_i})\compose F[f]");

  origin
    = loc(uip)
    = loc(vui) + 8u*left + 3u*down;

  canonical_rectangle(locs(ui, vui, vuophi, uip));

  loc(vuof ) = loc(vuophi) + u*up;
  loc(vofui) = loc(vuophi) + 3.75u*left;

  drop(vuof, vofui, ui, vui, vuophi, uip);

  map(ui, vui)("\UU[2](F;v)_{\partit}", top);
  map(vui, vuof)("\UU[2](F[f]; y)", lft);

  map(ui, uip)("\prod_{i=1}^n\UU[2](F[\phi_i]; \xvec_i)", rt);
  map(uip, vofui)("\UU[2](F;v)_{\partit'}", top);

  equals_mor(vofui, vuophi)("\underset{\substack{\text{associative composition}"&
                            "\\\text{in a multi-category}}}\uparrow", bot);
  equals_mor(vuophi, vuof)("\text{\scriptsize$\phi$ partitions $f$}\rightarrow",
      lft);
endfig;

end
