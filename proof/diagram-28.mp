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
beginfig(28)
  obj(id)("\seq[i=1][n]{\id[\avec_i]}");
  obj(ui)("\seq[i=1][n]{u_i}");
  obj(aid)("\alpha_{\seq[i=1][n]{\seq[j=1][1]{\avec_i}}}" &
           "\seq[i=1][n]{\id[\avec_i]}");
  obj(aui)("\alpha_{\partit}(\seq[i=1][n]{u_i}");
  obj(Fuaid)("F\seq[i=1][n]{u_i}(\alpha_{\seq[i=1][n]{\seq[j=1][1]{\avec_i}}}" &
        "\seq[i=1][n]{\id[\avec_i]})");

  origin
    = loc(ui)
    = loc(aid) + 8u*left + 2u*down;

  canonical_rectangle(loc(id), loc(aid), z3, loc(ui));

  loc(aui) = z3;
  loc(Fuaid) = z3 + u*up + u*left;

  drop(Fuaid, aui, id, aid, ui);

  map(id, aid)("\alpha_{\seq[i=1][n]{\seq[j=1][1]{\avec_i}}}", top);
  obj(FuaidReplacement)("\vphantom{"& cap(Fuaid)&"}");
  loc(FuaidReplacement) = (x3, ypart(loc(Fuaid)));
  drop(FuaidReplacement);
  mor(aid, FuaidReplacement)("Fu", rt);
  map(id, ui)("\prod_{i=1}^n\yoneda \avec_i u_i", rt);
  map(ui, aui)("\alpha_{\partit}", bot);
  equals_mor(FuaidReplacement, aui)("\leftarrow\text{qed}", rt);
endfig;

end
