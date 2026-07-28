import os, csv as _csv, random, math, sys
from terms import random_normal_form, sample_distinct_terms, nf_key, num_vars_in_eq, to_rocq, to_idris, to_idris_term
from pathlib import Path


def make_header(system, theory, num_vars):
    if system == "rocq":
        if theory == "ring":
            header_file = "ring_header.v"
        else:
            header_file = "semiring_header.v"
        header_path = Path(__file__).parent / header_file
        return header_path.read_text(encoding="utf-8")
    if theory == "ring":
        header_file = "ring_header.idr"
    else:
        header_file = "semiring_header.idr"
    header_path = Path(__file__).parent / header_file
    content = header_path.read_text(encoding="utf-8")
    content = content.replace("VAR_COUNT", str(num_vars))
    model = "TestRing" if theory == "ring" else "TestSemiring"
    vars = ", ".join(f"X{i}" for i in range(num_vars))
    var_decl_type = f"{vars} : U {model} .Data.Model"
    var_decl = "\n".join(f"X{i} = {model} .Data.Env.H {i}" for i in range(num_vars))
    content = content.replace("VAR_DECL", f"{var_decl_type}\n{var_decl}")
    return content


def make_lemma(system, theory, lhs, rhs, name):
    n = num_vars_in_eq(lhs, rhs)
    if system == "rocq":
        vs = " ".join(f"x{i}" for i in range(n))
        return f"Lemma {name} : forall {vs}, {to_rocq(lhs)} == {to_rocq(rhs)}.\n" f"Proof. intros. ring. Qed."
    theory_str = "TestRing" if theory == "ring" else "TestSemiring"
    lhs_term = to_idris_term(lhs)
    rhs_term = to_idris_term(rhs)
    lhs = to_idris(lhs)
    rhs = to_idris(rhs)
    prf = f"{{prf = refl ({lhs})}}"
    xs = " ".join(f"{{x = X{i}}}" for i in range(n))
    return (
        f"{name} : {lhs} ~~ {rhs}\n"
        f"{name} = Free.solve {n} {{a = {theory_str} .Data.Model}} {theory_str}\n\t{prf}\n\t{xs}\n\t$ {lhs_term} =-= {rhs_term}"
    )


# ---------------------------------------------------------------------------
# Sampling: n_tests equations per (nb_var, size), via nfs_needed normal forms
# with terms_per_nf distinct terms each.
# ---------------------------------------------------------------------------


def make_pairs(terms, pairing):
    m = len(terms)
    if m < 2:
        return []
    if pairing == "chain":
        return [(terms[i], terms[i + 1]) for i in range(m - 1)]
    if pairing == "cycle":
        return [(terms[0], terms[1])] if m == 2 else [(terms[i], terms[(i + 1) % m]) for i in range(m)]
    if pairing == "with_canonical":
        return [(terms[0], terms[i]) for i in range(1, m)]
    if pairing == "all":
        return [(terms[i], terms[j]) for i in range(m) for j in range(i + 1, m)]
    raise ValueError(pairing)


def sample_equations_for_cell(n, size_target, n_tests, terms_per_nf, ring, rng, pairing="cycle"):
    if size_target < n:  # can't fit n distinct variables
        return []
    seen_nf, eqs = set(), []
    tries = 0
    max_tries = max(1, math.ceil(n_tests / terms_per_nf)) * 60 + 100
    while len(eqs) < n_tests and tries < max_tries:
        tries += 1
        P = random_normal_form(n, size_target, rng, ring)
        if P is None:
            break
        k = nf_key(P)
        if k in seen_nf:
            continue
        terms = sample_distinct_terms(P, size_target, terms_per_nf, n, rng, ring)
        if len(terms) < 2:
            continue
        seen_nf.add(k)
        eqs.extend(make_pairs(terms, pairing))
    return eqs[:n_tests]


# ---------------------------------------------------------------------------
# Generate one file per (system, theory, nb_var). Lemma names encode metadata:
#   eq_v<nb_var>_s<size>_i<id>   (both sides have exactly <size> leaves)
# ---------------------------------------------------------------------------


def generate_test_files(
    sizes,
    nb_vars_list,
    out_dir,
    *,
    n_tests=100,
    terms_per_nf=10,
    pairing="cycle",
    systems=("idris", "rocq"),
    theories=("semiring", "ring"),
    header_fn=make_header,
    lemma_fn=make_lemma,
    seed=0,
    exts=None,
):
    os.makedirs(out_dir, exist_ok=True)
    exts = exts or {"idris": ".idr", "rocq": ".v"}
    manifest = []

    for theory in theories:
        ring = theory == "ring"
        for n in nb_vars_list:
            eqs, eid = [], 0
            for s in sizes:
                rng = random.Random(f"{seed}-{theory}-{n}-{s}")  # reproducible
                cell = sample_equations_for_cell(n, s, n_tests, terms_per_nf, ring, rng, pairing)
                for lhs, rhs in cell:
                    name = f"eq_v{n}_s{s}_i{eid}"
                    eqs.append((eid, s, name, lhs, rhs))
                    eid += 1
                print(f"[{theory}, n={n}, size={s}] {len(cell)}/{n_tests} equations")

            for system in systems:
                fname = f"bench_{system}_{theory}_v{n}{exts[system]}"
                with open(os.path.join(out_dir, fname), "w") as f:
                    f.write(header_fn(system, theory, n) + "\n\n")
                    for _, _, name, lhs, rhs in eqs:
                        f.write(lemma_fn(system, theory, lhs, rhs, name) + "\n\n")
                for eid_, s, name, _, _ in eqs:
                    manifest.append((system, theory, n, eid_, s, name))

    with open(os.path.join(out_dir, "manifest.csv"), "w", newline="") as f:
        w = _csv.writer(f)
        w.writerow(["system", "theory", "nb_var", "id", "size", "name"])
        w.writerows(manifest)
    return manifest


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("usage: python3 generate.py <out_dir> <max_term_size> <tests_per_cell>")
        sys.exit(1)
    tests_per_cell = int(sys.argv[3])
    terms_per_nf = max(tests_per_cell // 5, 2)
    print(f"Parameters: max_term_size={sys.argv[2]}, tests_per_cell={tests_per_cell}, terms_per_nf={terms_per_nf}")
    generate_test_files(
        sizes=list(range(1, int(sys.argv[2]) + 1)),  # x-axis values
        nb_vars_list=[1, 5, 10, 15],
        out_dir=sys.argv[1],
        n_tests=tests_per_cell,  # tests per (nb_var, size)
        terms_per_nf=terms_per_nf,  # distinct terms per normal form
        pairing="cycle",
        seed=0,
    )
