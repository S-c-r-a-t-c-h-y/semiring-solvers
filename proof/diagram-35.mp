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
beginfig(35)
  obj(TAmapB)("T\carrier{A \multimap B}");
  obj(AmapB)("\carrier{A \multimap B}");
  obj(TAtoB)("T(\carrier B^{\carrier A})");
  obj(AtoTB)("(T\carrier B)^{\carrier A}");
  obj(AtoB)("\carrier B^{\carrier A}");

  origin
    = loc(AmapB)
    = loc(TAtoB) + 5u*left + 2u*down;

  canonical_rectangle(locs(TAmapB, TAtoB, AtoB, AmapB));

  evenly_spaced(locs(TAtoB, AtoTB, AtoB));

  drop(AtoTB,TAmapB, TAtoB, AtoB, AmapB);

  mor(TAmapB, TAtoB)("Te", top);
  mor(AmapB, AtoB)("e", bot);
  mor(TAmapB, AmapB)("A\multimap B\sem-", lft);

  mor(TAtoB, AtoTB)("\lambda", rt);
  mor(AtoTB, AtoB)("B\sem-^{\carrier A}", rt);

  commute_gen(TAmapB, AmapB, TAtoB, AtoB)("\definedby");
endfig;

end
