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
beginfig(36)
  obj(TFXtoA)("T(FX\multimap A)");
  obj(TXtoA)("T(\carrier A^X)");
  obj(XtoA)("\carrier A^X");
  obj(FXtoA)("FX\multimap A");

  obj(TXtoTA)("(T\carrier A)^{TX}");
  obj(XtoTA)("(T\carrier A)^{X}");

  obj(TTXtoA)("T(\carrier A^{TX})");
  obj(aTXtoA)("\carrier A^{TX}");

  origin
    = loc(FXtoA)
    = loc(TXtoA) + 8u*left + 4u*down;

  canonical_rectangle(locs(TFXtoA, TXtoA, XtoA, FXtoA));

  evenly_spaced(loc(TFXtoA), z1, loc(FXtoA));
  evenly_spaced(loc(TXtoA), z2, loc(XtoA));

  evenly_spaced(z1, loc(TXtoTA), z3, loc(XtoTA), z2);
  evenly_spaced(loc(TFXtoA),loc(TTXtoA), loc(TXtoA));
  evenly_spaced(loc(FXtoA), loc(aTXtoA), loc(XtoA));

  drop(TTXtoA,aTXtoA,TXtoTA, XtoTA, TFXtoA, TXtoA, XtoA, FXtoA);

  curved_mor(TFXtoA, TXtoA)("T\phi", top) U;
  curved_mor(TXtoA, XtoA)("A^X\sem-", rt);
  var_curved_mor(TFXtoA, FXtoA)("FX\multimap A\sem-", lft);
  var_curved_mor(FXtoA, XtoA)("\phi", bot) B;

  mor(TFXtoA, TTXtoA)("Te", bot);
  mor(TTXtoA, TXtoA)("T\carrier A^{\unit}", bot);

  mor(FXtoA, aTXtoA)("e", top);
  mor(aTXtoA, XtoA)("\carrier A^{\unit}", top);

  mor(TTXtoA, TXtoTA)("\lambda", ulft);
  mor(TXtoTA, aTXtoA)("A\sem-^{FX}", rt);

  mor(TXtoA, XtoTA)("\lambda", ulft);
  mor(XtoTA, XtoA)("A\sem-^X", llft);

  mor(TXtoTA, XtoTA)("(T\carrier A)^{\unit}", top);

  commute_explained(U, TTXtoA)("$T(\phi$-def$)$");
  commute_explained(B, aTXtoA)("$\phi$-def");
  commute_explained(TFXtoA, TXtoTA, FXtoA)("$FX\multimap A\sem-$-\\def");
  commute_explained(TTXtoA, XtoTA)("$\lambda$-nat");
  commute_explained(XtoTA, aTXtoA)("$(-)^(-)$-\\bifunctoriality");
  commute_explained(TXtoA, XtoTA, XtoA)("$A^X\sem-$-def")
endfig;

end
