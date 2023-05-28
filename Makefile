all: mine/get-all.py
	cd programs-orig && python3 ../mine/get-all.py
	cd programs-orig && wget -N "https://www.cs.stanford.edu/~knuth/programs/cvm-estimates.w"
