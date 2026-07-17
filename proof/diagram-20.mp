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
beginfig(20)
  obj(ui)("\seq[i=1][n]{\partit_i \xto{u_i} \avec_i}");
  obj(fou)("g\compose(u_1, \ldots, u_n)");
  obj(phou)("\seq[i=1][n]{\partit'_i\xto{\phi_i} \partit_i\xto{u_i} \avec_i}");
  obj(fuphi)("f\compose(u_1\compose(\phi_{11}, \ldots, \phi_{1m_1})," &
                "\ldots, u_n\compose(\phi_{n1}, \ldots, \phi_{nm_n}))");
  obj(fuhi)("(f \compose (u_1, \ldots, u_n))\compose (h_1, \ldots, h_p)");
  origin
    = loc(phou)
    = loc(fou) + 6u*left + 3u*down;

  canonical_rectangle(locs(ui, fou, fuphi, phou));
  loc(fuhi) =  loc(fuphi) + 1.25u*up;
  drop(fuhi, ui, fou, fuphi, phou);

  map(ui, fou)("(\yoneda g)_{\partit}", top);
  map(fou, fuhi)("\yoneda b g", rt);
  equals_mor(fuhi, fuphi)("\leftarrow \begin{array}{@{}c@{}}" &
                          "\text{muli-cat. associativity}\\"&
                          "\text{since $\seq[\ell=1][p]{h_{\ell}}"&
                          "= \seq[i=1,j=1][n,m_n]{\phi_{ij}}$}"&
                          "\end{array}", rt);
  map(ui, phou)("\prod_i\yoneda \avec_i\phi_i", lft);
  map(phou, fuphi)("(\yoneda g)_{\partit'}", bot);
endfig;

end
