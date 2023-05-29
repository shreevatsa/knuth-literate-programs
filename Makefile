# Run make -r all

all: programs/cvm-estimates.pdf programs/index.html

programs/index.html: supporting/index.md
	cd supporting && pandoc -c pandoc.css -s --embed-resources index.md > ../programs/index.html

programs/cvm-estimates.pdf: supporting/get-all.py
	cd programs-orig && python3 ../supporting/get-all.py
