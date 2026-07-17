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
beginfig(04)
  obj(AkX)("\A_{i_0,j_0}^k\times\prod_{\ell \neq \ell_0}\A_{\phi\ell}");
  obj(AXk)("(\A_{i_0,j_0}\times \prod_{\ell \neq \ell_0}\A_{\phi\ell})^k");
  obj(Xk)("(\prod_{\ell}\A_{\phi\ell})^k");
  obj(Ck)("\A[3]^k");
  obj(C)("\A[3]");

  obj(AX)("\A_{i_0,j_0}\times\prod_{\ell \neq \ell_0}\A_{\phi\ell}");
  obj(X)("\prod_{\ell}\A_{\phi\ell}");
  obj(XX)("\prod_{i}\prod_{j}\A_{i,j}");
  obj(Y)("\prod_{i}\A[2]_i");

  obj(AxX)("\A_{i_0,j_0}\times" &
      "\prod_{j \neq i_0}\A_{i_0,j}\times" &
      "\prod_{i\neq i_0}\prod_{j}\A_{i,j}");
  obj(xX)("\prod_{j}\A_{i_0,j}\times" &
          "\prod_{i\neq i_0}\prod_{j}\A_{i,j}");

  obj(AkxXX)("\A_{i_0,j_0}^k\times" &
            "\prod_{j \neq j_0}\A_{i_0,j}\times"&
            "\prod_{i\neq i_0}\prod_j\A_{i,j}");
  obj(xXXk)("(\prod_j\A_{i_0,j}\times" &
            "\prod_{i \neq i_0}\prod_j\A_{i,j})^k");
  obj(BkY)("(\A[2]_{i_0})^k\times\prod_{i\neq i_0}\A[2]_i");
  obj(BYk)("(\A[2]_{i_0}\times\prod_{i\neq i_0}\A[2]_i)^k");
  obj(BY)("\A[2]_{i_0}\times\prod_{i\neq i_0}\A[2]_i");

  obj(Bk)("(\prod_i\A[2]_i)^k");

  obj(AxkXX)("(\A_{i_0,j_0}\times" &
            "\prod_{j \neq j_0}\A_{i_0,j})^k\times"&
            "\prod_{i\neq i_0}\prod_j\A_{i,j}");
  obj(XXk)("(\prod_i\prod_j \A_{i,j})^k");
  obj(xkXX)("(\prod_j\A_{i_0,j})^k\times\prod_{i \neq i_0}\prod_j\A_{i,j}");

  origin
    = loc(X)
    = loc(Ck) + 10u*left + 15u*down;

  canonical_rectangle(locs(AkX, Ck, C, X));
  evenly_spaced(locs(AkX, AXk, Xk, Ck));
  evenly_spaced(locs(AkX, AX, X));
  evenly_spaced(locs(X, XX, Y, C));
  evenly_spaced(locs(AX, AxX, xX, Y));
  evenly_spaced(loc(AkX), loc(AkxXX), locs(AxkXX,xkXX ,BkY, BY, C));
  evenly_spaced(locs(AkxXX, XXk, Bk));
  evenly_spaced(loc(xkXX), loc(xXXk) + u*up, loc(Bk), loc(Ck));
  loc(BYk) = (xpart(loc(Bk)), ypart(loc(xkXX)));

  drop(BYk,AxkXX, xkXX,XXk,Bk,AkxXX, xXXk, BkY, BY,AxX, xX, X, Ck,
      AkX, AXk, Xk, C, AX, XX, Y);

  mor(AkX, AXk)("\str", top);
  mor(AXk, Xk)("\isomorphic^k", top);
  mor(Xk, Ck)("g \compose(f_1, \ldots, f_n)", top);
  gen_curved_mor(15)(Ck, C)("\A[3]\sem t", lft) Csem;

  gen_curved_mor(-15)(AkX, AX)("\A_{i_0,j_0}\sem t\times \id", lrt);
  gen_curved_mor(-15)(AX, X)("\isomorphic", lft);
  mor(X, XX)("\isomorphic", bot);
  mor(XX, Y)("\prod_i f_i", bot);
  mor(Y, C)("g", bot);

  mor(AX, AxX)("\isomorphic", llft);
  mor(AxX, xX)("\isomorphic\times\id", llft);
  mor(xX, XX)("\isomorphic", lft);

  mor(xX, BY)("f_{i_0}\times\prod_{i \neq i_0}f_i", top);
  mor(BY, Y)("\isomorphic", rt);

  mor(AkX, AkxXX)("\isomorphic", urt);
  gen_curved_mor(-16)(AkxXX, AxX)("\A_{i_0,j_0}\sem t\times \id", rt);
  mor(AkxXX, AxkXX)("\str\times\id", urt);
  mor(AxkXX, xkXX)("\isomorphic\times\id", llft);
  mor(xkXX, BkY)("f_{i_0}^k\times\prod_{i\neq i_0}f_i", llft);
  mor(BkY, BY)("\A[2]_{i_0}\sem t\times\id", urt) Bsem;
  mor(BkY, BYk)("\str", lrt);
  gen_curved_mor(-30)(BYk, Bk)("\isomorphic^k", lrt);
  mor(Bk, Ck)("g^k", lrt);

  mor(xkXX, xXXk)("\str", lrt);
  mor(xXXk, BYk)("(f_{i_0}\times\prod_{i\neq i_0}f_i)^k", urt);
  mor(xXXk, XXk)("\isomorphic^k", urt);
  mor(XXk, Bk)("(\prod_if_i)^k", top);
  mor(Xk, XXk)("\isomorphic^k", ulft);


  commute_explained(AxX, xX, X)("coherence");
  commute_explained(BY, XX)("$\isomorphic$-nat");
  commute_explained(AX, AkxXX)("$\isomorphic$-nat");
  commute_explained(xkXX, AxX)
    ("$(f_{i_0}$-multi-hom$)\times\prod_{i \neq i_0}f_i$");
  commute_explained(Bsem, Csem)("$g$-multi-hom");
  commute_explained(xkXX, BYk, BkY)("$\str$-nat");
  commute_explained(xXXk, Bk)("$\isomorphic$-nat");
  commute_explained(Xk, Bk)("$\compose$-def");
  commute_explained(AkX, Xk, AkxXX, XXk)("products");
endfig;

end
