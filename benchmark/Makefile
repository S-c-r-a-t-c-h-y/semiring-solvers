MIN_TERM_SIZE ?= 1
MAX_TERM_SIZE ?= 30
TESTS_PER_CELL ?= 10

all: generate time collate plot

generate:
	mkdir -p generated
	(cd scripts && python3 generate.py ../generated $(MIN_TERM_SIZE)	$(MAX_TERM_SIZE) $(TESTS_PER_CELL))

time:
	mkdir -p log
# 	(cd generated && for file in `ls *.v`; do (coqc -time-file ../log/$${file}.log $${file}) done)
	(cd generated && for file in `ls *.idr`; do \
	    	(echo "$$(date +"%d/%m/%Y - %T.%3N") : timing $${file}"; \
				idris2 -c --package contrib --package frex --timing auto $${file} 2>&1 > ../log/$${file}.log; \
				echo "$$(date +"%d/%m/%Y - %T.%3N") : done timing $${file}") done)

time_parallel:
	mkdir -p log
# 	(cd generated && for file in `ls *.v`; do (coqc -time-file ../log/$${file}.log $${file}) done)
	(cd generated && ls *.idr | xargs -P 8 -I {} sh -c \
			'echo "$$(date +"%d/%m/%Y - %T.%3N") : timing {}"; idris2 -c --package contrib --package frex --timing auto {} > ../log/{}.log 2>&1; \
			echo "$$(date +"%d/%m/%Y - %T.%3N") : done timing {}"')

collate:
	scripts/collate.sh

plot:
	mkdir -p figures
	(cd scripts && python3 plots.py ../csv ../figures)

.ONESHELL:
save:
	save_dir=save_$$(ls csv | head -1 | grep -oP '[0-9]+-[0-9]+_[0-9]+(?=\.)')
	[ "$$save_dir" != "save_" ] || { echo "could not parse params"; exit 1; }
	mkdir -p "$$save_dir"
	for file in $$(ls csv | grep -v '^bench'); do mv "csv/$$file" "$$save_dir/"; done
	for file in $$(ls figures); do mv "figures/$$file" "$$save_dir/"; done

clean:
	rm -rf generated build

deep_clean:
	rm -rf generated log csv figures build

.PHONY: all generate time time_parallel collate plot save clean deep_clean