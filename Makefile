# Run make -r all

all: programs/cvm-estimates.pdf programs/index.html

programs/index.html: supporting/index.md
	cd supporting && pandoc -c pandoc.css -s --embed-resources index.md > ../programs/index.html

programs-orig/LAST_FETCH: supporting/fetch-all.py
	cd programs-orig && uv run ../supporting/fetch-all.py
	touch programs-orig/LAST_FETCH

programs/cvm-estimates.pdf: supporting/build-all.py supporting/cwebmac.tex programs-orig/LAST_FETCH
	cd programs-orig && uv run ../supporting/build-all.py
