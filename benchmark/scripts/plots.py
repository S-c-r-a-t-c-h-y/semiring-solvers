import sys
import os
import glob
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D
from matplotlib.ticker import FuncFormatter

DEFAULT_THRESHOLDS = [
    (0.1, "instantaneity threshold"),
    (1.0, "interactivity threshold"),
    (10.0, "attention threshold"),
]
OKABE_ITO = ["#0072B2", "#E69F00", "#009E73", "#D55E00", "#CC79A7", "#56B4E9", "#F0E442", "#000000"]
MARKERS = ["o", "s", "^", "D", "v", "P", "X", "*"]


def _load_clean(path, time_floor, total_size):
    df = pd.read_csv(path)
    for col in ("nb_var", "size", "time"):
        df[col] = pd.to_numeric(df[col], errors="coerce")
    df = df.dropna(subset=["nb_var", "size", "time"]).drop_duplicates()
    df["nb_var"] = df["nb_var"].astype(int)
    df["size"] = df["size"].astype(int)
    if total_size:  # per-side -> whole equation (LHS+RHS)
        df["size"] = df["size"] * 2
    df["time"] = df["time"].clip(lower=time_floor)  # log axis: no zeros
    return df


# Human-readable second labels: 0.001s, 0.01s, 0.1s, 1s, 10s, ...
def _fmt_secs(y, _pos):
    if y <= 0:
        return ""
    if y >= 1:
        return f"{y:g}s"  # 1s, 10s, 100s
    # sub-second: strip trailing zeros, keep as decimal (0.1s, 0.01s, ...)
    return f"{y:g}s".replace("0.", ".") if False else f"{y:g}s"


def plot_theory(
    csv_by_system,
    theory,
    out_path,
    *,
    agg="median",
    time_floor=1e-3,
    point_size=22,
    total_size=True,
    thresholds=DEFAULT_THRESHOLDS,
    include_thresholds_in_range=True,
    xmax=None,
):
    data, nbvs = {}, set()
    for system, path in csv_by_system.items():
        df = _load_clean(path, time_floor, total_size)
        if df.empty:
            print(f"[warn] {path}: no usable rows")
            continue
        data[system] = df
        nbvs.update(df["nb_var"].unique().tolist())
    if not data:
        print(f"[warn] nothing to plot for {theory}")
        return None

    nbv_sorted = sorted(nbvs)
    color = {v: OKABE_ITO[i % len(OKABE_ITO)] for i, v in enumerate(nbv_sorted)}
    marker = {v: MARKERS[i % len(MARKERS)] for i, v in enumerate(nbv_sorted)}
    systems = sorted(data)
    filled = {s: (i == 0) for i, s in enumerate(systems)}  # 1st system filled

    fig, ax = plt.subplots(figsize=(8, 3.6))
    tmin, tmax = float("inf"), 0.0
    for system in systems:
        df = data[system]
        for nbv in nbv_sorted:
            g = df[df["nb_var"] == nbv]
            if g.empty:
                continue
            a = g.groupby("size")["time"].agg(agg).reset_index().sort_values("size")
            common = dict(s=point_size, marker=marker[nbv], linewidths=0.7)
            if filled[system]:
                ax.scatter(a["size"], a["time"], color=color[nbv], edgecolors="white", **common)
            else:
                ax.scatter(a["size"], a["time"], facecolors="none", edgecolors=color[nbv], **common)
            tmin = min(tmin, float(a["time"].min()))
            tmax = max(tmax, float(a["time"].max()))

    ax.set_yscale("log")
    if xmax is None:
        xmax = max(int(df["size"].max()) for df in data.values())
    ax.set_xlim(0, xmax + 1)

    ax.yaxis.set_major_formatter(FuncFormatter(_fmt_secs))
    ax.yaxis.set_minor_formatter(FuncFormatter(lambda y, _p: ""))  # hide minor labels

    lo = tmin * 0.7
    hi = tmax * 1.6
    if include_thresholds_in_range and thresholds:
        hi = max(hi, max(y for y, _ in thresholds) * 1.8)
    ax.set_ylim(lo, hi)

    # for y, label in thresholds:
    #     if lo <= y <= hi:
    #         ax.axhline(y, color="0.5", lw=0.8, ls="--")
    #         ax.text(xmax, y * 1.05, label, ha="right", va="bottom", fontsize=8, color="0.35")

    for y, label in thresholds:
        if lo <= y <= hi:
            ax.axhline(y, color="0.5", lw=0.8, ls="--")
            ax.text(1, y * 1.15, label, ha="left", va="bottom", fontsize=8, color="0.35")

    ax.set_xlabel("term size (leaves, LHS + RHS)" if total_size else "term size (leaves)")
    ax.set_ylabel("runtime (s)")
    ax.set_title(f"commutative {theory} solver type-checking times")

    var_handles = [Line2D([0], [0], color=color[v], marker=marker[v], ls="", ms=6, markeredgecolor="white") for v in nbv_sorted]
    var_labels = [f"{v} free var" + ("" if v == 1 else "s") for v in nbv_sorted]
    sys_handles = []
    for s in systems:
        if filled[s]:
            sys_handles.append(Line2D([0], [0], color="black", marker="o", ls="", ms=6, markeredgecolor="white"))
        else:
            sys_handles.append(Line2D([0], [0], marker="o", ls="", ms=6, markerfacecolor="none", markeredgecolor="black"))

    # ax.legend(var_handles, var_labels, title="free variables", loc="lower right", fontsize=8)
    ax.legend(var_handles, var_labels, title="free variables", loc="upper left", bbox_to_anchor=(1.01, 1.0), fontsize=8, borderaxespad=0.0)

    fig.tight_layout()
    fig.savefig(out_path, dpi=150, bbox_inches="tight")
    plt.close(fig)
    print(f"wrote {out_path}")
    return out_path


def make_all_plots(csv_paths, out_dir, **kwargs):
    os.makedirs(out_dir, exist_ok=True)
    outs = []
    for theory in sorted({th for _, th in csv_paths}):
        by_system = {s: p for (s, th), p in csv_paths.items() if th == theory}
        outs.append(plot_theory(by_system, theory, os.path.join(out_dir, f"benchmark_{theory}.png"), **kwargs))
    return outs


def find_csv(in_dir, system, theory):
    """Find the CSV for a (system, theory), whatever the params suffix is."""
    pattern = f"{in_dir}/{system.lower()}_{theory}_*.csv"
    matches = sorted(glob.glob(pattern))
    if not matches:
        return None
    if len(matches) > 1:
        print(f"[warn] multiple files match {pattern}: {matches}; using {matches[0]}")
    return matches[0]


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("usage: python3 plots.py <in_dir> <out_dir>")
        sys.exit(1)

    in_dir = sys.argv[1]

    wanted = [
        ("Idris", "semiring"),
        # ("Rocq", "semiring"),
        ("Idris", "ring"),
        # ("Rocq", "ring"),
    ]

    csv_paths = {}
    for system, theory in wanted:
        path = find_csv(in_dir, system, theory)
        if path is None:
            print(f"[warn] no CSV found for {system} {theory}, skipping")
            continue
        csv_paths[(system, theory)] = path

    if not csv_paths:
        print("no CSV files found; nothing to plot")
        sys.exit(1)

    make_all_plots(csv_paths, sys.argv[2])
