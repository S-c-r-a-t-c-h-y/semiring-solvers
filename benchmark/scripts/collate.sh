#!/bin/bash

set -ex

mkdir -p csv

for file in `ls log/*rocq*.log`; do python3 scripts/rocq_log_to_csv.py $file csv/$(basename $file).csv; done
for file in `ls log/*idris*.log`; do python3 scripts/idris_log_to_csv.py $file csv/$(basename $file).csv; done

params=$(ls csv | head -1 | grep -oP '[0-9]+-[0-9]+_[0-9]+(?=\.)')

awk 'FNR==1 && NR!=1 {next} 1' $(ls csv/*idris_semiring*.csv) > csv/idris_semiring_$params.csv
awk 'FNR==1 && NR!=1 {next} 1' $(ls csv/*idris_ring*.csv) > csv/idris_ring_$params.csv
# awk 'FNR==1 && NR!=1 {next} 1' $(ls csv/*rocq_semiring*.csv) > csv/rocq_semiring_$params.csv
# awk 'FNR==1 && NR!=1 {next} 1' $(ls csv/*rocq_ring*.csv) > csv/rocq_ring_$params.csv