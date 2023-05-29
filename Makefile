all: programs/cvm-estimates.pdf programs/index.html

programs/cvm-estimates.pdf: supporting/get-all.py
	cd programs-orig && python3 ../supporting/get-all.py

programs/index.html: programs/index.md
	cd programs && pandoc -s index.md > index.html
