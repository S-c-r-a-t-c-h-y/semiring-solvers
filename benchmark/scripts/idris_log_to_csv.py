import sys, re, csv

CHECK_RE = re.compile(r"TIMING \+* Check RHS .*: (?P<timing>[0-9.]+)s\s*$")
NAME_LINE_RE = re.compile(r"TIMING \+* Building compile time case tree for Main\.(?P<name>\S+):")
NAME_RE = re.compile(r"eq_v(?P<nb_var>\d+)_s(?P<size>\d+)_i(?P<id>\d+)")


def log_to_csv(log_path, csv_path):
    rows = []
    pending_time = None  # time from the last 'Check RHS' line

    with open(log_path) as fin:
        for line in fin:
            m = CHECK_RE.match(line)
            if m:
                pending_time = float(m.group("timing"))
                continue

            m = NAME_LINE_RE.match(line)
            if m and pending_time is not None:
                nm = NAME_RE.search(m.group("name"))
                if nm:
                    rows.append((int(nm.group("id")), int(nm.group("nb_var")), int(nm.group("size")), pending_time))
                pending_time = None  # consume it, matched or not
                continue

    rows.sort()
    with open(csv_path, "w", newline="") as fout:
        w = csv.writer(fout)
        w.writerow(["id", "nb_var", "size", "time"])
        w.writerows(rows)

    print(f"{len(rows)} lemmas written to {csv_path}")
    return rows


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("usage: python idris_log_to_csv.py <idris_timing.log> <out.csv>")
        sys.exit(1)
    log_to_csv(sys.argv[1], sys.argv[2])
