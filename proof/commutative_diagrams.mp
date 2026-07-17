input TEX;
TEXPRE(
  ""                           & char(10) & char(13) &
  "%&latex"                    & char(10) & char(13) &
  "\documentclass{article}"    & char(10) & char(13) &
  "\usepackage{okgeneralmath}" & char(10) & char(13) &
  "\usepackage{okcategory}"    & char(10) & char(13) &
  "\begin{document}"           & char(10) & char(13) &
  ""
  );
def constantly (expr p, source, target) = p enddef;

def texify(expr formula) =
  TEX("$\displaystyle " & formula & "$")
enddef;

def loc(text obj) =
  obj.location
enddef;

def def_obj(suffix name) =
  picture name.pic;
  pair name.location;
  string name.caption;
enddef;

% A dirty hack to quickly define objects:
% the given argument string is both the object name and its caption.

% string_to_name_and_string("SomeString")
% expands to
% (SomeString)("SomeString")
def string_to_name_and_string(expr a) =
  (scantokens(a))(a)
enddef;

def _obj_aux(suffix a)(expr b) =
  def_obj(a);

  cap(a) = b;
enddef;

def _obj(expr a) =
  _obj_aux string_to_name_and_string(a)
enddef;

def cap(text name) =
  name.caption
enddef;

def obj(suffix name)(expr labl) =
  def_obj(name);
  cap (name) = labl;
enddef;


def drop_obj(suffix name) =
  name.pic = thelabel(texify(name.caption), loc(name));
  draw name.pic;
enddef;

def drop_obj_quick(suffix name) =
  label(str name, loc(name));
enddef;

def drop(text objs) =
  forsuffixes a = objs:
    drop_obj(a)
  endfor;
enddef;

def drop_quick(text objs) =
  forsuffixes a = objs:
    drop_obj_quick(a)
  endfor;
enddef;

def simple_arrow(expr p)(text arrow_type)=
  drawarrow p arrow_type
enddef;

def symbol_arrow(expr symbol)(expr p)(text arrow_type) =
  begingroup
    save t;
    t = arctime .5*arclength p of p;
    draw
      thelabel(texify(symbol),origin)
      rotated angle(direction t of p)
      shifted (point t of p)
  endgroup
enddef;


def empty_arrow(expr p)(text arrow_type)=

enddef;

def simple_edge(expr p)(text arrow_type)=
  draw p arrow_type
enddef;

def draw_equals(expr p)(text arrow_type) =
  begingroup
    interim linecap:=butt;
    pickup pencircle scaled (5*.65bp);
    draw p;
    interim linecap:=squared;
    pickup pencircle scaled (4*.65bp);
    undraw p;
    pickup defaultpen;
  endgroup
enddef;

def draw_ep(expr p)(text arrow_type) =
  begingroup
    save tail, head, t, ang, q;
    path ang, q;
    ang =  (-.75, .75){down} ... {(1,-.5)}origin;
    q = halfcircle rotated 90 shifted (xpart(urcorner(halfcircle))*up) yscaled .75  ;

    interim linecap:=butt;
    pickup pencircle scaled (3*.65bp);
    draw p;
    interim linecap:=squared;
    pickup pencircle scaled (2*.65bp);
    undraw p;
    pickup defaultpen;
    draw (ang scaled (cosd(ahangle/2)*ahlength) rotated (angle(direction infinity of p))  shifted (1.5*.65bp*up) shifted (point infinity of p));
    draw (ang scaled (cosd(ahangle/2)*ahlength) rotated (angle(direction 0 of p) + 180) shifted (1.5*.65bp*down) shifted (point 0 of p));
    draw (q scaled (cosd(ahangle/2)*ahlength) rotated (angle(direction 0 of p)) shifted (1.5*.65bp*up) shifted (point epsilon of p))
  endgroup
enddef;

%% hack
def draw_pe(expr p)(text arrow_type) =
  begingroup
    save tail, head, t, ang, q;
    path ang, q;
    ang =  (-.75, .75){down} ... {(1,-.5)}origin;
    q = halfcircle rotated 90 shifted (xpart(urcorner(halfcircle))*up) yscaled .75  ;

    interim linecap:=butt;
    pickup pencircle scaled (3*.65bp);
    draw p;
    interim linecap:=squared;
    pickup pencircle scaled (2*.65bp);
    undraw p;
    pickup defaultpen;
    draw (ang scaled (cosd(ahangle/2)*ahlength) rotated (angle(direction infinity of p))  shifted (1.5*.65bp*down) shifted (point infinity of p));
    draw (ang scaled (cosd(ahangle/2)*ahlength) rotated (angle(direction 0 of p) + 180) shifted (1.5*.65bp*up) shifted (point 0 of p));
    draw (q scaled (cosd(ahangle/2)*ahlength) rotated (angle(direction 0 of p)) shifted (1.5*.65bp*down) shifted (point epsilon of p))
  endgroup
enddef;


def gen_mor =
gen_arrow(simple_arrow)
enddef;

def decl_mor (suffix mor) =
  picture mor.source, mor.target, mor.pic;
  path mor.arrow;
  string mor.caption;
  pair mor.location;
enddef;

def def_mor(suffix mor, src_obj, tgt_obj) =
  mor.source = src_obj.pic;
  mor.target = tgt_obj.pic;
enddef;

def draw_path_gen(suffix mor)(text arrow_drawer)(text path_creator) text arrow_type =
  begingroup
    save connecting, source_time, target_time, p, q;
    path connecting, p, q;
    pair source_point, target_point;

    connecting = path_creator(center mor.source, center mor.target);
    p = boundary mor.source;
    q = boundary mor.target;

    source_time = ypart ( p intersectiontimes connecting);
    target_time = ypart ( reverse q intersectiontimes connecting);
    mor.arrow = subpath (source_time, target_time) of connecting;

    arrow_drawer(mor.arrow)(arrow_type);
  endgroup;
enddef;

def mor_label_loc (suffix mor) =
  begingroup
    save source_point, target_point, perp;
    pair source_point, target_point, perp;

    source_point = point 0        of mor.arrow;
    target_point = point infinity of mor.arrow;
    perp = right rotated (angle (target_point - source_point) + 90);
    mor.location = mor.arrow intersectionpoint (.5[source_point, target_point] - 10u*perp -- .5[source_point, target_point] + 10u*perp)
  endgroup
enddef;

def drop_mor(suffix mor)(suffix align) text how=
  mor.pic = thelabel.align(texify(mor.caption), mor.location);
  draw mor.pic;
enddef;

def lambda(text x)(text body) =
  begingroup
    save x;
    body
  endgroup
enddef;


def gen_arrow (text arrow_drawer)(text create_path)(suffix obj_a, obj_b)(expr labl)(suffix align)suffix mor=
  begingroup;
    decl_mor(mor);
    def_mor(mor, obj_a, obj_b);
    draw_path_gen(mor)(arrow_drawer)(create_path);
    mor.caption = labl;
    mor_label_loc(mor);
    drop_mor(mor)(align)
  endgroup
enddef;

def dashed_mor (suffix obj_a, obj_b)(expr labl)(suffix align)suffix mor=
  begingroup;
    decl_mor(mor);
    def_mor(mor, obj_a, obj_b);
    draw_path_gen(mor)(simple_arrow)(straight_line) dashed evenly;
    mor.caption = labl;
    mor_label_loc(mor);
    drop_mor(mor)(align)
  endgroup
enddef;
def dashed_qmon (suffix obj_a, obj_b)(expr labl)(suffix align)suffix mor=
  begingroup;
    decl_mor(mor);
    def_mor(mor, obj_a, obj_b);
    draw_path_gen(mor)(draw_qmonic)(straight_line) dashed evenly;
    mor.caption = labl;
    mor_label_loc(mor);
    drop_mor(mor)(align)
  endgroup
enddef;

%
% Todo: Refactor --- make a generic macro for two bits of an arrow
%       Create a library of arrow heads and then make a macro for
%       setting the head just before
%
%
%  path p;
%  p = origin..(2u,0);
%
%  path tail, head;
%  t = middle_time(p);
%
%  tail = reverse subpath (0,t) of p;
%  head = subpath (t,infinity) of p;
%  drawarrow tail;
%  drawarrow head;
def middle_time(expr p) =
  arctime .5*arclength p of p
enddef;

def map_tail(expr p) =
  begingroup
    save x;
    x = .5*ahlength;
    save ahangle, ahlength;
    ahlength := x;
    ahangle  :=180;
    drawarrow p;
  endgroup;
enddef;

def draw_monic (expr p)(text arrow_type) =
  simple_arrow(p)(arrow_type);
  begingroup
    save q;;
    path q;
    q = halfcircle shifted lrcorner(halfcircle);
    q := q rotated (angle(direction 0 of p)+90);
    q := q scaled (cosd(ahangle/2)*ahlength);
    q := q shifted (point 0 of p);
    draw q;
  endgroup;
enddef;
def monic = gen_arrow (draw_monic)(straight_line)
enddef;

def draw_qmonic (expr p)(text arrow_type)=
  begingroup
    save tail, head, t, ang;
    path ang;
    ang =  (-.75, .75){down} ... {(1,-.5)}origin & origin{(-1, -.5)} ... {down}(-.75, -.75);
    simple_arrow(p)(arrow_type);
    draw (ang scaled (cosd(ahangle/2)*ahlength) rotated (angle(direction 0 of p)) shifted (point 0 of p));
    %draw (ang scaled (cosd(ahangle/2)*ahlength) rotated (angle(direction infinity of p)) shifted (point infinity of p));
  endgroup;
enddef;
def qmon = gen_arrow(draw_qmonic)(straight_line) enddef;
def draw_epi (expr p)(text arrow_type)=
  begingroup
    save tail, head, t, ang;
    path ang;;
    ang = (-.75, .75){down} ... {(1,-.5)}origin & origin{(-1, -.5)} ... {down}(-.75, -.75);
    draw p;
    draw (ang scaled (cosd(ahangle/2)*ahlength) rotated (angle (direction infinity of p)) shifted (point infinity of p));
    t1 =arctime ((arclength p) - .5ahlength) of p;
    draw (ang scaled (cosd(ahangle/2)*ahlength) rotated (angle (direction t1 of p)) shifted (point t1 of p));
  endgroup;
enddef;

def draw_pmap (expr p)(text arrow_type)=
  begingroup
    save tail, head, t, ang;
    path ang;;
    ang =  (-.75, 1){down}..tension 1.2 ..origin --(-.75, 0);
    draw p;
    draw (ang scaled (cosd(ahangle/2)*ahlength) rotated (angle (direction infinity of p)) shifted (point infinity of p));
  endgroup;
enddef;

def draw_over (expr thickness)(text drawer)(expr p)(text arrow_type)=
  begingroup
    save pn;
    pen pn;
    pn = currentpen;
    pickup pencircle scaled thickness;
    draw p withcolor background;
    pickup pn;
  endgroup;
  drawer(p)(arrow_type);
enddef;

def draw_pmap_var (expr p)(text arrow_type)=
  begingroup
    save tail, head, t, ang;
    path ang;;
    ang =  (-.75, 0) --origin.. tension 1.2 ..{down} (-.75, -1);
    draw p;
    draw (ang scaled (cosd(ahangle/2)*ahlength) rotated (angle (direction infinity of p)) shifted (point infinity of p));
  endgroup;
enddef;

def draw_pmapsto (expr p)(text arrow_type)=
  begingroup
    save tail, head, t, ang;
    path ang;;
    ang =  (-.75, 1){down}..tension 1.2 ..origin --(-.75, 0);
    draw p;
    draw (ang scaled (cosd(ahangle/2)*ahlength) rotated (angle (direction infinity of p)) shifted (point infinity of p));
    map_tail(reverse p);
  endgroup;
enddef;


def epi  = gen_arrow(draw_epi)(straight_line) enddef;
def gen_curved_epi(expr theta) = gen_arrow(draw_epi)(curved_path(theta)) enddef;
def curved_epi  = gen_arrow(draw_epi)(curved_path(30)) enddef;
def draw_map_arrow (expr p)(text arrow_type)=
  begingroup
    save tail, head, t;
    path tail, head;
    t = middle_time(p);

    tail = reverse subpath (0,t) of p;
    head = subpath (t,infinity) of p;

    simple_arrow(head)(arrow_type);
    map_tail(tail);
  endgroup;
enddef;
def map_arrow = gen_arrow (draw_map_arrow)(straight_line)
enddef;

s_lambda := 3; % the length of the waves
s_angle := 60; % the angle of attack
vardef sinuous expr p =
  save ut; hide( ut := arctime s_lambda of p;)
    point 0 of p {curl 0} ..
    for i=1 step 2 until floor(length p / ut)-2:
    point     i*ut of p { (direction     i*ut of p) rotated +s_angle } ..
      point (i+1)*ut of p { (direction (i+1)*ut of p) rotated -s_angle } ..
  endfor
  { direction length p of p } point length p of p
enddef;
def wiggly_arrow(expr p)(text arrow_type)=
  drawarrow sinuous p arrow_type
enddef;



def straight_line (expr source, target) = source -- target enddef;
def curved_path (expr theta, source, target) =
  double_curved_path(theta, theta, source, target)
enddef;

def double_curved_path(expr theta, phi, source, target) =
  abs_double_curved_path(angle((target - source) rotated  theta),
                         angle((target - source) rotated -phi), source, target)
enddef;

def abs_double_curved_path(expr theta, phi, source, target) =
    source{dir theta} .. {dir phi}target
enddef;

def mor = gen_mor (straight_line) enddef;
def fmor = gen_arrow (wiggly_arrow)(straight_line) enddef;
def gen_curved_fmor(expr theta)=gen_arrow(wiggly_arrow)(curved_path(theta)) enddef;
def     curved_fmor            =gen_curved_fmor( 30) enddef;
def var_curved_fmor            =gen_curved_fmor(-30) enddef;
def over_mor = gen_arrow (draw_over(6pt)(simple_arrow))(straight_line) enddef;
def map = gen_arrow (draw_map_arrow)(straight_line) enddef;
def gen_curved_map(expr theta)=gen_arrow(draw_map_arrow)(curved_path(theta)) enddef;
def     curved_map = gen_curved_map(-30) enddef;
def var_curved_map = gen_curved_map(-30) enddef;
def pmor = gen_arrow(draw_pmap)(straight_line) enddef;
def pmap = gen_arrow(draw_pmapsto)(straight_line) enddef;
def var_pmor = gen_arrow(draw_pmap_var)(straight_line) enddef;
def gen_curved_pmor(expr theta)=gen_arrow(draw_pmap)(curved_path(theta)) enddef;
def     curved_pmor            =gen_curved_pmor( 30) enddef;
def var_curved_pmor            =gen_curved_pmor(-30) enddef;
def gen_curved_var_pmor(expr theta)=gen_arrow(draw_pmap_var)(curved_path(theta)) enddef;
def     curved_var_pmor            =gen_curved_var_pmor( 30) enddef;
def var_curved_var_pmor            =gen_curved_var_pmor(-30) enddef;
def empty_mor = gen_arrow (empty_arrow)(straight_line) enddef;
def edge= gen_arrow(simple_edge)(straight_line) enddef;
def symbol_mor(suffix src, tgt)(expr lab) = gen_arrow(symbol_arrow(lab))(straight_line)(src, tgt) enddef;
def isomor(suffix src, tgt) = gen_arrow(symbol_arrow("\isomorphic"))(straight_line)(src, tgt) enddef;

def equals_mor=gen_arrow(draw_equals)(straight_line) enddef;
def gen_curved_equals_mor(expr theta)=gen_arrow(draw_equals)(curved_path(theta)) enddef;
def curved_equals_mor=gen_curved_equals_mor(30) enddef;
def var_curved_equals_mor=gen_curved_equals_mor(-30) enddef;
def            ep_mor=gen_arrow(draw_ep)(straight_line) enddef;
def gen_curved_ep_mor(expr theta)=gen_arrow(draw_ep)(curved_path(theta)) enddef;
def     curved_ep_mor            =gen_curved_ep_mor( 30) enddef;
def            pe_mor=gen_arrow(draw_pe)(straight_line) enddef;
def gen_curved_pe_mor(expr theta)=gen_arrow(draw_pe)(curved_path(theta)) enddef;
def     curved_pe_mor            =gen_curved_pe_mor( 30) enddef;
def var_curved_pe_mor        =gen_curved_pe_mor(-30) enddef;
def gen_curved_mor (expr theta)= gen_mor (curved_path(theta)) enddef;
def curved_mor = gen_curved_mor(30) enddef;
def over_curved_mor = gen_arrow (draw_over(6pt)(simple_arrow))(curved_path(30)) enddef;
def var_curved_mor = gen_curved_mor(-30) enddef;
def over_var_curved_mor = gen_arrow (draw_over(6pt)(simple_arrow))(curved_path(-30)) enddef;
def gen_curved_qmon(expr theta) = gen_arrow(draw_qmonic)(curved_path(theta)) enddef;
def curved_qmon = gen_curved_qmon(30) enddef;
def var_curved_qmon = gen_curved_qmon(-30) enddef;
% Take two directions.
% Find middle direction.
% Find centre of tangent circle.
% Find radius.
%

def loop_makeri(expr src_dir, tgt_dir)(expr src, tgt) =
  begingroup
    save center, radius, t, circ, center_dir, aux;
    pair center;
    path circ;
    pair center_dir, aux;
    tgt_dir zscaled aux = src_dir;
    center_dir = dir(.5*angle aux + angle(tgt_dir));
    center = -.5u*unitvector(center_dir);
    radius = abs ypart(center rotated -angle src_dir);
    circ = fullcircle scaled radius shifted center;

    t1 = ypart ((origin .. (radius*src_dir + center))  intersectiontimes circ);
    t2 = ypart ((origin .. (radius*tgt_dir + center))  intersectiontimes circ);
    draw subpath (t1, t2) of circ shifted src;
    subpath (t1, t2) of circ shifted src
  endgroup
enddef;

def loop_maker(expr src_dir, tgt_dir)(expr src, tgt) =
  begingroup
        save control_point;
        pair control_point[];
        control_point1 = src + (.7u*right rotated (angle (tgt_dir + 2src_dir)));
        control_point2 = src + (.7u*right rotated (angle (2tgt_dir + src_dir)));
    src {src_dir} .. control_point1 .. control_point2
      .. {-tgt_dir}tgt
        endgroup
enddef;

def loopi_mor(suffix ob)(expr label)(suffix align) =
  begingroup
    path circ, temp;
    circ = fullcircle scaled .2u shifted (llcorner(ob.pic));
    temp = boundary ob.pic;
    t1 = ypart (temp intersectiontimes fullcircle);
    t2 = ypart (reverse temp intersectiontimes fullcircle);
    draw subpath (t1, t2) of fullcircle;
    draw circ;
  endgroup
enddef;

def loop_mor(suffix obj)(expr source_dir, target_dir)(expr label)(suffix align)=
        gen_mor(loop_maker(source_dir, target_dir))(obj, obj)(label, align)
enddef;

def explicit_mor_maker(expr mor_path)(expr src, tgt) =
        mor_path
enddef;

def explicit_mor(suffix source, target)(expr mor_path) =
        gen_mor(explicit_mor_maker(mor_path))(source, target)
enddef;

def explicit_map(suffix source, target)(expr mor_path) =
  gen_arrow
    (draw_map_arrow)
    (explicit_mor_maker(mor_path))
    (source, target)
enddef;

def commute (text objects) = commute_gen(objects)("=") enddef;
def commute_explained(text objects)(expr lab) =
  commute_gen(objects)("\NoArrowExplain={" & lab& "}") enddef;
def commute_explained_gen(text objects)(expr lab)(expr explain) =
  commute_gen(objects)("\NoArrowExplain{"& lab & "}{"& explain&"}") enddef;

def arb_commute_explained(expr loc)(expr lab) =
  label(texify("\NoArrowExplain={"&lab&"}"), loc);
enddef;

def commute_gen(text objects)(expr lab) =
        begingroup
                save n;
                save cen;
                pair cen;
                n = 0;
                (0,0) forsuffixes x = objects: + hide(n := n + 1) loc(x) endfor = n*cen;
                label(texify(lab), cen);
        endgroup;
enddef;

def connect_natural_transformation_diagram
        (suffix XFObj, XGObj, YFObj, YGObj)
        (expr fFLab)(suffix fFAlign)
        (expr fGLab)(suffix fGAlign)
        (expr XTransLab)(suffix XTransAlign)
        (expr YTransLab)(suffix YTransAlign)=
        if string fFLab:
                mor(XFObj, YFObj)(fFLab, fFAlign);
        fi
        if string fGLab:
        mor(XGObj, YGObj)(fGLab, fGAlign);
        fi
        if string XTransLab:
        mor(XFObj, XGObj)(XTransLab, XTransAlign);
        fi
        if string YTransLab:
        mor(YFObj, YGObj)(YTransLab, YTransAlign);
        fi
enddef;

def natural_transformation_objects
        (suffix XFObj)(expr XFLab, XFPos)
        (suffix XGObj)(expr XGLab, XGPos)
        (suffix YFObj)(expr YFLab, YFPos)
        (suffix YGObj)(expr YGLab, YGPos)
        =
        obj(XFObj)(XFLab);
        loc(XFObj) = XFPos;
        obj(XGObj)(XGLab);
        loc(XGObj) = XGPos;
        obj(YFObj)(YFLab);
        loc(YFObj) = YFPos;
        obj(YGObj)(YGLab);
        loc(YGObj) = YGPos;
        canonical_rectangle(XFPos, XGPos, YGPos, YFPos);

        drop(XFObj, XGObj, YFObj, YGObj);

enddef;


def natural_transformation_diagram
        (suffix XFObj)(expr XFLab, XFPos)
        (suffix XGObj)(expr XGLab, XGPos)
        (suffix YFObj)(expr YFLab, YFPos)
        (suffix YGObj)(expr YGLab, YGPos,
                                fFLab, fGLab,
                                XTransLab, YTransLab) =
        natural_transformation_objects
                (XFObj, XFLab, XFPos,
                 XGObj, XGLab, XGPos,
           YFObj, YFLab, YFPos,
                 YGObj, YGLab, YGPos)
connect_natural_transformation_diagram
                (XFObj, XGObj, YFObj, YGObj)
                (fFLab, lft, fGLab, rt, XTransLab, top, YTransLab, bot);
enddef;

def natural_transformation_aligned_diagram
        (suffix XFObj)(expr XFLab, XFPos)
        (suffix XGObj)(expr XGLab, XGPos)
        (suffix YFObj)(expr YFLab, YFPos)
        (suffix YGObj)(expr YGLab, YGPos)
                                (expr fFLab)(suffix fFAlign)
                                (expr fGLab)(suffix fGAlign)
                                (expr XTransLab)(suffix XTransAlign)
                                (expr YTransLab)(suffix YTransAlign)
        =
        natural_transformation_objects
                (XFObj, XFLab, XFPos,
                 XGObj, XGLab, XGPos,
           YFObj, YFLab, YFPos,
                 YGObj, YGLab, YGPos)
connect_natural_transformation_diagram
                (XFObj, XGObj, YFObj, YGObj)
                (fFLab, fFAlign, fGLab, fGAlign, XTransLab, XTransAlign, YTransLab, YTransAlign);
enddef;
def path_mor(expr p)(suffix x, y)(expr lab)(suffix align)text rest =
  begingroup
    save t, arc, s;
    path arc;
    t1 = xpart(p intersectiontimes (loc(x)--loc(x)));
    t2 = xpart(p intersectiontimes (loc(y)--loc(y)));

    arc = subpath (t1, t2) of p;
    gen_mor(constantly(arc))(x, y)(lab, align)rest
  endgroup
enddef;
def path_arrow(text arrow_drawer)(expr p)(suffix x, y)(expr lab)(suffix align)text rest =
  begingroup
    save t, arc, s;
    path arc;
    t1 = xpart(p intersectiontimes (loc(x)--loc(x)));
    t2 = xpart(p intersectiontimes (loc(y)--loc(y)));

    arc = subpath (t1, t2) of p;
    gen_arrow(arrow_drawer)(constantly(arc))(x, y)(lab, align)rest
  endgroup
enddef;

def pullback(expr inlen)(suffix f, g) suffix pb=
  begingroup
    save t, s, r, p;
    t = arctime inlen of f.arrow;
    s = arctime inlen of g.arrow;

    pair r;
    r = (point t of f.arrow) + whatever*(direction s of g.arrow)
      = (point s of g.arrow) + whatever*(direction t of f.arrow);

    path corn;
    corn = point t of f.arrow -- r -- point s of g.arrow;
    t1 = arctime (inlen/2) of corn;
    s1 = arctime (arclength corn - (inlen/2)) of corn;
    draw subpath (t1, s1) of corn;
    obj(pb)("");
    loc(pb) = r;
    drop(pb);
  endgroup;
enddef;

def pushout(expr inlen)(suffix f, g) suffix pb=
  begingroup
    save t, s, r, p;
    t = arctime inlen of reverse f.arrow;
    s = arctime inlen of reverse g.arrow;

    pair r;
    r = (point t of reverse f.arrow) + whatever*(direction s of reverse g.arrow)
      = (point s of reverse g.arrow) + whatever*(direction t of reverse f.arrow);

    path corn;
    corn = point t of reverse f.arrow -- r -- point s of reverse g.arrow;
    t1 = arctime (inlen/2) of corn;
    s1 = arctime (arclength corn - (inlen/2)) of corn;
    draw subpath (t1, s1) of corn;
    obj(pb)("");
    loc(pb) = r;
    drop(pb);
  endgroup;
enddef;


def pullback_exp(expr inlen_b, inlen_a)(suffix f, g) =
  begingroup
    save t, s, r, p;
    t = arctime inlen_a of f.arrow;
    s = arctime inlen_b of g.arrow;

    pair r;
    r = (point t of f.arrow) + whatever*(direction s of g.arrow)
      = (point s of g.arrow) + whatever*(direction t of f.arrow);

    path corn;
    corn = point t of f.arrow -- r -- point s of g.arrow;
    t1 = arctime (inlen_a/2) of corn;
    s1 = arctime (arclength corn - (inlen_b/2)) of corn;
    draw subpath (t1, s1) of corn;
  endgroup;
enddef;


def locs =
  map_suffixes(loc)
enddef;

def loop_morii(suffix obj)(expr radius, direc)(expr label)(suffix align)=
  gen_mor(loop_makerii(radius, direc))(obj, obj)(label, align)
enddef;

def loop_makerii(expr radius, direc)(expr src, tgt) =
    reverse fullcircle scaled .5u rotated 180 shifted (src + radius*dir(direc))
enddef;
