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
beginfig(32)
  obj(ui)("\seq[i=1][1]{(\avec) \xto{u} b}");
  obj(uf)("\seq[i=1][1]{u \compose (f)}");
  obj(Fu)("\parent{F[\avec]\xto{Fu} Fb}");
  obj(FuFf)("Fu\compose(F[f])");
  obj(Fuf)("F(u\compose (f))");

  origin
    = loc(uf)
    = loc(Fu) + 7u*left + 3u*down;

  canonical_rectangle(locs(ui, Fu, Fuf, uf));
  loc(FuFf) = loc(Fuf) + u*up;
  drop(FuFf, ui, Fu, Fuf, uf);

  map(ui, Fu)("(\map F)_{b, \seq\avec}", top);
  map(Fu, FuFf)("\UU[2](F[f]; Fb)", lft);
  map(ui, uf)("\prod\set{\yoneda bf}", rt);
  map(uf, Fuf)("\UU[2](\map F)_{b, \seq[i=1][1]{\avec'}}", bot);
  equals_mor(FuFf, Fuf)("\scriptstyle\text{multi-functoriality}\rightarrow", lft)
endfig;

end
