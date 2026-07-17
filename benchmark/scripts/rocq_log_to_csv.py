import re
import csv
import sys

# time may be "0.014", "0." (zero!), "0", or ".5"
LINE_RE = re.compile(r"\[(?P<body>.*)\]\s+(?P<time>\d+\.?\d*|\.\d+)\s+secs")
NAME_RE = re.compile(r"eq_v(?P<nb_var>\d+)_s(?P<size>\d+)_i(?P<id>\d+)")


def log_to_csv(log_path, csv_path):
    rows = []
    current = None  # (id, nb_var, size) of the lemma being read

    with open(log_path, "r") as f:
        for line in f:
            m = LINE_RE.search(line)
            if not m:
                continue
            body = m.group("body").strip()
            time = float(m.group("time"))  # float("0.") == 0.0

            if body.startswith("Lemma~"):
                nm = NAME_RE.search(body)
                current = None
                if nm:
                    current = (int(nm.group("id")), int(nm.group("nb_var")), int(nm.group("size")))
                continue

            if body.rstrip(".") == "ring" and current is not None:
                eid, nb_var, size = current
                rows.append((eid, nb_var, size, time))
                current = None

    rows.sort()
    with open(csv_path, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["id", "nb_var", "size", "time"])
        w.writerows(rows)

    print(f"{len(rows)} lemmas written to {csv_path}")
    return rows


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("usage: python3 rocq_log_to_csv.py <rocq_timing.log> <out.csv>")
        sys.exit(1)
    log_to_csv(sys.argv[1], sys.argv[2])
