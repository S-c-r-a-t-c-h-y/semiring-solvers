filenametemplate "%j-%2c.mps";

u:=36;

nahlength := .7*ahlength*u/36;

def map_suffixes(text f)(suffix s)(text rest) =
  f(s)
  forsuffixes s = rest:
    , f(s)
  endfor
enddef;

% Bug:
def gen_aligned(text align)(expr first)(text rest) =
        align(first)
                for s = rest:
                        = align (s)
                endfor;
enddef;

def xaligned =
        gen_aligned(xpart)
enddef;

def yaligned =
        gen_aligned(ypart)
enddef;

def evenly_spaced(text T) =
begingroup
        save prev, prevprev;
        pair prev, prevprev;
        for s = T:
                s - prev = prev - prevprev;
                prevprev:=prev;
                prev := s;
        endfor;
endgroup
enddef;

def evenly_evaluated (text eval)(text T) =
begingroup
        save prev, prevprev, current;
        numeric prev, prevprev, current;
        for s = T:
                current := eval(s);
                current - prev = prev - prevprev;
                prevprev:=prev;
                prev := current;
        endfor;
endgroup;
enddef;

def horizontally_spaced = evenly_evaluated (xpart) enddef;
def vertically_spaced   = evenly_evaluated (ypart) enddef;

def form_rectangle(expr a, b, c, d) =
        a - b = d - c;
        a - d = b - c;
        (a - b)dotprod(c - b) = 0;
enddef;

def canonical_rectangle(expr a, b, c, d) =
        ypart (a - b) = ypart( c - d) = 0;
        xpart (a - d) = xpart( b - c) = 0;
enddef;

def rectangle(expr width, height)(expr a, b, c, d) =
  canonical_rectangle(a, b, c, d);
  d + (width, height) = b;
enddef;

bounding_box_len = 4pt;

def boundary expr pic =
        (bounding_box_len*(-1, +1) + ulcorner pic)
                --
        (bounding_box_len*(+1, +1) + urcorner pic)
                --
        (bounding_box_len*(+1, -1) + lrcorner pic)
                --
        (bounding_box_len*(-1, -1) + llcorner pic)
                --cycle;
enddef;

def and (text fun)(text funi)(text lst) =
  funi(lst);
  fun(lst)
enddef;


def regular_polygon(text vertices)=
  begingroup
    save l,p, prev, prev_dir, a, mid;
    pair a[], mid;
    l := 0;
    mid:= origin;
    for t=vertices:
      a[l] = t;
      mid := mid + t;
      l:=l+1;
    endfor;
    mid := mid/l;

    for i = 0 upto l-1:
      a [i+1 mod l] - mid  = (a[i] - mid) rotated (360/l);
    endfor;
  endgroup
enddef;


input commutative_diagrams;
