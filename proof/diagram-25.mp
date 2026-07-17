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
beginfig(25)
  obj(XF)("\prod_{\ell=1}^f\Fvec_\ell\partit_\ell");
  obj(K)("K\avec");
  obj(XgXfF)("\prod_{t=1}^g\prod_{j=1}^{f_t}\Fvec_{\pair tj}\partit_{\pair tj}");
  obj(XhXfF)("\prod_{i=1}^h\prod_{s=1}^{f_i}\Fvec_{\pair is}\partit_{\pair is}");
  obj(XgG)("\prod_{t=1}^g\Gvec_{t}\partit_{\pair{t}{\++}}");
  obj(XhH)("\prod_{i=1}^h\Hvec_i\partit_{\triple i{\++}{\++}}");
  obj(XhXgG)("\prod_{i=1}^h\prod_{j=1}^{g_i}" &
               "\Gvec_{\pair ij}\partit_{\triple{i}{j}{\++}}");
  obj(XhXgXfF)("\prod_{i=1}^h\prod_{j=1}^{g_i}\prod_{r=1}^{f_{\pair ij}}"&
      "\Fvec_{\triple ijr}\partit_{\triple ijr}");

  origin
    = z1
    = z2 + 10u*left + 8u*down;

  canonical_rectangle(loc(XF), z2, loc(K), z1);

  canonical_rectangle(z3, loc(XhH), z5, loc(XgG));
  evenly_spaced(loc(XF), z3, z97, z98, z99, z100, z5, loc(K));
  loc(XgXfF) = z3 + t*down;
  loc(XhXfF) = z3 + t*right;

  loc(XhXgG) = z5;

  t = u;

  evenly_spaced(z3, loc(XhXgXfF), z5);

  drop(XhXgXfF, XhXgG, XhH, XgG,XhXfF, XgXfF, XF, K);

  explicit_mor(XF, K)(loc(XF) -- z1 -- loc(K))
    ("", bot) botLabelPos;
  obj(botLabel)("((\gamma\compose\seq[i=1][n]{\beta_i})" &
                "\compose\seq[r=1][g]{\alpha_r})_{\partit}");
  loc(botLabel) = loc(botLabelPos) + 4u*right +.25u*down;
  drop(botLabel);
  explicit_mor(XF, K)(loc(XF) -- z2 -- loc(K))
    ("", top) topLabelPos;
  obj(topLabel)("(\gamma\compose\seq[i=1][h]{\beta_i\compose" &
                "\seq[j=1][f_i]{\alpha_{\pair ij}}})_{\partit}");

  loc(topLabel) = loc(topLabelPos) + 4u*left +.5u*up;
  drop(topLabel);

  mor(XF, XgXfF)("\isomorphic", llft);
  mor(XgXfF, XgG)("\prod_{t=1}^t\alpha_{t,\partit_{\pair t*}}", rt);
  mor(XgG, K)("(\gamma\compose\seq[i=1][h]{\beta_i})_{\partit_{\pair t{\++}}}",
      llft);

  mor(XF, XhXfF)("\isomorphic", urt);

  mor(XhXfF, XhH)("\prod_{i=1}^h(\beta_i\compose"&
      "\seq[j=1][f_{\pair ij}]{\alpha_i})_{\partit_{\triple i{*}{\++}}}\ ",
      top);

  gen_curved_mor(10)(XhH, K)("\gamma_{\partit_{\triple i{\++}{\++}}}", llft);
  mor(XgG, XhXgG)("\isomorphic", bot);
  mor(XhXgG, XhH)("\prod_{i=1}^h\beta_{i,\partit_{\triple i*{\++}}}", lft);
  mor(XgXfF, XhXgXfF)("\isomorphic", llft);
  mor(XhXfF, XhXgXfF)("\prod_{i=1}^h\isomorphic", urt);
  mor(XhXgXfF, XhXgG)("\prod_{i=1}^h\prod_{j=1}^{g_i}" &
      "\alpha_{\pair ij,\partit_{\triple ij*}}", lft);

  commute_explained(XgG, botLabelPos)("$\compose$-def");
  commute_explained(XhH, topLabelPos)("$\compose$-def");
  commute_explained(XhXgG, K)("$\compose$-def");
  commute_explained(XhXgXfF, XhH)("$\prod_{i=1}^h(\compose$-def$)$");
  commute_explained(XhXgXfF, XhXfF, XgXfF)("products");
  commute_explained(XhXgXfF, XgG)("$\isomorphic$-nat")
endfig;

end
