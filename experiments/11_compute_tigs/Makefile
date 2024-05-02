.PHONY: all help clean cleanall format

SHELL=/usr/bin/env bash -eo pipefail

.SECONDARY:

.SUFFIXES:

all: bcalm prophasm
	snakemake -p -j 3 --rerun-incomplete --keep-going --rerun-triggers mtime

test: bcalm prophasm
	snakemake -p -j all --rerun-incomplete --config testing=True

bcalm:
	mkdir bcalm/build
	cmake bcalm/
	$(MAKE) -j 8 -C bcalm/build

prophasm:
	$(MAKE) -j 8 -C prophasm/

format:
	snakefmt Snakefile

help: ## Print help message
	@echo "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s : | sort)"

clean: ## Clean
	rm -f output_fastas/*.{gz,xz,xz_*}

cleanall: clean ## Clean all
	rm -f logs/*/*.{log,txt,tmp}


