# Benchmarking suite

## Usage

Testing with big terms takes a lot of ram, therefore we recommend splitting the test size ranges.

To do so, one can run `bash scripts/run_all.sh n1 n2 ... nm` with the `ni` being increasing numbers, for instance `bash scripts/run_all.sh 1 50 100`.

One can also use the `Makefile` to run each step individually.
