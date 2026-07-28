from __future__ import annotations
from dataclasses import dataclass
from functools import lru_cache
from typing import Union, Dict, Tuple, List
import random
import math

# ---------------------------------------------------------------------------
# 1. Syntax tree (same tree for semirings and rings; Neg is simply not
#    generated for semirings).
# ---------------------------------------------------------------------------


@dataclass(frozen=True)
class Const:  # 0 or 1
    value: int


@dataclass(frozen=True)
class Var:
    idx: int


@dataclass(frozen=True)
class Neg:  # ring only
    a: "Term"


@dataclass(frozen=True)
class Add:
    l: "Term"
    r: "Term"


@dataclass(frozen=True)
class Mul:
    l: "Term"
    r: "Term"


Term = Union[Const, Var, Neg, Add, Mul]
ZERO, ONE = Const(0), Const(1)


@lru_cache(maxsize=None)
def size(t: Term) -> int:
    """Number of leaves. Neg (unary) contributes nothing."""
    if isinstance(t, (Const, Var)):
        return 1
    if isinstance(t, Neg):
        return size(t.a)
    return size(t.l) + size(t.r)  # Add / Mul


def max_var(t: Term) -> int:
    if isinstance(t, Var):
        return t.idx
    if isinstance(t, Const):
        return -1
    if isinstance(t, Neg):
        return max_var(t.a)
    return max(max_var(t.l), max_var(t.r))


def num_vars_in_eq(lhs: Term, rhs: Term) -> int:
    return max(max_var(lhs), max_var(rhs)) + 1


# -------------------- renderers  --------------------


def to_rocq(t: Term) -> str:
    if isinstance(t, Const):
        return str(t.value)
    if isinstance(t, Var):
        return f"x{t.idx}"
    if isinstance(t, Neg):
        return f"(- {to_rocq(t.a)})"
    if isinstance(t, Add):
        return f"({to_rocq(t.l)} + {to_rocq(t.r)})"
    if isinstance(t, Mul):
        return f"({to_rocq(t.l)} * {to_rocq(t.r)})"
    raise TypeError(t)


def to_idris(t: Term) -> str:
    if isinstance(t, Const):
        if t.value == 0:
            return "O1"
        if t.value == 1:
            return "I1"
        raise TypeError(t)
    if isinstance(t, Var):
        return f"X{t.idx}"
    if isinstance(t, Neg):
        return f"(neg {to_idris(t.a)})"
    if isinstance(t, Add):
        return f"({to_idris(t.l)} .+. {to_idris(t.r)})"
    if isinstance(t, Mul):
        return f"({to_idris(t.l)} .*. {to_idris(t.r)})"
    raise TypeError(t)


def to_idris_term(t: Term) -> str:
    if isinstance(t, Const):
        if t.value == 0:
            return "O2"
        if t.value == 1:
            return "I2"
        raise TypeError(t)
    if isinstance(t, Var):
        return f"(X {t.idx})"
    if isinstance(t, Neg):
        return f"(negT {to_idris_term(t.a)})"
    if isinstance(t, Add):
        return f"({to_idris_term(t.l)} :+: {to_idris_term(t.r)})"
    if isinstance(t, Mul):
        return f"({to_idris_term(t.l)} :*: {to_idris_term(t.r)})"
    raise TypeError(t)


# ---------------------------------------------------------------------------
# 2. Normal forms = multivariate polynomials.
#    key = ((exponent tuple, coeff), ...) sorted -> canonical, hashable
# ---------------------------------------------------------------------------

Poly = Dict[Tuple[int, ...], int]


def nf_const(n, v) -> Poly:
    return {} if v == 0 else {(0,) * n: 1}


def nf_var(n, i) -> Poly:
    return {tuple(1 if j == i else 0 for j in range(n)): 1}


def nf_neg(p) -> Poly:
    return {e: -c for e, c in p.items()}


def nf_add(p, q) -> Poly:
    r = dict(p)
    for e, c in q.items():
        nc = r.get(e, 0) + c
        if nc == 0:
            r.pop(e, None)
        else:
            r[e] = nc
    return r


def nf_mul(p, q) -> Poly:
    r: Poly = {}
    for e1, c1 in p.items():
        for e2, c2 in q.items():
            e = tuple(a + b for a, b in zip(e1, e2))
            nc = r.get(e, 0) + c1 * c2
            if nc == 0:
                r.pop(e, None)
            else:
                r[e] = nc
    return r


def normalize(t: Term, n: int) -> Poly:
    if isinstance(t, Const):
        return nf_const(n, t.value)
    if isinstance(t, Var):
        return nf_var(n, t.idx)
    if isinstance(t, Neg):
        return nf_neg(normalize(t.a, n))
    if isinstance(t, Add):
        return nf_add(normalize(t.l, n), normalize(t.r, n))
    if isinstance(t, Mul):
        return nf_mul(normalize(t.l, n), normalize(t.r, n))
    raise TypeError(t)


def nf_key(p: Poly):
    return tuple(sorted(p.items()))


def nf_vars_used(p: Poly, n):
    return {i for e in p for i, ei in enumerate(e) if ei}


# ---------------------------------------------------------------------------
# 3. Constructive term generation for a given normal form (polynomial).
# ---------------------------------------------------------------------------


def _random_fold(terms, op, rng):
    """Fold a list into a random binary tree using `op` (Add or Mul)."""
    terms = list(terms)
    while len(terms) > 1:
        i = rng.randrange(len(terms) - 1)
        a = terms.pop(i)
        b = terms.pop(i)  # two originally-adjacent items
        node = op(a, b) if rng.random() < 0.5 else op(b, a)
        terms.insert(i, node)
    return terms[0]


def _int_term(c, rng):
    """Term with normal form the constant c >= 1 (a sum of c ones)."""
    return _random_fold([ONE] * c, Add, rng)


def _filler(k, n, rng):
    """ANY term with exactly k leaves (value irrelevant: used inside 0*_)."""
    if k == 1:
        return rng.choice([ONE] + [Var(i) for i in range(n)]) if n else ONE
    a = rng.randint(1, k - 1)
    op = Add if rng.random() < 0.5 else Mul
    return op(_filler(a, n, rng), _filler(k - a, n, rng))


def one_term(k, rng):
    """Term with normal form 1 and exactly k leaves (a product of k ones)."""
    return ONE if k == 1 else _random_fold([ONE] * k, Mul, rng)


def zero_term(k, n, rng, ring):
    """Term with normal form 0 and exactly k leaves."""
    if k == 1:
        return ZERO
    if ring and k % 2 == 0 and rng.random() < 0.4:  # t + (-t)
        u = _filler(k // 2, n, rng)
        return Add(u, Neg(u)) if rng.random() < 0.5 else Add(Neg(u), u)
    f = _filler(k - 1, n, rng)  # 0 * filler
    return Mul(ZERO, f) if rng.random() < 0.5 else Mul(f, ZERO)


def _monomial_term(exp, coeff, rng, ring):
    factors = []
    for i, e in enumerate(exp):
        factors += [Var(i)] * e
    c = abs(coeff)
    if not factors:  # pure constant monomial
        term = _int_term(c, rng)
    else:
        if c != 1:
            factors.append(_int_term(c, rng))
        term = _random_fold(factors, Mul, rng)
    if ring and coeff < 0:
        term = Neg(term)  # no double negation is ever produced
    return term


def canonical_term(P, rng, ring):
    """A minimal-leaf term (randomised structure) with normal form P."""
    if not P:
        return ZERO
    monos = [_monomial_term(e, c, rng, ring) for e, c in P.items()]
    return _random_fold(monos, Add, rng)


def canonical_size(P):
    """Leaf count of canonical_term(P) (independent of association/order)."""
    if not P:
        return 1
    tot = 0
    for e, c in P.items():
        ac, exps = abs(c), sum(e)
        tot += ac if exps == 0 else exps + (0 if ac == 1 else ac)
    return tot


def _count_nodes(t):
    if isinstance(t, (Const, Var)):
        return 1
    if isinstance(t, Neg):
        return 1 + _count_nodes(t.a)
    return 1 + _count_nodes(t.l) + _count_nodes(t.r)


def wrap_random_node(t, wrapper, rng):
    """Replace a uniformly-random node u of t by wrapper(u)."""
    target = rng.randrange(_count_nodes(t))
    state = [0]

    def rec(u):
        cur = state[0]
        state[0] += 1
        if cur == target:
            return wrapper(u)
        if isinstance(u, Neg):
            return Neg(rec(u.a))
        if isinstance(u, Add):
            return Add(rec(u.l), rec(u.r))
        if isinstance(u, Mul):
            return Mul(rec(u.l), rec(u.r))
        return u

    return rec(t)


def grow_term(t, target, n, rng, ring):
    """Expand t (value-preserving) to EXACTLY `target` leaves."""
    cur = size(t)
    while cur < target:
        k = rng.randint(1, target - cur)
        if rng.random() < 0.5:
            f = zero_term(k, n, rng, ring)
            wrapper = lambda u, f=f: Add(u, f) if rng.random() < 0.5 else Add(f, u)
        else:
            f = one_term(k, rng)
            wrapper = lambda u, f=f: Mul(u, f) if rng.random() < 0.5 else Mul(f, u)
        t = wrap_random_node(t, wrapper, rng)
        cur += k
    return t


# ---------------------------------------------------------------------------
# 3b. Factored term construction (adds distributivity on top of assoc/order).
# ---------------------------------------------------------------------------


def _mono_gcd(monos, n):
    gexp = tuple(min(e[i] for e, _ in monos) for i in range(n))
    gc = 0
    for _, c in monos:
        gc = math.gcd(gc, abs(c))
    return gexp, gc


def _mono_div(e, c, gexp, gc):
    return tuple(e[i] - gexp[i] for i in range(len(e))), c // gc


def _try_factor(P, n, rng, ring, p_factor, depth, max_depth):
    """Pull out a nontrivial common factor from a subset of monomials."""
    monos = list(P.items())
    subsets = []
    # (a) monomials sharing a given variable -> guarantees a variable factor
    var_choices = [i for i in range(n) if sum(1 for e, _ in monos if e[i] > 0) >= 2]
    if var_choices:
        i = rng.choice(var_choices)
        subsets.append([(e, c) for e, c in monos if e[i] > 0])
    # (b) the whole set -> may expose a common coefficient factor (e.g. 2x+2y)
    subsets.append(monos)

    for S in subsets:
        if len(S) < 2:
            continue
        if len(S) > 2 and rng.random() < 0.5:  # random sub-subset
            S = rng.sample(S, rng.randint(2, len(S)))
        gexp, gc = _mono_gcd(S, n)
        if sum(gexp) == 0 and gc <= 1:  # trivial -> skip
            continue
        Q = {}
        for e, c in S:
            qe, qc = _mono_div(e, c, gexp, gc)
            Q[qe] = Q.get(qe, 0) + qc
        Q = {e: v for e, v in Q.items() if v}
        R = [(e, c) for (e, c) in monos if (e, c) not in S]

        gterm = _monomial_term(gexp, gc, rng, ring)  # the pulled-out factor
        qterm = poly_to_term(Q, n, rng, ring, p_factor, depth + 1, max_depth)
        fac = Mul(gterm, qterm) if rng.random() < 0.5 else Mul(qterm, gterm)
        if R:
            rterm = poly_to_term(dict(R), n, rng, ring, p_factor, depth + 1, max_depth)
            return Add(fac, rterm) if rng.random() < 0.5 else Add(rterm, fac)
        return fac
    return None


def poly_to_term(P, n, rng, ring, p_factor=0.6, depth=0, max_depth=12):
    """
    Build a term whose normal form is P, mixing:
      - distributed style  (split the sum into two groups), and
      - factored  style    (pull out a common monomial factor),
    with randomised association/order throughout.
    """
    monos = list(P.items())
    if not monos:
        return ZERO
    if len(monos) == 1:
        ((e, c),) = monos
        return _monomial_term(e, c, rng, ring)

    if depth < max_depth and rng.random() < p_factor:
        t = _try_factor(P, n, rng, ring, p_factor, depth, max_depth)
        if t is not None:
            return t

    rng.shuffle(monos)  # distributed fallback
    k = rng.randint(1, len(monos) - 1)
    ta = poly_to_term(dict(monos[:k]), n, rng, ring, p_factor, depth + 1, max_depth)
    tb = poly_to_term(dict(monos[k:]), n, rng, ring, p_factor, depth + 1, max_depth)
    return Add(ta, tb) if rng.random() < 0.5 else Add(tb, ta)


def random_term_for_poly(P, target_size, n, rng, ring, p_factor=0.6):
    """A term with normal form P and EXACTLY target_size leaves (or None)."""
    base = poly_to_term(P, n, rng, ring, p_factor=p_factor)
    if size(base) > target_size:  # factored form only shrinks it,
        return None  # so this rarely triggers
    return grow_term(base, target_size, n, rng, ring)


def sample_distinct_terms(P, target_size, count, n, rng, ring, max_attempts=None):
    if max_attempts is None:
        max_attempts = count * 30 + 50
    seen, out = set(), []
    for _ in range(max_attempts):
        if len(out) >= count:
            break
        t = random_term_for_poly(P, target_size, n, rng, ring)
        if t is None:
            break
        key = to_rocq(t)  # canonical string -> dedup
        if key not in seen:
            seen.add(key)
            out.append(t)
    return out


# ---------------------------------------------------------------------------
# 4. Random normal forms with EXACTLY n variables that fit the size budget.
# ---------------------------------------------------------------------------


def random_normal_form(n, size_limit, rng, ring, max_tries=300, max_mono=3, max_exp=2, max_coeff=2):
    for _ in range(max_tries):
        P = {}
        for _ in range(rng.randint(1, max_mono)):
            exp = tuple(rng.randint(0, max_exp) for _ in range(n))
            if ring:
                c = rng.choice([x for x in range(-max_coeff, max_coeff + 1) if x])
            else:
                c = rng.randint(1, max_coeff)
            P[exp] = P.get(exp, 0) + c
        P = {e: v for e, v in P.items() if v}
        for v in set(range(n)) - nf_vars_used(P, n):  # force missing variables
            e = tuple(1 if j == v else 0 for j in range(n))
            add = rng.choice([-1, 1]) if ring else 1
            P[e] = P.get(e, 0) + add or 1
        P = {e: v for e, v in P.items() if v}
        if not P or len(nf_vars_used(P, n)) != n:
            continue
        if canonical_size(P) <= size_limit:
            return P
    return None
