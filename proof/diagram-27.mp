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
beginfig(27)
  obj(ui)("\seq[i=1][n]{(\partit_i) \xto{u_i} \avec_i}");
  obj(fui)("F(u_1, \ldots, u_n)x");
  obj(fphifui)("F\seq[i=1][n]{\seq[j=1][m_i]{\phi_{\pair ij}}}" &
      " \compose F\seq[i=1][n]{u_i} x");
  obj(phiui)("\seq[i=1][n]{u_i \compose " &
      "\seq[j=1][m_i]{\phi_{ij}} : (\partit'_i \to \avec_i)}x");

  obj(fphiui)("F\seq[i=1][n]{u_i \compose \seq[j=1][m_i]{\phi_{\pair ij}}}x");
  obj(fffui)("Ff \compose F\seq[i=1][n]{u_i}x");

  origin
    = loc(phiui)
    = loc(fui)+ 7.5u*left + 3u*down;

  loc(fphiui) = loc(fphifui) + 3.5u*left;
  loc(fffui) = loc(fphifui) + .9u*up;

  canonical_rectangle(locs(ui, fui, fphifui, phiui));

  drop(fffui, fphiui, ui, fui, fphifui, phiui);
  map(ui, fui)("(\inv\Yoneda x)_{\partit}", top);
  map(fui, fffui)("Ff", rt);
  map(ui, phiui)("\prod_{i=1}^n\yoneda \avec_1\phi_i", rt);
  var_curved_map(phiui, fphiui)("(\inv\Yoneda x)_{\partit'}", bot);

  equals_mor(fphiui, fphifui)("\underset{\text{functoriality}}\uparrow", bot);
  equals_mor(fffui, fphifui)("\leftarrow\text{$\phi$ partitions $f$}", rt);
endfig;

end
