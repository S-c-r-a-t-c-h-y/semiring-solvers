MAX_TERM_SIZE ?= 30
TESTS_PER_CELL ?= 10

all: generate time collate plot

generate:
	mkdir -p generated
	(cd scripts && python3 generate.py ../generated	$(MAX_TERM_SIZE) $(TESTS_PER_CELL))

time:
	(cd generated && for file in `ls *.v`; do (coqc -time-file $${file}.log $${file}) done)
	(cd generated && for file in `ls *.idr`; do (idris2 -c --package contrib --package frex --timing auto $${file} 2>&1 > $${file}.log) done)

collate:
	scripts/collate.sh

plot:
	mkdir -p figures
	(cd scripts && python3 plots.py ../csv ../figures)

clean:
	rm -rf generated


.PHONY: all generate time collate plot clean