#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob          # empty globs expand to nothing, not the literal

if [ "$#" -lt 2 ]; then
    echo "usage: $0 n0 n1 [n2 ...]   (increasing integers, e.g. 1 50 100)"
    exit 1
fi

# ---------------------------------------------------------------------------
# 1. Run the make pipeline for each consecutive range.
#    Input  1 50 100  ->  ranges 1-50 then 51-100
# ---------------------------------------------------------------------------
prev=$1
shift
first=1
for n in "$@"; do
    if [ "$first" -eq 1 ]; then
        min=$prev          # first range starts exactly at n0
        first=0
    else
        min=$((prev + 1))  # later ranges start one past the previous max
    fi
    max=$n
    echo "=== make MIN_TERM_SIZE=$min MAX_TERM_SIZE=$max ==="
    make MIN_TERM_SIZE="$min" MAX_TERM_SIZE="$max"
    make save
    make deep_clean
    prev=$n
done

# ---------------------------------------------------------------------------
# 2. Combine CSVs across all save_* folders, grouped by (system, theory).
#    save_*/idris_semiring_*.csv  ->  csv/idris_semiring_full.csv
# ---------------------------------------------------------------------------
mkdir -p csv

# discover the (system, theory) prefixes present across all save folders
groups=$(for f in save_*/*.csv; do basename "$f" | cut -d_ -f1,2; done | sort -u)

if [ -z "$groups" ]; then
    echo "no CSV files found in save_* folders"
    exit 0
fi

for key in $groups; do                       # key = e.g. idris_semiring
    files=(save_*/"${key}"_*.csv)
    [ ${#files[@]} -gt 0 ] || continue
    out="csv/${key}_full.csv"
    awk 'FNR==1 && NR!=1 {next} 1' "${files[@]}" > "$out"
    echo "wrote $out (${#files[@]} files)"
done

make plot