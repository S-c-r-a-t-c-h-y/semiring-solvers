#!/bin/bash

set -ex

mkdir -p csv

for file in `ls log/*rocq*.log`; do python3 scripts/rocq_log_to_csv.py $file csv/$(basename $file).csv; done
for file in `ls log/*idris*.log`; do python3 scripts/idris_log_to_csv.py $file csv/$(basename $file).csv; done

awk 'FNR==1 && NR!=1 {next} 1' $(ls csv/*idris_semiring*.csv) > csv/idris_semiring.csv
awk 'FNR==1 && NR!=1 {next} 1' $(ls csv/*rocq_semiring*.csv) > csv/rocq_semiring.csv
awk 'FNR==1 && NR!=1 {next} 1' $(ls csv/*idris_ring*.csv) > csv/idris_ring.csv
awk 'FNR==1 && NR!=1 {next} 1' $(ls csv/*rocq_ring*.csv) > csv/rocq_ring.csv